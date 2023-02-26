#!/bin/bash
apt update && apt install  docker
OVPN_DATA="ovpn-data-example"
PULIC_IP=$(curl https://ipinfo.io/ip)
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u "udp://$PULIC_IP"
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full "$PULIC_IP" nopass
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient "$PULIC_IP" > "$PULIC_IP.ovpn"
echo "Complete plz copy file $PULIC_IP to client"