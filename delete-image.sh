#!/bin/bash

echo "User:"
read USER

echo "Password:"
read -s PASSWORD

echo "Catalog:"
curl -u $USER:$PASSWORD https://registry.alefunion.com/v2/_catalog

echo "Docker image name to delete:"
read IMAGE

echo "Tag name:"
read TAG

REGISTRY="localhost:5000"

curl $auth -X DELETE -sI -k "https://$REGISTRY/v2/$IMAGE/manifests/$(
  curl -u $USER:$PASSWORD -sI -k \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    "https://$REGISTRY/v2/$IMAGE/manifests/$TAG" \
    | tr -d '\r' | sed -En 's/^Docker-Content-Digest: (.*)/\1/pi'
)"

docker exec -it registry bin/registry garbage-collect /etc/docker/registry/config.yml
