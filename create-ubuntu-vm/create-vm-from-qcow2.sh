#!/bin/bash
set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# First create the cloud-init ISO
$SCRIPT_DIR/create-cloudinit-iso.sh

# Download the base disk from cloud-images.ubuntu.com
# https://cloud-images.ubuntu.com/jammy/20250523/jammy-server-cloudimg-amd64-disk-kvm.img
BASE_UBUNTU_IMAGE="$SCRIPT_DIR/artifacts/jammy-server-cloudimg-amd64-disk-kvm.img"

# VM Configuration
VM_NAME="ubuntu-vm"
RAM_MB=8192
VCPUS=4
DISK_SIZE_GB=100
DISK_PATH="$SCRIPT_DIR/artifacts/${VM_NAME}-disk.qcow2"

echo "Creating disk image..."
qemu-img create -F qcow2 -f qcow2 -b $BASE_UBUNTU_IMAGE $DISK_PATH

NETWORK="default"

# Install the VM
echo "Starting VM installation..."
virt-install \
  --name "$VM_NAME" \
  --ram "$RAM_MB" \
  --vcpus "$VCPUS" \
  --os-type linux \
  --os-variant ubuntu22.04 \
  --cdrom $SCRIPT_DIR/artifacts/cloud-init.iso \
  --import \
  --boot hd \
  --disk path="$DISK_PATH",format=qcow2 \
  --graphics none \
  --console pty,target_type=serial


echo "VM '$VM_NAME' installation initiated."

