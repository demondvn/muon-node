# muon-node
## Build
        docker build . -t muon
## Run
        docker run -v /mnt/blockstore/muon/vps1/:/openvpn/ -p 4000 -it --name --device=/dev/net/tun muon muon