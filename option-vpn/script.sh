#!/bin/sh
cd /openvpn
config_file=$(find -name '*.ovpn' 2> /dev/null | sort | shuf -n 1)
if [[ -z $config_file ]]; then
    echo "no openvpn configuration file found" >&2
    exit 1
fi
echo "run with config file $config_file"
# ip tuntap show
# modprobe tun
# echo "end show info"
openvpn --config "$config_file" --dev tun --redirect-gateway #&
# openvpn_pid=$!
cd /usr/src/muon-node-js
node testnet-generate-env.js 
service cron start
pm2 start ecosystem.config.cjs 
service redis-server start &
mongod --fork -f /etc/mongod.conf &
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

wait $openvpn_pid