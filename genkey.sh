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

docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination 10.8.0.2
docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination 10.8.0.2


