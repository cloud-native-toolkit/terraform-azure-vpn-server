#!/usr/bin/env bash

echo "Applying ${WORK_DIR}/${CONFIG_FILE} to VPN server ${VM_PUBLIC_IP}"

# Save current default config
ssh -o "StrictHostKeyChecking no" -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} << EOF
  sudo /usr/local/openvpn_as/scripts/sacli configQuery > ~/default-vpn-config.json
EOF

# Upload required config
scp -i ${KEY_FILE} ${WORK_DIR}/${CONFIG_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/

# Enable new config and restart server
ssh -o "StrictHostKeyChecking no" -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} << EOF
  sudo /usr/local/openvpn_as/scripts/sacli --value_file=/home/${VM_USERNAME}/${CONFIG_FILE} ConfigReplace
  sudo /usr/local/openvpn_as/scripts/sacli start
EOF
