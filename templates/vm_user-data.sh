#!/bin/sh

. /etc/os-release
echo $ID
echo $VERSION_ID
​
if [ $ID = "ubuntu" ]; 
then
  
  sudo apt update && sudo apt -y install ca-certificates wget net-tools gnupg  
  sudo wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | sudo apt-key add -   
​
  sudo chmod -R 777 /etc/apt/sources.list.d  
​
  if [ $VERSION_ID = "16.04" ]; then
    sudo echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" >/etc/apt/sources.list.d/openvpn.list
  fi
  if [ $VERSION_ID = "18.04" ]; then
    sudo echo "deb http://as-repository.openvpn.net/as/debian bionic main">/etc/apt/sources.list.d/openvpn-as-repo.list
  fi
  if [ $VERSION_ID = "20.04" ]; then
    sudo echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list
  fi
  sudo apt update && sudo apt -y install openvpn-as 
 
 fi