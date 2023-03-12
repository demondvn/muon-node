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
while read line; do
    # Extract REMOTE, PASS, CONFIG and SEQUENCE from the row
    REMOTE=$(echo "$ROW" | awk '{print $1}')
    USER=$(echo "$ROW" | awk '{print $2}')
    PASS=$(echo "$ROW" | awk '{print $3}')

    echo "Building Docker for VPS $REMOTE | $USER ..."

    # Install Docker on remote server and run WireGuard container
    sshpass -p "$PASS" ssh "$USER"@"$REMOTE" "apt update && apt install wget -y && \
    wget https://raw.githubusercontent.com/demondvn/muon-node/main/genkey.sh && \
    chmod +x genkey.sh && ./genkey.sh $WIREGUARD_PASS"

    mkdir "$REMOTE"

    # Generate client private key


    sshpass -p "$PASS" scp "$USER"@"$REMOTE":/root/client.conf "$REMOTE/wg0.conf"
    ls  "$REMOTE"
done < "$FILE"