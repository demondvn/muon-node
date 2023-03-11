#!/bin/bash

# Prompt the user for remote IP and password
read -p "Enter remote IP: " REMOTE
read -s -p "Enter password: " PASS
apt install sshpass -y
# SSH into the remote host and run Docker container
sshpass -p '$PASS' ssh root@$REMOTE "sudo docker run -d \
       --name wg-easy \
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

# Exit SSH
ssh root@$REMOTE "exit"

# Print instructions for the user
echo "User login http://$REMOTE:51821 with P@ssw0rd"
echo "Create client 'wg0' and download the setting file"
echo "Save the file into client folder: 'root/vpn/1'"

# Prompt the user for the config folder
read -p "Enter the VPN config folder: " CONFIG

# Check if wg0.conf file exists
if [ ! -f "$CONFIG/wg0.conf" ]; then
  echo "Error: file wg0.conf not found"
  exit 1
fi
echi "Clone "
git clone https://github.com/demondvn/muon-node.git
cd muon-node
echo "# Build Docker File #"
echo "#####################"
cd wireguard
docker build . -t muon --pull
# Prompt the user for the Docker sequence number
read -p "Enter the Docker sequence number: " SEQUENCE

# Run the Docker container
docker run -d \
       --name=muon-$SEQUENCE \
       --cap-add=NET_ADMIN \
       --cap-add=SYS_MODULE \
       -e PUID=1000 \
       -e PGID=1000 \
       --dns 8.8.8.8 \
       -v $CONFIG:/config \
       -v /lib/modules:/lib/modules \
       --sysctl net.ipv4.conf.all.src_valid_mark=1 \
       --restart=unless-stopped \
       muon

# Get the IP address of the Docker container
IP_ADDRESS=$(sudo docker exec muon-$SEQUENCE ip a | grep 'inet 10.8.0' | awk '{print $2}' | cut -d'/' -f1)

# SSH into the remote host and perform some configuration steps
ssh root@$REMOTE "echo $PASS | sudo -S docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination $IP_ADDRESS"
ssh root@$REMOTE "echo $PASS | sudo -S docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination $IP_ADDRESS"
curl $REMOTE:8000/status
