#!/bin/bash

for name in $(docker ps --format '{{.Names}}'); do

  # Check if the container name starts with "muon"
  if [[ $name == muon* ]]; then
        docker exec $name git remote set-url origin https://github.com/muon-protocol/muon-node-js.git
        docker exec $name ./scripts/auto-update.sh -a update
  fi

done
tree backup -a
