terraform {
  required_version = ">= 1.0"

  backend "http" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {}
