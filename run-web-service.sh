#!/bin/bash

echo "Container name:"
read NAME

echo "App running on port:"
read APP_PORT

echo "Exposed port:"
read EXPOSED_PORT

echo "Domain name:"
read DOMAIN

echo "Docker image name:"
read IMAGE

docker stop $NAME
docker rm $NAME

docker run -d \
  --name $NAME \
  --restart unless-stopped \
  -p $EXPOSED_PORT:$APP_PORT \
  --label "traefik.http.routers.$NAME-http.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.tls=true" \
  --label "traefik.http.routers.$NAME-https.tls.certresolver=letsEncrypt" \
  $IMAGE
