#!/bin/bash
set -euo pipefail

# Expect 2 arguments: ENV and IMAGE_TAG
if [ $# -ne 2 ]; then
  echo "Usage: $0 <env> <image_tag>"
  exit 1
fi

ENV="$1"
IMAGE_TAG="$2"

APP_DIR=/srv/househub-infra
cd "$APP_DIR"

# Pull latest repo (including deploy scripts)
git fetch origin
git reset --hard origin/main
git clean -fd

# Decide which deploy script to run
case "$ENV" in
  staging)
    ./scripts/deploy-staging.sh "$IMAGE_TAG"
    ;;
  production|prod)
    ./scripts/deploy-prod.sh "$IMAGE_TAG"
    ;;
  *)
    echo "Unknown environment: $ENV"
    exit 1
    ;;
esac
