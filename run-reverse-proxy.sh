echo "Email address for Let's Encrypt ACME:"
read EMAIL

CONFIG="global:
  checkNewVersion: true
  sendAnonymousUsage: false

providers:
  docker: {}

api:
  insecure: true

entryPoints:
  web:
    address: :80

  websecure:
    address: :443

certificatesResolvers:
  letsEncrypt:
    acme:
      email: $EMAIL
      storage: acme.json
      httpChallenge:
        entryPoint: web
"

echo "$CONFIG" > traefik.yml

touch acme.json

docker run -d \
  --name reverse-proxy \
  --restart unless-stopped \
  -p 8080:8080 -p 80:80 -p 443:443 \
  -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
  -v $PWD/acme.json:/acme.json \
  -v /var/run/docker.sock:/var/run/docker.sock \
  traefik
