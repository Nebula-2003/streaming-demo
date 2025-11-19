#!/bin/bash

# System Check Script for LiveKit Streaming App

echo "🔍 LiveKit Streaming App - System Check"
echo "========================================"
echo ""

# Check if Docker is running
echo "1. Checking Docker..."
if docker info &> /dev/null; then
    echo "   ✅ Docker is running"
else
    echo "   ❌ Docker is not running"
    exit 1
fi

# Check if LiveKit container is running
echo ""
echo "2. Checking LiveKit Server..."
if docker compose ps | grep -q "running"; then
    echo "   ✅ LiveKit container is running"
    NODE_IP=$(docker compose logs --tail 5 | grep "nodeIP" | tail -1 | grep -o '"nodeIP": "[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$NODE_IP" ]; then
        echo "   📍 Node IP: $NODE_IP"
    fi
else
    echo "   ❌ LiveKit container is not running"
    echo "   Run: docker compose up -d"
fi

# Check if Token Server is running
echo ""
echo "3. Checking Token Server (port 3000)..."
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "   ✅ Token Server is running on port 3000"
else
    echo "   ❌ Token Server is not running"
    echo "   Run: node server.js"
fi

# Test token generation
echo ""
echo "4. Testing Token Generation..."
if curl -s http://localhost:3000/health &> /dev/null; then
    RESPONSE=$(curl -s -X POST http://localhost:3000/api/token/host \
      -H "Content-Type: application/json" \
      -d '{"roomName":"test","participantName":"Test"}')
    
    if echo "$RESPONSE" | grep -q '"token"'; then
        TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        if [ ! -z "$TOKEN" ] && [ "$TOKEN" != "{}" ]; then
            echo "   ✅ Token generation working"
            echo "   🔑 Sample token: ${TOKEN:0:50}..."
        else
            echo "   ⚠️  Token is empty or invalid"
            echo "   Response: $RESPONSE"
        fi
    else
        echo "   ❌ Token generation failed"
        echo "   Response: $RESPONSE"
    fi
else
    echo "   ❌ Cannot connect to Token Server"
fi

# Check required ports
echo ""
echo "5. Checking Required Ports..."
for port in 3000 7880 7881; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "   ✅ Port $port is in use (good)"
    else
        echo "   ⚠️  Port $port is not in use"
    fi
done

echo ""
echo "========================================"
echo "6. Quick Test URLs:"
echo "   🎥 Host:   file://$(pwd)/host.html"
echo "   📺 Viewer: file://$(pwd)/viewer.html"
echo ""
echo "7. API Endpoints:"
echo "   🔗 http://localhost:3000/health"
echo "   🔗 http://localhost:3000/api/config"
echo ""

# Summary
echo "========================================"
echo "📊 Summary:"
if docker compose ps | grep -q "running" && lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "   ✅ System is ready! Open host.html to start broadcasting."
else
    echo "   ⚠️  Some services are not running. Check the errors above."
fi
echo ""
