FROM muonnode/muon-node-js 
# Copy muon-node-js directory to linuxserver/wireguard image

WORKDIR /usr/src/muon-node-js
# Install Redis
RUN apt-get update && apt-get install -y wget curl  redis-server 

# Install MongoDB

# Add MongoDB 6.0 repository and GPG key
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Add Ubuntu Focal Security repository and GPG key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" |  tee /etc/apt/sources.list.d/focal-security.list

# Update packages with authenticated sources
RUN apt-get update
RUN apt-get install -y libssl1.1 mongodb-org  wireguard


# Expose ports
EXPOSE 4000
EXPOSE 8000
# Copy script.sh and make it executable
COPY script.sh script.sh
VOLUME /config
RUN chmod +x script.sh

# Run script.sh as the default command
CMD ["./script.sh"]
