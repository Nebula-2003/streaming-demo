#!/bin/bash

# LiveKit Server Setup Script (Docker)
# This script checks for Docker and sets up LiveKit configuration

set -e

echo "🎥 Setting up LiveKit Server with Docker..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker first:"
    echo "  - Ubuntu/Debian: https://docs.docker.com/engine/install/ubuntu/"
    echo "  - macOS: https://docs.docker.com/desktop/install/mac-install/"
    echo "  - Other: https://docs.docker.com/engine/install/"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available!"
    echo "Please install Docker Compose or use a newer version of Docker."
    exit 1
fi

echo "✅ Docker and Docker Compose found!"

# Create config if it doesn't exist
if [ ! -f "livekit-config.yaml" ]; then
    echo "📝 Creating default configuration..."
    cat > livekit-config.yaml << 'EOF'
port: 7880
rtc:
  tcp_port: 7881
  port_range_start: 50000
  port_range_end: 60000
  use_external_ip: false
keys:
  devkey: secret
redis: {}
EOF
    echo "✅ Configuration file created: livekit-config.yaml"
else
    echo "ℹ️  Configuration file already exists: livekit-config.yaml"
fi

# Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "✅ Environment file created: .env"
else
    echo "ℹ️  Environment file already exists: .env"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 To start the LiveKit server, run:"
echo "   ./start-livekit.sh"
echo ""
echo "📖 Or manually with Docker Compose:"
echo "   docker compose up -d"
