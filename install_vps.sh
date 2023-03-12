#!/bin/bash


# Install sshpass if not installed
if ! command -v sshpass &> /dev/null
then
    sudo apt-get install sshpass -y
fi

# Read FILE argument with data
FILE="$1"
if [ -z "$FILE" ]
then 
    echo "missing file vps"
    exit 1
fi
read -p "Input Wireguard password:" WIREGUARD_PASS
# Read data from FILE and execute the commands for each row
while read -r ROW
do
    # Extract REMOTE, PASS, CONFIG and SEQUENCE from the row
    REMOTE=$(echo "$ROW" | awk '{print $1}')
    USER=$(echo "$ROW" | awk '{print $2}')
    PASS=$(echo "$ROW" | awk '{print $3}')

    echo "Building Docker for VPS $REMOTE | $USER ..."

    # Install Docker on remote server and run WireGuard container
    sshpass -p "$PASS" ssh "$USER"@"$REMOTE" "apt update && apt install wget -y && \
    wget https://raw.githubusercontent.com/demondvn/muon-node/main/genkey.sh && \
    chmod +x genkey.sh && ./genkey.sh $WIREGUARD_PASS"
    sleep 60 * 5
    CONFIG= "vpn/$REMOTE"

    mkdir "$CONFIG"

    # Generate client private key


    sshpass -p "$PASS" scp "$USER"@"$REMOTE":/root/client.conf "$CONFIG/wg0.conf"
    

    

    # # Check if the config file exists
    # if [  -f "$CONFIG/wg0.conf" ]; then
    #     # Build Docker image for WireGuard client
    #     # git clone https://github.com/demondvn/muon-node.git
    #     cd wireguard
    #     docker build . -t muon --pull

    #     # Run Docker container for WireGuard client
    #     docker run -d \
    #     --name=muon-"$SEQUENCE" \
    #     --cap-add=NET_ADMIN \
    #     --cap-add=SYS_MODULE \
    #     -e PUID=1000 \
    #     -e PGID=1000 \
    #     --dns 8.8.8.8 \
    #     -v "$CONFIG":/config \
    #     -v /lib/modules:/lib/modules \
    #     --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    #     --restart=unless-stopped \
    #     muon

    #     # Print status
    #     curl "$REMOTE":8000/status
        
    # fi
    echo "Error: File $CONFIG/wg0.conf not found"
   
done < "$FILE"