#!/usr/bin/env bash
set -euo pipefail
set -x

terraform init

PROJECT_ID="$(gcloud config get-value project)"
export PROJECT_ID
terraform apply -var "project=$PROJECT_ID" -auto-approve

sleep 360s

terraform destroy -var "project=$PROJECT_ID" -auto-approve
