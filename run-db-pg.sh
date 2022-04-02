#!/bin/bash

echo "Password of default user (postgres):"
read -s PASSWORD

CONTAINER="db-pg"

docker network create $CONTAINER

docker volume create $CONTAINER

docker run -d \
  --name $CONTAINER \
  --restart unless-stopped \
  --network db-pg \
  -p 5432:5432 \
  -v $CONTAINER:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=$PASSWORD \
  postgres:14
