#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )  

# Configuration
USERNAME="ubuntu"
PASSWORD="password123"
ISO_NAME="$SCRIPT_DIR/artifacts/cloud-init.iso"

# Create user-data
cat > "user-data" <<EOF
#cloud-config
users:
  - default
  - name: $USERNAME
    plain_text_passwd: '$PASSWORD'
    lock_passwd: false
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL

chpasswd:
  expire: false

ssh_pwauth: true
EOF

# Create meta-data
cat > "meta-data" <<EOF
instance-id: iid-local01
local-hostname: ubuntu-vm
EOF

# Create ISO
rm $ISO_NAME
genisoimage -output "$ISO_NAME" -volid cidata -joliet -rock user-data meta-data

echo "✅ Cloud-init ISO '$ISO_NAME' created successfully."

