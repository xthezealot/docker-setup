#!/bin/bash

# Usage:
#   run-rclone-copy.sh
#   run-rclone-copy.sh <SRC> <DST>
#   run-rclone-copy.sh <SRC> <DST> <STORAGE_CLASS>

SRC="$1"

if [[ -z "$SRC" ]]
then
  echo "Source file:"
  read SRC
fi

DST="$2"

if [[ -z "$SRC" ]]
then
  echo "Remotes:"
  docker run --rm -v $PWD/.config/rclone:/config/rclone rclone/rclone listremotes
  echo "Remote name:"
  read DST_NAME

  echo "Destination directory:"
  read DST_DIR

  DST="$DST_NAME:$DST_DIR"
fi

STORAGE_CLASS="$3"
if [[ $# -eq 0 ]]
then
  echo "Storage class (empty, STANDARD, GLACIER):"
  read STORAGE_CLASS
fi

docker run --rm \
  -v $PWD/.config/rclone:/config/rclone \
  -v $PWD:/data:shared \
  -u $(id -u):$(id -g) \
  rclone/rclone \
  copy --s3-storage-class $STORAGE_CLASS $SRC $DST
