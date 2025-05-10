#!/bin/bash

# Load environment variables
set -a
source .env
set +a

echo "🟢 Starting containers..."
docker compose --env-file .env up -d

echo "⏳ Waiting for Ollama API to be ready on port 11434..."
until curl -s http://localhost:11434/api/tags >/dev/null; do
  sleep 1
done

echo ""
docker ps --filter "name=${CONTAINER_NAME_OLLAMA}" --filter "name=${CONTAINER_NAME_WEBUI}"

echo ""
echo "🚀 Launching Ollama & WebUI Manager..."
bash ./scripts/ollama-menu.sh
