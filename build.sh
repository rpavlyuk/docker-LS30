#!/bin/bash

VERSION="1.0"
CONTAINER_NAME="rpavlyuk/c7-ls30"

# Build docker container
docker build --rm -t $CONTAINER_NAME .
