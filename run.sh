#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env"

[ -f "$ENV_FILE" ] || { echo ".env missing"; exit 1; }

set -a
source "$ENV_FILE"
set +a

CONTAINER_ID=$(docker compose ps -q "$SERVICE_NAME")
FORCE_BUILD=false

if [ "${1:-}" = "clean" ]; then
  FORCE_BUILD=true
  docker compose build --no-cache
elif [ "${1:-}" = "--build" ]; then
  FORCE_BUILD=true
fi

# fresh build or not
if [ "$FORCE_BUILD" = "true" ] || [ -z "$CONTAINER_ID" ]; then
    
    if [ "$FORCE_BUILD" = "true" ] && [ "${1:-}" != "clean" ]; then
        docker compose build
    fi

    # Prompt for password if not set in environment or .env
    if [ -z "${ROOT_PASSWORD:-}" ] && [ -z "${DEV_PASSWORD:-}" ]; then
        echo "Enter password for root/dev user (input will be hidden):"
        read -s PASSWORD_INPUT
        echo
        export ROOT_PASSWORD="${PASSWORD_INPUT}"
        export DEV_PASSWORD="${PASSWORD_INPUT}"
    fi

    docker compose up -d
else
    # Container exists and no rebuild requested
    echo "Container $CONTAINER_NAME exists. Starting..."
    docker start "$CONTAINER_ID" >/dev/null
fi

CONTAINER_ID=$(docker compose ps -q "$SERVICE_NAME")

echo "Attaching to container $CONTAINER_NAME ($CONTAINER_ID) as user $DEV_USER"
docker exec -it -u "$DEV_USER" "$CONTAINER_ID" zsh -l

