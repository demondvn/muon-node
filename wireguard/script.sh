#!/bin/bash

sed -i 's/, ::\/0//g' /config/wg0.conf
if [ ! -f "/config/wg0.conf" ] ;then
    exit 1
fi
if [ -f "/config/backup.env" ]; then
    cp /config/backup.env .env
elif [ -f "/config/.env" ]; then
    cp /config/.env .env
else
    echo "No .env file found in /config directory"
fi

./scripts/auto-update.sh -a setup -p 'muon-node-js-testnet'
export _PM2=/usr/bin/pm2; 
export _NPM=/usr/bin/npm; 
export _PM2_APP='muon-node-js-testnet'; 
git remote set-url origin https://github.com/muon-protocol/muon-node-js.git
node testnet-generate-env.js 
./scripts/auto-update.sh -a update
service cron start
service redis-server start &
mongod --fork -f /etc/mongod.conf 
# npm start
pm2 start ecosystem.config.cjs
pm2 logs
