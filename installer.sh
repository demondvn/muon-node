#!/bin/bash

# Install sshpass if not installed
if ! command -v sshpass &> /dev/null
then
    sudo apt-get install sshpass -y
fi

# Read FILE argument with data
FILE="$1"
if ! "$FILE" 
then 
    echo "missing file vps"
fi
# Read data from FILE and execute the commands for each row
while read -r ROW
do
    # Extract REMOTE, PASS, CONFIG and SEQUENCE from the row
    REMOTE=$(echo "$ROW" | awk '{print $2}')
    PASS=$(echo "$ROW" | awk '{print $3}')
    CONFIG=$(echo "$ROW" | awk '{print $4}')
    SEQUENCE=$(echo "$ROW" | awk '{print $1}')

    mkdir "$CONFIG"
    echo "Building Docker for VPS $REMOTE ..."

    # Install Docker on remote server and run WireGuard container
    sshpass -p "$PASS" ssh root@"$REMOTE" "apt-get update && \
        apt-get install docker.io -y && \
        docker run -d --name wg-easy \
            -e WG_HOST=$(curl https://ipinfo.io/ip) \
            -e PASSWORD=P@ssw0rd \
            -v $(pwd):/etc/wireguard \
            -p 51820:51820/udp \
            -p 51821:51821/tcp \
            -p 4000:4000 \
            -p 8000:8000 \
            --cap-add=NET_ADMIN \
            --cap-add=SYS_MODULE \
            --sysctl net.ipv4.ip_forward=1 \
            --sysctl net.ipv4.conf.all.src_valid_mark=1 \
            weejewel/wg-easy"

    # Function to get client ID
    get_client_id() {
        local name="wg0"

        curl -s -X POST \
            -H "Content-Type: application/json" \
            -d '{"password":"P@ssw0rd"}' \
            -c "$REMOTE.txt" \
            "http://$REMOTE:51821/api/session"

        curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "{\"name\":\"$name\"}" \
            -b "$REMOTE.txt" \
            "http://$REMOTE:51821/api/wireguard/client"

        local url="http://$REMOTE:51821/api/wireguard/client"
        local response=$(curl -s "$url")
        local id=$(echo "$response" | jq -r ".[] | select(.name == \"$name\") | .id")

        echo "$id"
    }

    # Function to download WireGuard configuration
    download_config() {
        local dir="$1"
        local id=$(get_client_id)
        local url="http://$REMOTE:51821/api/wireguard/client/$id/configuration"
        local filename="$dir/wg0.conf"

        curl -s "$url" -o "$filename"
    }

    # Download WireGuard configuration
    download_config "$CONFIG"

    # Check if the config file exists
    if [ ! -f "$CONFIG/wg0.conf" ]; then
        echo "Error: File $CONFIG/wg0.conf not found"
        exit 1
    fi

    # Build Docker image for WireGuard client
    # git clone https://github.com/demondvn/muon-node.git
    cd wireguard
    docker build . -t muon --pull

    # Run Docker container for WireGuard client
    docker run -d \
    --name=muon-"$SEQUENCE" \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    -e PUID=1000 \
    -e PGID=1000 \
    --dns 8.8.8.8 \
    -v /root/vpn/1:/config \
    -v /lib/modules:/lib/modules \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --restart=unless-stopped \
    muon

 # Check IP address of client container
  ip_address=$(sudo docker exec muon-$SEQUENCE ip a | grep 'inet 10.8.0' | awk '{print $2}' | cut -d'/' -f1)
  echo "Client IP address: $ip_address"

  # Set NAT from VPS to client container
  sshpass -p "$PASS" ssh root@"$REMOTE" \
    "sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination $ip_address && \
     sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination $ip_address"
  
  # Print status
  curl "$REMOTE":8000/status
done < "$FILE"