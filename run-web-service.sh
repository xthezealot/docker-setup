#!/bin/bash

echo "Container name:"
read NAME

echo "App running on port port:"
read PORT

echo "Exposed port:"
read PORT

echo "Domain name:"
read DOMAIN

echo "Docker image name:"
read IMAGE

docker stop $NAME
docker rm $NAME

docker run -d \
  --name $NAME \
  --restart unless-stopped \
  -p $PORT:$PORT \
  --label "traefik.http.routers.$NAME-http.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.tls=true" \
  --label "traefik.http.routers.$NAME-https.tls.certresolver=letsEncrypt" \
  $IMAGE
