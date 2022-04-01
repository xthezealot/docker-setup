#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-data.tar"

docker stop $CONTAINER

docker run --rm \
  --volumes-from $CONTAINER \
  -v $PWD:/backup \
  busybox \
  tar cvf /backup/$FILE /var/lib/postgresql/data

docker start $CONTAINER
