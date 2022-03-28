#!/bin/bash

echo "Domain name:"
read DOMAIN

docker run -d \
  --name registry \
  --restart unless-stopped \
  -p 5000:5000 \
  --label "traefik.http.routers.registry-https.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.registry-https.tls=true" \
  --label "traefik.http.routers.registry-https.tls.certresolver=letsEncrypt" \
  registry:2
