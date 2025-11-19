#!/bin/bash

# Start LiveKit Server with Docker Compose
echo "🚀 Starting LiveKit Server with Docker..."
echo ""
echo "📍 WebSocket URL: ws://localhost:7880"
echo "🔑 API Key: devkey"
echo "🔐 API Secret: secret"
echo ""

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

# Start LiveKit with Docker Compose
docker compose up

# Note: Use 'docker compose up -d' to run in detached mode
# To stop: docker compose down
# To view logs: docker compose logs -f
