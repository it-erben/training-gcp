#!/bin/bash

# Set variables
ZONE="europe-west1-b"
MACHINE_TYPE="f1-micro" # Free tier eligible machine type
IMAGE_FAMILY="debian-10"
IMAGE_PROJECT="debian-cloud"

# Function to create a VM
create_vm() {
  local VM_NAME=$1
  gcloud compute instances create $VM_NAME \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --image-family=$IMAGE_FAMILY \
    --image-project=$IMAGE_PROJECT \
    --metadata=startup-script="#! /bin/bash
      sudo apt-get update
      sudo apt-get install -y stress
      # Run stress command to utilize CPU at around 75%
      stress --cpu 4 --timeout 300 &
    "
}

# Create 4 VMs
for i in {1..4}; do
  VM_NAME="compute-vm-$i"
  create_vm $VM_NAME
done

echo "4 VMs created and started with high CPU utilization."

# Instructions for the user
echo "To stop the VMs, use the following command:"
echo "gcloud compute instances stop compute-vm-1 compute-vm-2 compute-vm-3 compute-vm-4 --zone=$ZONE"

echo "To delete the VMs, use the following command:"
echo "gcloud compute instances delete compute-vm-1 compute-vm-2 compute-vm-3 compute-vm-4 --zone=$ZONE"
