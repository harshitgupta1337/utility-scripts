#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# VM Configuration
VM_NAME="ubuntu-vm"
RAM_MB=8192
VCPUS=4
DISK_SIZE_GB=100
ISO_PATH="$SCRIPT_DIR/artifacts/ubuntu-22.04.5-live-server-amd64.iso"
DISK_PATH="$SCRIPT_DIR/artifacts/${VM_NAME}-disk.qcow2"
NETWORK="default"

# Create disk image
echo "Creating disk image..."
qemu-img create -f qcow2 "$DISK_PATH" "${DISK_SIZE_GB}G"

# Install the VM
echo "Starting VM installation..."
virt-install \
  --name "$VM_NAME" \
  --virt-type kvm \
  --ram "$RAM_MB" \
  --vcpus "$VCPUS" \
  --os-variant ubuntu22.04 \
  --hvm \
  --location $ISO_PATH,kernel=casper/hwe-vmlinuz,initrd=casper/hwe-initrd \
  --disk path="$DISK_PATH",format=qcow2 \
  --network network="$NETWORK" \
  --graphics none \
  --console pty,target_type=serial \
  --extra-args 'console=ttyS0,115200n8 serial autoinstall'


  #--graphics vnc

  #--boot loader=/usr/share/OVMF/OVMF_CODE_4M.ms.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/OVMF/OVMF_VARS_4M.ms.fd,loader.secure='no' \

echo "VM '$VM_NAME' installation initiated."

