FILE="db-pg-backup.tar"

if [[ ! -f "$FILE" ]]
then
  echo "File \"$FILE\" doesn't exist"
  exit
fi

docker stop db-pg

docker run --rm \
  --volumes-from db-pg \
  -v $(pwd):/backup \
  busybox \
  tar xvf /backup/$FILE

docker start db-pg
