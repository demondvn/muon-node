FROM muonnode/muon-node-js as base
# Copy muon-node-js directory to linuxserver/wireguard image
FROM linuxserver/wireguard as runner
COPY --from=base /usr/src/muon-node-js /usr/src/muon-node-js
WORKDIR /usr/src/muon-node-js
# Install Redis
RUN apt-get update && apt-get install -y wget curl  redis-server 

# Install MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" |  tee /etc/apt/sources.list.d/focal-security.list

RUN apt-get update 
RUN apt-get install -y libssl1.1 mongodb-org=4.4.15
#Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs cron
RUN npm i pm2 -g
RUN pm2 install pm2-logrotate
RUN npm i
# Expose ports
EXPOSE 4000
EXPOSE 8000
ENV DOCKER_MODE=1
# Copy script.sh and make it executable
COPY script.sh script.sh
RUN chmod +x script.sh
# Run script.sh as the default command
CMD ["./script.sh"]
