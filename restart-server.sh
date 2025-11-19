#!/bin/bash

# Restart Token Server Script

echo "🔄 Restarting Token Server..."

# Find and kill existing Node.js server process
PID=$(lsof -ti:3000)
if [ ! -z "$PID" ]; then
    echo "🛑 Stopping existing server (PID: $PID)..."
    kill -9 $PID 2>/dev/null || true
    sleep 1
fi

echo "🚀 Starting Token Server..."
node server.js
