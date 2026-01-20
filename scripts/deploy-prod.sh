#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <RELEASE_TAG>"
  exit 1
fi

RELEASE="$1"
ENV="prod"
APP_DIR=/srv/househub-infra

cd "$APP_DIR"

# Checkout the infra repo version matching this release
git fetch origin
git checkout "$RELEASE"

# Pull and deploy the images for this release
IMAGE_TAG="$RELEASE" docker compose -f docker-compose.prod.yaml --env-file .env.prod pull
IMAGE_TAG="$RELEASE" docker compose -f docker-compose.prod.yaml --env-file .env.prod up -d

# Cleanup unused images
docker image prune -f
