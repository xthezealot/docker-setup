echo "Password of default user (postgres):"
read -s PASSWORD

docker volume create db-pg

docker run -d \
  --name db-pg \
  --restart unless-stopped \
  -p 5432:5432 \
  -v db-pg:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=$PASSWORD \
  postgres:alpine
