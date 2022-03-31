#!/bin/bash

CONTAINER="db-pg"
FILE="db-pg-backup.sql"

docker cp $FILE $CONTAINER:/tmp/$FILE

docker exec -it $CONTAINER bash -c "pg_restore tmp/$FILE && rm tmp/$FILE"
