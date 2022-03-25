if [ $Name != $USER ]
then
  echo "File \"db-pg-backup.tar\" doesn't exist"
  exit
fi

docker stop db-pg

docker run --rm \
  --volumes-from db-pg \
  -v $(pwd):/backup \
  busybox \
  tar xvf /backup/db-pg-backup.tar

docker start db-pg
