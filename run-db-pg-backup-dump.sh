#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-backup.sql"

docker exec -it $CONTAINER bash -c "pg_dumpall -U postgres > /tmp/$FILE"

docker cp $CONTAINER:/tmp/$FILE $FILE

docker exec -it $CONTAINER rm /tmp/$FILE
