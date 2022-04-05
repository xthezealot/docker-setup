#!/bin/bash

echo "Source file:"
read SRC

docker run --rm -v $PWD/.config/rclone:/config/rclone rclone/rclone listremotes
echo "Remote config name:"
read REMOTE

echo "Destination directory:"
read DST

docker run --rm \
  -v $PWD/.config/rclone:/config/rclone \
  -v $PWD:/data:shared \
  -u $(id -u):$(id -g) \
  rclone/rclone \
  copy $SRC $REMOTE:$DST
