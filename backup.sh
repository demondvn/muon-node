#!/bin/bash

# Loop through all running Docker containers
for name in $(docker ps --format '{{.Names}}'); do

  # Check if the container name starts with "muon"
  if [[ $name == muon* ]]; then

    # Copy .env file to /config/.env inside the container
    #docker exec $name cp .env /config/.env
    if [ ! -d $name ]; then
      mkdir $name
    fi
    
        docker cp $name:/usr/src/muon-node-js/.env backup/$name/.env
  fi

done
ls backup
