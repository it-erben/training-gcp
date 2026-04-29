data "google_organization" "org" {
  domain = var.org_domain
}

resource "google_folder" "training" {
  display_name = "GFU Training"
  parent       = data.google_organization.org.name
}

# --- Teacher project (always exists) ---

resource "google_project" "teacher" {
  name            = "gfu-training-teacher"
  project_id      = "gfu-training-teacher"
  folder_id       = google_folder.training.name
  billing_account = var.billing_account

  deletion_policy = "DELETE"
}

resource "google_project_iam_member" "teacher_editor" {
  project = google_project.teacher.project_id
  role    = "roles/editor"
  member  = "user:${var.trainer_email}"
}

# --- Student projects ---

resource "google_project" "student" {
  count = var.student_count

  name            = "gfu-training-student-${format("%02d", count.index + 1)}"
  project_id      = "gfu-training-student-${format("%02d", count.index + 1)}"
  folder_id       = google_folder.training.name
  billing_account = var.billing_account

  deletion_policy = "ABANDON"
}

resource "google_project_iam_member" "student_owner" {
  count = var.student_count

  project = google_project.student[count.index].project_id
  role    = "roles/owner"
  member  = "user:student${format("%02d", count.index + 1)}@${var.org_domain}"
}
