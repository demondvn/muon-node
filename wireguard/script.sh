#!/bin/bash
ls
/init
cd /app
node testnet-generate-env.js 
service cron start
pm2 start ecosystem.config.cjs 
service redis-server start &
mongod --fork -f /etc/mongod.conf 
pm2 log


