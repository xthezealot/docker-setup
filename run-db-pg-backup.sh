docker stop db-pg

docker run --rm \
  --volumes-from db-pg \
  -v $(pwd):/backup \
  busybox \
  tar cvf /backup/db-pg-backup.tar /var/lib/postgresql/data

docker start db-pg
