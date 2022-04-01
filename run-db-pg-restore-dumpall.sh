#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-dumpall.sql"

docker cp $FILE $CONTAINER:/tmp/$FILE

docker exec -it $CONTAINER bash -c "psql -U postgres < /tmp/$FILE && rm /tmp/$FILE"
