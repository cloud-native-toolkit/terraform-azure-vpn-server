#!/usr/bin/env bash

chmod 400 ${KEY_FILE}
ssh -o "StrictHostKeyChecking no" -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} "pwd ; sudo cp /root/client.ovpn .; sudo ls"
scp -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/client.ovpn ${WORK_DIR}/${CLIENT_CONFIG_FILE}

## Update Client configuration
if [ -e "${WORK_DIR}/${CLIENT_CONFIG_FILE}" ]; then

    ## Change VPN server private IP address to public IP address
    OS_TYPE=$(uname -a | awk '{print $1}')
    if [[ "${OS_TYPE}" == "Darwin" ]]; then
        sed -i '' "s/remote ${VM_PRIVATE_IP}/remote ${VM_PUBLIC_IP}/g" ${WORK_DIR}/${CLIENT_CONFIG_FILE}
    elif [[ "${OS_TYPE}" == "Linux" ]]; then
        sed -i "s/remote ${VM_PRIVATE_IP}/remote ${VM_PUBLIC_IP}/g" ${WORK_DIR}/${CLIENT_CONFIG_FILE}
    else
        echo "ERROR: Unknown operating system ${OS_TYPE}"
        exit 2
    fi
    echo "Client configuration ${CLIENT_CONFIG_FILE} updated."
else
    echo "ERROR: Client configuration ${CLIENT_CONFIG_FILE} not found in ${WORK_DIR}."
    exit 2
fi