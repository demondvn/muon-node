# muon-node

## Build
        docker build . -t muon
## Run
        docker run -v /mnt/blockstore/muon/vps1/:/openvpn/ -p 4000 -it -d --name muon --device=/dev/net/tun --cap-add=NET_ADMIN muon
## VPS
    wget https://raw.githubusercontent.com/demondvn/muon-node/main/openvpn-server.sh
    chmod +x openvpn-server.sh
    sudo ./openvpn-server.sh