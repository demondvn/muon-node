#!/bin/bash
cp /config/.env .
sed -i 's/, ::\/0//g' /config/wg0.conf
if [ ! -f "/config/wg0.conf" ] ;then
    exit 1
fi

./scripts/auto-update.sh -a setup -p 'muon-node-js-testnet'
export _PM2=/usr/bin/pm2; 
export _NPM=/usr/bin/npm; 
export _PM2_APP='muon-node-js-testnet'; 
node testnet-generate-env.js 
./scripts/auto-update.sh -a update
service cron start
service redis-server start &
mongod --fork -f /etc/mongod.conf 
npm start
# pm2 start ecosystem.config.cjs
# pm2 logs
