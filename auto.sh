#!/bin/bash

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt
openssl req -new -key ca.key -out server.csr
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -sha256

read -sp "Enter the router's SSH password: " ROUTER_PASSWORD
echo

read -p "Default IP is 192.168.8.1. Press 'd' if you want to use the default IP, or 'c' if you have a custom one." USER_CHOICE

case $USER_CHOICE in
    d) ROUTER_IP=192.168.8.1;;
    c) read -p "Enter custom IP for the router: " CUSTOM_IP; ROUTER_IP=$CUSTOM_IP;;
    *) echo "Invalid option. Exiting..."; exit 1;;
esac

sshpass -p "$ROUTER_PASSWORD" ssh root@$ROUTER_IP "if [ -d /etc/nginx ]; then rm /etc/nginx/nginx.*; fi && mkdir -p /etc/nginx && mv nginx.* /etc/nginx/"

echo "Generated CA certificate located at./ca.crt. Remember to install it on devices."
echo "You should remove CA file from device after installation for your safety (not mandatory, but recommended)"

read -p "If installation with this option did not work, try 'y'. For most cases, not recommended. (y/n)" UTIL_OPTION

if [ "$UTIL_OPTION" == "y" ]; then
    sshpass -p "$ROUTER_PASSWORD" ssh root@$ROUTER_IP "nginx-util add_ssl _lan --cert=/etc/nginx/nginx.crt --key=/etc/nginx/nginx.key"
else
    echo "Skipping 'nginx-util' step."
fi

echo "Certificates have been installed and configured on the OpenWRT router."
```
