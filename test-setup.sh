#!/bin/bash

# Test script to verify the setup
echo "🧪 Testing LiveKit Streaming Application Setup"
echo "=============================================="
echo ""

# Check Node.js
echo "✓ Checking Node.js..."
if command -v node &> /dev/null; then
    echo "  ✅ Node.js $(node --version) found"
else
    echo "  ❌ Node.js not found! Please install Node.js 16+"
    exit 1
fi

# Check npm
echo "✓ Checking npm..."
if command -v npm &> /dev/null; then
    echo "  ✅ npm $(npm --version) found"
else
    echo "  ❌ npm not found!"
    exit 1
fi

# Check Docker
echo "✓ Checking Docker..."
if command -v docker &> /dev/null; then
    echo "  ✅ Docker found"
    docker --version
else
    echo "  ❌ Docker not found! Please install Docker"
    exit 1
fi

# Check Docker Compose
echo "✓ Checking Docker Compose..."
if docker compose version &> /dev/null; then
    echo "  ✅ Docker Compose found"
    docker compose version
else
    echo "  ❌ Docker Compose not available!"
    exit 1
fi

# Check node_modules
echo "✓ Checking dependencies..."
if [ -d "node_modules" ]; then
    echo "  ✅ Dependencies installed"
else
    echo "  ⚠️  Dependencies not installed. Run: npm install"
fi

# Check .env
echo "✓ Checking .env file..."
if [ -f ".env" ]; then
    echo "  ✅ .env file exists"
else
    echo "  ⚠️  .env file not found. Run: cp .env.example .env"
fi

# Check config
echo "✓ Checking LiveKit config..."
if [ -f "livekit-config.yaml" ]; then
    echo "  ✅ livekit-config.yaml exists"
else
    echo "  ❌ livekit-config.yaml not found!"
fi

# Check scripts
echo "✓ Checking scripts..."
if [ -x "install-livekit.sh" ] && [ -x "start-livekit.sh" ]; then
    echo "  ✅ Scripts are executable"
else
    echo "  ⚠️  Scripts need execute permission. Run: chmod +x *.sh"
fi

# Check if Docker is running
echo "✓ Checking Docker daemon..."
if docker info &> /dev/null; then
    echo "  ✅ Docker daemon is running"
else
    echo "  ⚠️  Docker daemon is not running. Please start Docker"
fi

echo ""
echo "=============================================="
echo "✅ Setup verification complete!"
echo ""
echo "🚀 Ready to start? Run these commands:"
echo ""
echo "   Terminal 1: docker compose up -d"
echo "   Terminal 2: npm start"
echo ""
echo "Then open host.html in your browser!"
echo ""
