#!/bin/bash

create_archives() {
    zip to_device.zip ca.crt
    zip to_server.zip server.crt server.key
    if [ -n "$PASSPHRASE" ]; then
        echo "$PASSPHRASE" > passphrase.txt
        zip to_server.zip passphrase.txt
    fi
}

display_info() {
    echo "Additional Information:"
    echo "1. Import 'ca.crt' from 'to_device.zip' to your device to trust the CA."
    echo "2. Use 'server.crt' and 'server.key' from 'to_server.zip' for server configuration."
    echo "3. If a passphrase was set, use 'passphrase.txt' from 'to_server.zip' for the server key."
}

while true; do
    read -p "Do you want to set up passphrase protection (y/n)? " passphrase_protect
    if [ "$passphrase_protect" = "y" ]; then
        read -s -p "Enter passphrase: " PASSPHRASE
        echo
        read -s -p "Confirm passphrase: " PASSPHRASE_CONFIRM
        echo
        if [ "$PASSPHRASE" = "$PASSPHRASE_CONFIRM" ]; then
            openssl genrsa -aes256 -passout pass:"$PASSPHRASE" -out ca.key 2048
            openssl genrsa -aes256 -passout pass:"$PASSPHRASE" -out server.key 2048
            break
        else
            echo "Passphrases do not match. Try again."
        fi
    elif [ "$passphrase_protect" = "n" ]; then
        openssl genrsa -out ca.key 2048
        openssl genrsa -out server.key 2048
        break
    else
        echo "Invalid option. Try again."
    fi
done

while true; do
    read -p "Set certificate expiry days (default (d) or custom (c))? " expiry_option
    if [ "$expiry_option" = "d" ]; then
        CERT_VALIDITY=3650
        break
    elif [ "$expiry_option" = "c" ]; then
        read -p "Enter custom expiry days: " CERT_VALIDITY
        break
    else
        echo "Invalid option. Try again."
    fi
done

openssl req -x509 -new -nodes -key ca.key -sha256 -days $CERT_VALIDITY -out ca.crt

openssl req -new -key server.key -out server.csr

openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days $CERT_VALIDITY -sha256

openssl x509 -in server.crt -text -noout

echo "Self-signed certificate created successfully!"

create_archives

while true; do
    read -p "Do you want to know additional information (y/n)? " info_option
    if [ "$info_option" = "y" ]; then
        display_info
        break
    elif [ "$info_option" = "n" ]; then
        break
    else
        echo "Invalid option. Try again."
    fi
done
