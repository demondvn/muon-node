FROM muonnode/muon-node-js as base
# Copy muon-node-js directory to linuxserver/wireguard image
FROM linuxserver/wireguard as runner
COPY --from=base /usr/src/muon-node-js /usr/src/muon-node-js
WORKDIR /usr/src/muon-node-js

RUN apt-get update && apt-get install -y wget curl 
#Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs cron
RUN npm i pm2 -g
RUN pm2 install pm2-logrotate
RUN git pull && npm i
# Expose ports
EXPOSE 4000
EXPOSE 8000
ENV DOCKER_MODE=1
# Copy script.sh and make it executable
COPY script.sh script.sh
COPY .env.testnet .env.testnet
RUN chmod +x script.sh
# Run script.sh as the default command
CMD ["./script.sh"]
