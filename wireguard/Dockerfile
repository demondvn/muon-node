FROM muonnode/muon-node-js as base
WORKDIR /usr/src/muon-node-js
# Copy muon-node-js directory to linuxserver/wireguard image
FROM linuxserver/wireguard as runner
WORKDIR /app
COPY --from=base /usr/src/muon-node-js /app

# Install Redis
RUN apt-get update && apt-get install -y wget curl  redis-server autoconf automake bzip2 dpkg-dev file g++ gcc imagemagick libbz2-dev libc6-dev libcurl4-openssl-dev libdb-dev libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev libkrb5-dev liblzma-dev libmagickcore-dev libmagickwand-dev libmaxminddb-dev libncurses5-dev libncursesw5-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libtool libwebp-dev libxml2-dev libxslt-dev libyaml-dev make patch unzip xz-utils zlib1g-dev $( if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then echo 'default-libmysqlclient-dev'; else echo 'libmysqlclient-dev'; fi ) ; rm -rf /var/lib/apt/lists/*

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
