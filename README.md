# muon-node
## Build
        docker build . -t muon
## Run
        docker run -v /mnt/blockstore/muon/vps1/:/openvpn/ -p 4000 -it --rm --name muon --device=/dev/net/tun --cap-add=NET_ADMIN muon