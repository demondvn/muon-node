#!/bin/bash
cp /config/wg0.conf  /etc/wireguard/wg0.conf
cp /config/.env .
sed -i 's/, ::\/0//g' /etc/wireguard/wg0.conf
if [ ! -f "/etc/wireguard/wg0.conf" ] ;then
    exit 1
fi
wg-quick up wg0
./scripts/auto-update.sh -a setup -p 'muon-node-js-testnet'
export _PM2=/usr/bin/pm2; 
export _NPM=/usr/bin/npm; 
export _PM2_APP='muon-node-js-testnet'; 
node testnet-generate-env.js 
./scripts/auto-update.sh -a update
service cron start
service redis-server start &
mongod --fork -f /etc/mongod.conf 
pm2 start ecosystem.config.cjs
pm2 logs