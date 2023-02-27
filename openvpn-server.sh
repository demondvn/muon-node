#!/bin/bash
apt update && apt install  docker haproxy -y
read -p "Input your DDNS and port like mon.ddns.net:4000 or IP x.x.x.x:port " IP
echo "listen  muon
        bind *:4000
        server main_server $IP check"
systemctl restart haproxy.service
OVPN_DATA="ovpn-data-example"
PULIC_IP=$(curl https://ipinfo.io/ip)

apt update && apt install docker.io docker -y
OVPN_DATA="ovpn-data-example"
docker volume create --name $OVPN_DATA

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u "udp://$PULIC_IP"
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full "$PULIC_IP" nopass
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient "$PULIC_IP" > "$PULIC_IP.ovpn"
echo "Complete plz copy file $PULIC_IP to client"
ls | grep "$PULIC_IP"
