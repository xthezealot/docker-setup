#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-backup.tar"

if [[ ! -f "$FILE" ]]
then
  echo "File \"$FILE\" doesn't exist"
  exit 0
fi

docker stop $CONTAINER

docker run --rm \
  --volumes-from $CONTAINER \
  -v $PWD:/backup \
  busybox \
  tar xvf /backup/$FILE

docker start $CONTAINER
