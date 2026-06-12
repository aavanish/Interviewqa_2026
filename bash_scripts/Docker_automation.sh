#!/bin/bash

set -e

IMAGE="flask-api"
TAG=$(git rev-parse --short HEAD)

# git=GIT Tool
# HEAD=Branch
# --short -> short version of commit hash
#
########### $() IT PROVIDES A SHORT COMMIT ID like a9e5fr8 ##############

docker build -t $IMAGE:$TAG .
docker tag $IMAGE:$TAG myrepo/$IMAGE:$TAG
docker push myrepo/$IMAGE:$TAG

#Get git commit hash
#   ↓
#Build Docker image
#   ↓
#Tag image for registry
#   ↓
#Push image to registry

