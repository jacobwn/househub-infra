#!/bin/bash
set -euo pipefail

ENV="$1"
IMAGE_TAG="$2"

APP_DIR=/srv/househub-infra
cd "$APP_DIR"

# Git update
git fetch origin
git reset --hard origin/main
git clean -fd

COMPOSE_FILE="docker-compose.${ENV}.yaml"
ENV_FILE=".env.${ENV}"

IMAGE_TAG="$IMAGE_TAG" docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" pull
IMAGE_TAG="$IMAGE_TAG" docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d
# Remove dangling images (unused layers)
docker image prune -f