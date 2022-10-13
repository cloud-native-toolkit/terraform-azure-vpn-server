#!/bin/sh

VM_PRIVATE_IP=$1
VM_PUBLIC_IP=$2

KEY_FILE=$3
VM_USERNAME=$4

CLIENT_CONFIG_FILE=client.ovpn

echo "Waiting to finish execution of bootstrap script!."
sleep 120

ssh -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP} "pwd ; sudo cp /root/client.ovpn .; sudo ls"

scp -i ${KEY_FILE} ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/${CLIENT_CONFIG_FILE} .

## Update Client configuration
if [ -e $CLIENT_CONFIG_FILE ]; then
    line_numbers=`cat ${CLIENT_CONFIG_FILE} |grep -n 'remote '|cut -d ':' -f1`

    for num in ${line_numbers}
    do
        sed -n ${num}p ${CLIENT_CONFIG_FILE} | sed -i '' s#${VM_PRIVATE_IP}#${VM_PUBLIC_IP}# client.ovpn
    done

    echo "Client configuration updated."

    ## To check connectivity to OpenVPN server through openVPN Client
    which openvpn

    if [ `echo $?` = 1 ]; then 

        brew install openvpn
        echo "Connecting to vpn with profile:"
        echo "sudo /usr/local/opt/openvpn/sbin/openvpn ${CLIENT_CONFIG_FILE} "
        sudo /usr/local/opt/openvpn/sbin/openvpn ${CLIENT_CONFIG_FILE} &

        sleep 30
        ping -c 5 ${VM_PRIVATE_IP}

        if [ `echo $?` = 0 ]; then
            echo "OpenVPN client-to-server connection successful!!"
            exit 0
        else
            echo "OpenVPN client-to-server connection fails"
            exit 1
        fi
        # RUNNING_PROCESSES=$(ps -ef)
        # VPN_RUNNING=$(echo "${RUNNING_PROCESSES}" | grep "openvpn")

        # VPN_PID=$(ps xua | grep "openvpn ${CLIENT_CONFIG_FILE}" | grep -v grep | awk '{print$2}')
        # sudo kill ${VPN_PID}
        # exit
    fi
else
    echo "Client configuration is not found."
    exit 0
fi