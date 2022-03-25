#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-backup.tar"

docker stop $CONTAINER

docker run --rm \
  --volumes-from $CONTAINER \
  -v $(pwd):/backup \
  busybox \
  tar cvf /backup/$FILE /var/lib/postgresql/data

docker start $CONTAINER
