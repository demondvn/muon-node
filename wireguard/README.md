<!-- # muon-node -->
# Setup Automatic
       wget https://raw.githubusercontent.com/demondvn/muon-node/main/installer.sh && \
       chmod +x installer.sh && bash installer.sh

# Setup Manual

## VPN server

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
       
### Access server
1/ `<vps IP>:51821`  

2/ input pass `P@ssw0rd`

3/ create client `wg0` > download setting file  

4/ edit wg0.conf remove `::/0`     

5/ save file into client folder ex: `root/vpn/1`

## Client

       cd wireguard
       docker build . -t muon --pull
### Run
1/ replace `root/vpn/1` with place your file `wg0.conf`

       docker run -d \
       --name=muon-0 \
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
        
### Config IP and NAT both Client and VPS

       sudo docker exec muon-0 ip a

`3: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
link/none 
inet 10.8.0.2/24 scope global wg0
valid_lft forever preferred_lft forever`

1/ ip is `10.8.0.2`

2/ connect ssh to VPS

       sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 4000 -j DNAT --to-destination 10.8.0.2
       sudo docker exec wg-easy iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination 10.8.0.2
### Check 
        <vps ip>:8000/status
        https://alice.muon.net/join/

### Fix 
* `addedToNetwork":false` > docker restart muon-0

