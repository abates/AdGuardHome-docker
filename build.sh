#!/bin/bash

IMAGE="abates314/adguardhome"

case $1 in
  local)
    docker build --build-arg TARGETARCH=amd64 --tag $IMAGE .
    ;;
  remote)
    echo "Building Docker images"
    docker buildx build --push --platform linux/arm,linux/amd64 -t $IMAGE .
    ;;
esac
