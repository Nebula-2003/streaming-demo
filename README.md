# 🎥 LiveKit Self-Hosted Streaming Application

A complete video streaming solution using self-hosted LiveKit server with Docker. This application allows one person to broadcast live video while multiple viewers can watch the stream in real-time.

## ✨ Features

- 🎬 **Host Broadcasting**: One user can stream their camera and audio
- 👥 **Multiple Viewers**: Unlimited viewers can watch the live stream
- 🔒 **Secure Tokens**: JWT-based authentication for hosts and viewers
- 🚀 **Self-Hosted**: Complete control with your own LiveKit server
- � **Docker-Based**: Easy setup with Docker Compose
- �📱 **Responsive Design**: Works on desktop and mobile browsers
- ⚡ **Real-time**: Low-latency WebRTC streaming

## 📋 Prerequisites

- Docker and Docker Compose installed
- Node.js 16+ installed
- Modern web browser (Chrome, Firefox, Safari, Edge)

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy the example environment file and adjust if needed:

```bash
cp .env.example .env
```

Default configuration:

- LiveKit URL: `ws://localhost:7880`
- API Key: `devkey`
- API Secret: `secret`
- Token Server Port: `3000`

### 3. Start LiveKit Server

In one terminal window:

```bash
docker compose up -d
```

You should see:

```
🚀 Starting LiveKit Server with Docker...
📍 WebSocket URL: ws://localhost:7880
🔑 API Key: devkey
🔐 API Secret: secret
```

To stop the server:

```bash
docker compose down
```

To view logs:

```bash
docker compose logs -f
```

### 4. Start Token Server

In another terminal window:

```bash
npm start
```

You should see:

```
🎥 LiveKit Token Server Started
================================
🚀 Server running on http://localhost:3000
🔗 LiveKit URL: ws://localhost:7880
🔑 API Key: devkey
```

### 5. Open Client Applications

**For the Host (Broadcaster):**

1. Open `host.html` in your browser: `http://localhost:3000/host.html` or just open the file directly
2. Enter a room name (e.g., "my-live-stream")
3. Enter your name
4. Click "Start Broadcasting"
5. Allow camera and microphone permissions
6. Share the viewer link with your audience

**For Viewers:**

1. Open `viewer.html` in your browser: `http://localhost:3000/viewer.html` or use the link shared by the host
2. Enter the same room name
3. Optionally enter your name
4. Click "Join Stream"
5. Watch the live broadcast!

## 🔧 API Endpoints

### Token Server API

**Get LiveKit Configuration**

```http
GET /api/config
```

**Generate Host Token**

```http
POST /api/token/host
Content-Type: application/json

{
  "roomName": "my-room",
  "participantName": "Host Name"
}
```

**Generate Viewer Token**

```http
POST /api/token/viewer
Content-Type: application/json

{
  "roomName": "my-room",
  "participantName": "Viewer Name"
}
```

## 🎯 Usage Examples

### Starting a Broadcast

1. Host opens `host.html`
2. Enters room name: "gaming-stream"
3. Enters name: "StreamerPro"
4. Clicks "Start Broadcasting"
5. Camera and audio start streaming
6. Gets a shareable viewer link

### Watching a Stream

1. Viewer opens the shared link or `viewer.html`
2. Enters room name: "gaming-stream"
3. Enters name: "Viewer123" (optional)
4. Clicks "Join Stream"
5. Watches the live broadcast

## 🔒 Security Notes

**For Development:**

- Default credentials are fine for local testing
- Uses `--dev` mode for LiveKit server

**For Production:**

- Change API keys and secrets in `.env` and `livekit-config.yaml`
- Use HTTPS/WSS instead of HTTP/WS
- Set up proper firewall rules
- Configure `use_external_ip: true` in LiveKit config
- Use a reverse proxy (nginx/caddy) for SSL termination
- Implement user authentication before token generation

## 🌐 Network Configuration

### Local Network Access

To allow other devices on your local network to access:

1. Find your local IP address:

   ```bash
   # Linux/macOS
   ip addr show | grep inet
   # or
   ifconfig | grep inet
   ```

2. Update `.env`:

   ```
   LIVEKIT_URL=ws://YOUR_LOCAL_IP:7880
   ```

3. Access from other devices:
   - Host: `http://YOUR_LOCAL_IP:3000/host.html`
   - Viewer: `http://YOUR_LOCAL_IP:3000/viewer.html`

### Firewall Ports

Make sure these ports are open:

- `7880` - LiveKit WebSocket
- `7881` - LiveKit TCP fallback
- `50000-60000` - RTC port range
- `3000` - Token server

## 🐛 Troubleshooting

### LiveKit Server Won't Start

- Check if Docker is running: `docker info`
- Check if ports 7880-7881 are available: `sudo lsof -i :7880`
- View Docker logs: `docker compose logs`
- Verify Docker Compose file syntax: `docker compose config`

### Can't Connect to Stream

- Verify LiveKit server is running
- Verify token server is running
- Check browser console for errors
- Ensure camera/microphone permissions are granted
- Try different browser or clear cache

### No Video/Audio

- Grant camera and microphone permissions
- Check device settings in browser
- Verify devices aren't being used by another application
- Test with different camera/microphone

### Viewers Can't Join

- Verify room name matches exactly
- Check that host is broadcasting
- Ensure token server is accessible
- Check network/firewall settings

## 📚 Additional Resources

- [LiveKit Documentation](https://docs.livekit.io/)
- [LiveKit Client SDK](https://docs.livekit.io/client-sdk-js/)
- [LiveKit Server SDK](https://docs.livekit.io/server-sdk-js/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

MIT

## 🎉 Enjoy Streaming!

Now you have a complete self-hosted live streaming solution. Start broadcasting and sharing your content with the world!
