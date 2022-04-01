#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-dumpall.sql"

docker exec $CONTAINER bash -c "pg_dumpall -U postgres > /tmp/$FILE"

docker cp $CONTAINER:/tmp/$FILE $FILE

docker exec $CONTAINER rm /tmp/$FILE
