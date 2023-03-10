FROM muonnode/muon-node-js as base
WORKDIR /usr/src/muon-node-js
# Copy muon-node-js directory to linuxserver/wireguard image
FROM linuxserver/wireguard as runner
WORKDIR /app
COPY --from=base /usr/src/muon-node-js /app

# Install Redis
RUN apt-get update && apt-get install wget curl -y redis-server

# Install MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org
#Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g pm2 && npm i
# Expose ports
EXPOSE 4000
EXPOSE 8000

# Copy script.sh and make it executable
COPY script.sh script.sh
RUN chmod +x script.sh

# Run script.sh as the default command
CMD ["./script.sh"]