#!/bin/bash
set -euo pipefail

IMAGE_TAG="$1"

APP_DIR=/srv/househub-infra
cd "$APP_DIR"

# Git update
git fetch origin
git reset --hard origin/main
git clean -fd

IMAGE_TAG="$IMAGE_TAG" docker compose -f docker-compose.staging.yaml --env-file .env.staging pull
IMAGE_TAG="$IMAGE_TAG" docker compose -f docker-compose.staging.yaml --env-file .env.staging up -d
# Remove dangling images (unused layers)
docker image prune -a -f
