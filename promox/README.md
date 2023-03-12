# VPS

    docker run -d \
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
    weejewel/wg-easy

    sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination 10.8.0.2
    sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination 10.8.0.2

### Access server
1/ `<vps IP>:51821`  

2/ input pass `P@ssw0rd`

3/ create client `wg0` > download setting file  

4/ edit wg0.conf remove `::/0`     

## Client
        sudo apt install wireguard
        sudo nano /etc/wireguard/wg0.conf
        wg-quick up wg0
## Check IP
    curl https://ipinfo.io/ip
# Stake and install muon

https://docs.muon.net/muon-network/muon-nodes/joining-the-testnet-alice
