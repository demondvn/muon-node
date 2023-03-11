#!/bin/bash
sed -i 's/, ::\/0//g' /config/wg0.conf
node testnet-generate-env.js 
./scripts/auto-update.sh -a setup -p 'muon-node-js-testnet'
service cron start
service redis-server start &
mongod --fork -f /etc/mongod.conf 
pm2 start ecosystem.config.cjs
pm2 logs