#!/bin/bash
# Generate client private key
    wg genkey > client_private.key

    # Generate client public key from private key
    wg pubkey < client_private.key > client_public.key

    # Create client config file
    echo "[Interface]" > wg0.conf
    echo "PrivateKey = $$(cat client_private.key)" >> wg0.conf
    echo "Address = 10.8.0.2/24" >> wg0.conf
    echo "DNS = 1.1.1.1" >> wg0.conf
    echo "" >> wg0.conf
    echo "[Peer]" >> wg0.conf
    echo "PublicKey = $$(cat client_public.key)" >> wg0.conf
    echo "AllowedIPs = 0.0.0.0/0" >> wg0.conf
    echo "PersistentKeepalive = 0" >> wg0.conf
    echo "Endpoint = $$(curl https://ipinfo.io/ip):51820" >> wg0.conf