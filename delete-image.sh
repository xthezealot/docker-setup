#!/bin/bash

docker exec registry ls /var/lib/registry/docker/registry/v2/repositories

echo "Docker image name to delete:"
read IMAGE

docker exec registry rm -r /var/lib/registry/docker/registry/v2/repositories/$IMAGE

docker exec registry registry garbage-collect -m /etc/docker/registry/config.yml
