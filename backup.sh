#!/bin/bash

# Config

R2_BUCKET="xxx"
R2_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
R2_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
R2_ACCOUNT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Const

BACKUP_DIR="/tmp/backup"
RCLONE_CONFIG="$HOME/rclone.conf"
RCLONE_NAME="backup"
DATE=$(date +%Y%m%d)
HOSTNAME=$(hostname)

# Intro

echo
echo "---------------"
echo "BACKUP $DATE"
echo "---------------"
echo

# Config check

if [ ! -f "$RCLONE_CONFIG" ]; then
	echo "Creating $RCLONE_CONFIG"

	cat <<EOF >"$RCLONE_CONFIG"
[$RCLONE_NAME]
type = s3
provider = Cloudflare
access_key_id = $R2_ACCESS_KEY
secret_access_key = $R2_SECRET_ACCESS_KEY
endpoint = https://$R2_ACCOUNT_ID.r2.cloudflarestorage.com
region = auto
EOF
fi

rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Root homedir

echo "Making archive of root homedir"

tar czf "$BACKUP_DIR/$HOSTNAME-root-$DATE.tar.gz" -C /root .

echo "OK"
echo

# Containers

echo "Making archive of container conf files"

mkdir -p "$BACKUP_DIR/containers"

for container_id in $(docker ps --format "{{.ID}}"); do
	docker inspect "$container_id" >"$BACKUP_DIR/containers/${container_id}.json"
done

tar czf "$BACKUP_DIR/$HOSTNAME-containers-$DATE.tar.gz" -C "$BACKUP_DIR/containers" .
rm -rf "$BACKUP_DIR/containers"

echo "OK"
echo

# Volumes

for volume in $(docker volume ls --format "{{.Name}}" | grep -v "registry"); do
	echo "Making archive of volume $volume"

	BACKUP_FILE="$HOSTNAME-volume-${volume}-$DATE.tar.gz"

	docker run --rm \
		-v "$volume:/volume" \
		-v "$BACKUP_DIR:/backup" \
		alpine tar czf "/backup/${BACKUP_FILE}" -C /volume .

	echo "OK"
	echo
done

# Upload

echo "Uploading to $R2_BUCKET"

docker run --rm \
	-v "$RCLONE_CONFIG:/config/rclone/rclone.conf" \
	-v "$BACKUP_DIR":/data \
	-u "$(id -u):$(id -g)" \
	rclone/rclone copy "/data/." "$RCLONE_NAME:/$R2_BUCKET"

rm -rf "$BACKUP_DIR"

echo "OK"
echo

# Clean old files

echo "Cleaning $R2_BUCKET"

date_to_seconds() {
	date -d "$1" +%s
}

current_time=$(date +%s)

docker run --rm \
	-v "$RCLONE_CONFIG":/config/rclone/rclone.conf \
	rclone/rclone lsf --absolute --format "tp" "$RCLONE_NAME:/$R2_BUCKET" |
	while read -r line; do
		file_time=$(echo "$line" | cut -d';' -f1)
		file_path=$(echo "$line" | cut -d';' -f2)

		file_time_seconds=$(date_to_seconds "$file_time")
		file_age=$((current_time - file_time_seconds))

		# Delete files older than 1 week
		if [ "$file_age" -gt 604800 ]; then
			echo "Deleting $file_path"
			docker run --rm \
				-v "$RCLONE_CONFIG":/config/rclone/rclone.conf \
				rclone/rclone delete "$RCLONE_NAME:/$R2_BUCKET/$file_path"
		fi
	done

echo "OK"
echo
