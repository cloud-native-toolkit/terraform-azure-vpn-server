#!/usr/bin/env bash

ssh -o "StrictHostKeyChecking no" -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} "sudo /usr/sbin/sacli ConfigQuery > /home/${VM_USERNAME}/config.json"
scp -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/config.json ${WORK_DIR}/${CONFIG_FILE_NAME}