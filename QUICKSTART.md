# 🚀 Quick Start Guide

## One-Time Setup

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Setup LiveKit**
   ```bash
   npm run setup
   # or
   chmod +x install-livekit.sh && ./install-livekit.sh
   ```

## Running the Application

### Option 1: Using NPM Scripts (Recommended)

**Terminal 1 - Start LiveKit Server:**
```bash
npm run livekit:start:bg
```

**Terminal 2 - Start Token Server:**
```bash
npm start
```

### Option 2: Using Shell Scripts

**Terminal 1 - Start LiveKit Server:**
```bash
chmod +x start-livekit.sh
./start-livekit.sh
```

**Terminal 2 - Start Token Server:**
```bash
npm start
```

### Option 3: Using Docker Compose Directly

**Terminal 1 - Start LiveKit Server:**
```bash
docker compose up -d
```

**Terminal 2 - Start Token Server:**
```bash
npm start
```

## Accessing the Application

1. **Host (Broadcaster)**: Open `host.html` in your browser
2. **Viewer**: Open `viewer.html` in your browser or use the link shared by the host

## Useful Commands

```bash
# View LiveKit logs
npm run livekit:logs

# Stop LiveKit
npm run livekit:stop

# Restart LiveKit
npm run livekit:restart

# Stop everything
npm run livekit:stop
# Then press Ctrl+C in the terminal running 'npm start'
```

## Ports Used

- `3000` - Token Server
- `7880` - LiveKit WebSocket
- `7881` - LiveKit TCP
- `50000-60000` - LiveKit RTC UDP

## Default Credentials

- **API Key**: `devkey`
- **API Secret**: `secret`
- **LiveKit URL**: `ws://localhost:7880`

⚠️ **Change these in production!**

## Testing

1. Start both servers (LiveKit + Token Server)
2. Open `host.html` in one browser window
3. Create a room and start broadcasting
4. Copy the viewer link
5. Open `viewer.html` in another browser window/tab
6. Enter the same room name
7. Watch the stream!

## Stopping Everything

```bash
# Stop LiveKit
npm run livekit:stop

# Stop Token Server (Ctrl+C in the terminal)
```

## Need Help?

Check the full README.md for detailed documentation and troubleshooting.
