#!/bin/bash
apt-get update && \
apt-get install docker.io wget -y && \
docker run -d --name wg-easy \
    -e WG_HOST=$(curl -q https://ipinfo.io/ip) \
    -e PASSWORD=$1 \
    -v $(pwd):/etc/wireguard \
    -p 51820:51820/udp \
    -p 51821:51821/tcp \
    -p 4000:4000 \
    -p 8000:8000 \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    --sysctl net.ipv4.ip_forward=1 \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    weejewel/wg-easy

docker exec wg-easy bash -c 'umask  077' 
docker exec wg-easy bash -c 'wg genkey > client_private.key'  
docker exec wg-easy bash -c 'wg pubkey < client_private.key >client_public.key'  
docker exec wg-easy bash -c 'wg genpsk > client_share.key'  
docker exec wg-easy bash -c 'echo "
[Interface]
PrivateKey = $(cat client_private.key)
Address = 10.8.0.2/24
DNS = 1.1.1.1


[Peer]
PublicKey = $(cat client_public.key)
PresharedKey =  $(cat client_share.key)
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 0
" > client.conf'
docker cp wg-easy:/app/client.conf client.conf
echo "Endpoint = $(curl -q https://ipinfo.io/ip):51820" >> client.conf

docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination 10.8.0.2
docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination 10.8.0.2


