#!/usr/bin/env sh
set -euxo

terraform init

export PROJECT_ID
PROJECT_ID="$(gcloud config get-value project)"
terraform apply -var "project=$PROJECT_ID" -auto-approve

sleep 360s

terraform destroy -var "project=$PROJECT_ID" -auto-approve
