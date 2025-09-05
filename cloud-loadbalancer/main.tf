resource "google_compute_instance" "nginx_vm" {
  count        = 3
  name         = "nginx-vm-${count.index}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Required for external IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOT

  tags = ["nginx"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["nginx"]
  direction   = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance_group" "nginx_group" {
  name        = "nginx-group"
  zone        = var.zone
  instances   = google_compute_instance.nginx_vm[*].self_link
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "default" {
  name                            = "nginx-backend"
  protocol                        = "HTTP"
  port_name                       = "http"
  timeout_sec                     = 10
  health_checks                   = [google_compute_health_check.http_health_check.id]
  backend {
    group = google_compute_instance_group.nginx_group.self_link
  }
}

resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name   = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-rule"
  target                = google_compute_target_http_proxy.default.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}
