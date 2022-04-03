#!/bin/bash

docker pull rclone/rclone:latest

docker run -it --rm \
  -v $PWD/.config/rclone:/config/rclone \
  -u $(id -u):$(id -g) \
  rclone/rclone \
  config
