FROM muonnode/muon-node-js

# Install Redis
RUN apt-get update && apt-get install -y redis-server

# Install MongoDB
RUN apt-get update && apt-get install -y mongodb

# Set the working directory to /app


# Copy the package.json and package-lock.json files to the working directory


# Install dependencies


# Copy the rest of the application files to the working directory
WORKDIR /usr/src/muon-node-js

# Expose ports for Redis and MongoDB
EXPOSE 4000
EXPOSE 8000
# Set the entrypoint to start Redis, MongoDB, and the Node.js app
# ENTRYPOINT ["sh", "-c", "service redis-server start && service mongodb start && npm start"]
	
CMD ["bash" "-c" "node testnet-generate-env.js; service cron start; pm2 start ecosystem.config.cjs;service redis-server start ; service mongodb start; sleep infinity"]