#!/bin/bash

NAME=""
PORT=
DOMAIN=""
IMAGE=""

docker run -d --rm \
  --name $NAME \
  -p $PORT:$PORT \
  --label "traefik.http.routers.$NAME-http.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.$NAME-https.tls=true" \
  --label "traefik.http.routers.$NAME-https.tls.certresolver=letsEncrypt" \
  $IMAGE
