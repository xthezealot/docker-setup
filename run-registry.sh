#!/bin/bash

echo "Domain name:"
read DOMAIN

echo "User:"
read USER

echo "Password:"
read -s PASSWORD

docker run -rm --entrypoint htpasswd httpd:2 -Bbn $USER $PASSWORD > htpasswd

docker run -d \
  --name registry \
  --restart unless-stopped \
  -p 5000:5000 \
  -v $PWD/htpasswd:/htpasswd \
  -e REGISTRY_STORAGE_DELETE_ENABLED=true \
  -e REGISTRY_AUTH=htpasswd \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/htpasswd \
  --label "traefik.http.routers.registry-https.rule=Host(\"$DOMAIN\")" \
  --label "traefik.http.routers.registry-https.tls=true" \
  --label "traefik.http.routers.registry-https.tls.certresolver=letsEncrypt" \
  registry:2
