service redis-server start && service mongodb start
node testnet-generate-env.js; service cron start; pm2 start ecosystem.config.cjs; sleep infinity