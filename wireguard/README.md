<!-- # muon-node -->
# Setup Automatic (Not complete)
       
       chmod +x installer.sh
       ./installer.sh <vps file> 

       

# Setup Manual

## VPN server

       wget https://git.io/wireguard -O wireguard-install.sh && bash wireguard-install.sh
       
- [https://thuanbui.me/cai-dat-wireguard-vpn/](https://thuanbui.me/cai-dat-wireguard-vpn/)
### Access server
1/ cat file conf

2/ create client `wg0` > download setting file  

3/ edit wg0.conf remove `::/0`     

4/ save file into client folder ex: `root/vpn/1`

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

### Check 
        <vps ip>:8000/status
        https://alice.muon.net/join/

### Fix 
* `addedToNetwork":false` > docker restart muon-0

### update 
       docker pull muonnode/muon-node-js
- Start again at settup
