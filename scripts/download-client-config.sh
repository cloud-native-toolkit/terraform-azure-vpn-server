#!/usr/bin/env bash

# Ensure right permissions on private key
chmod 400 ${KEY_FILE}

# Generate client configuration on remote VPN server
ssh -o "StrictHostKeyChecking no" -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} << EOF
  sudo /usr/local/openvpn_as/scripts/sacli --user openvpn --key "prop_autologin" --value "true" UserPropPut 
  sudo /usr/local/openvpn_as/scripts/sacli --prefer-tls-crypt-v2 --user openvpn GetAutologin > /home/${VM_USERNAME}/${CLIENT_CONFIG_FILE}
  sudo chown ${VM_USERNAME} /home/${VM_USERNAME}/${CLIENT_CONFIG_FILE}
EOF

# Copy generated client configuration to local working directory
scp -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/${CLIENT_CONFIG_FILE} ${WORK_DIR}/${CLIENT_CONFIG_FILE}
