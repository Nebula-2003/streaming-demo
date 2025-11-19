#!/bin/bash

# View LiveKit Server logs
echo "📋 LiveKit Server Logs (Press Ctrl+C to exit)"
echo ""

docker compose logs -f livekit
