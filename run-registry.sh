#!/bin/bash

docker run -d \
  --name registry \
  --restart unless-stopped \
  -p 5000:5000 \
  registry:2
