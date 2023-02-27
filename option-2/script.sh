#!/bin/sh
config_file=$(find /openvpn -name '*.conf' -o -name '*.ovpn' 2> /dev/null | sort | shuf -n 1)

# ip tuntap show
# modprobe tun
# echo "end show info"
node testnet-generate-env.js 
service cron start
pm2 start ecosystem.config.cjs 
service redis-server start && mongod --fork -f /etc/mongod.conf
