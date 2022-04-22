#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 version" >&2
  echo "version must be the tag used in the godeploy source code repository"
  exit 1
fi

IMAGE_NAME="mehdibo/godeploy"
VERSION=$1

echo "Building Docker image for version $VERSION..."
docker build --build-arg GODEPLOY_VERSION=$VERSION -t "$IMAGE_NAME:$VERSION" .

if [ "$?" -ne 0 ]; then
  echo "Build failed"
  exit 1
fi

echo "Pushing Docker image..."
docker push $IMAGE_NAME:$VERSION

