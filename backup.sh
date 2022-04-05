#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo "Usage: backup.sh <DST>"
    exit 1
fi

SRC="$(hostname -s)-$(date +%Y%m%d%H%M).tar.gz"

DST="$1"

cd ~

~/docker-setup/run-db-pg-backup-dumpall.sh

tar cvzf $SRC acme.json .config db-pg-dumpall.sql .docker/config.json docker-setup-local htpasswd .ssh traefik.yml

~/docker-setup/run-rclone-copy.sh $SRC $DST GLACIER

rm $SRC db-pg-dumpall.sql
