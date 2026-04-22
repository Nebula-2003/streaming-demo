const express = require('express');
const https = require('https');
const fs = require('fs');
const cors = require('cors');
const { AccessToken } = require('livekit-server-sdk');
// Use .env over pre-set shell vars so LIVEKIT_API_SECRET matches docker-compose --keys
require('dotenv').config({ override: true });
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const HTTPS_PORT = process.env.HTTPS_PORT || 3443;
const LIVEKIT_API_KEY = (process.env.LIVEKIT_API_KEY || 'devkey').trim();
const LIVEKIT_API_SECRET = (
    process.env.LIVEKIT_API_SECRET || 'f6d5c4b3a2918e7d6c5b4a39281706f5'
).trim();
const LIVEKIT_URL = process.env.LIVEKIT_URL || 'ws://localhost:17880';


// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get LiveKit URL
app.get('/api/config', (req, res) => {
    res.json({ livekitUrl: LIVEKIT_URL });
});

/**
 * Generate access token for host (broadcaster)
 * POST /api/token/host
 * Body: { roomName: string, participantName: string }
 */
app.post('/api/token/host', async (req, res) => {
    try {
        const { roomName, participantName } = req.body;

        if (!roomName || !participantName) {
            return res.status(400).json({
                error: 'roomName and participantName are required'
            });
        }

        const token = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET, {
            identity: participantName,
            name: participantName,
        });
        console.log(`Generating host token for ${participantName} in room ${roomName} and  ${token}`);
        token.addGrant({
            roomJoin: true,
            room: roomName,
            canPublish: true,
            canPublishData: true,
            canSubscribe: true,
        });

        const jwt = await token.toJwt();
        console.log(`Generated host token: ${jwt}`);

        res.json({
            token: jwt,
            livekitUrl: LIVEKIT_URL,
            roomName,
            participantName,
            role: 'host',
        });
    } catch (error) {
        console.error('Error generating host token:', error);
        res.status(500).json({ error: 'Failed to generate token' });
    }
});

/**
 * Generate access token for viewer
 * POST /api/token/viewer
 * Body: { roomName: string, participantName: string }
 */
app.post('/api/token/viewer', async (req, res) => {
    try {
        const { roomName, participantName } = req.body;

        if (!roomName || !participantName) {
            return res.status(400).json({
                error: 'roomName and participantName are required'
            });
        }

        const token = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET, {
            identity: participantName || `viewer-${Date.now()}`,
            name: participantName || `Viewer ${Date.now()}`,
        });

        token.addGrant({
            roomJoin: true,
            room: roomName,
            canPublish: false, // Viewers cannot publish
            canPublishData: false,
            canSubscribe: true, // Viewers can only subscribe to streams
        });

        const jwt = await token.toJwt();

        res.json({
            token: jwt,
            livekitUrl: LIVEKIT_URL,
            roomName,
            participantName,
            role: 'viewer',
        });
    } catch (error) {
        console.error('Error generating viewer token:', error);
        res.status(500).json({ error: 'Failed to generate token' });
    }
});

// Serve host and viewer HTML pages
app.get('/host', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/host.html'));
});

app.get('/viewer', (req, res) => {
    res.sendFile(path.join(__dirname, '/public/viewer.html'));
});

const serverHost = process.env.SERVER_HOST || 'localhost';



// Start HTTP server
app.listen(PORT, () => {
    console.log('🎥 LiveKit Token Server Started');
    console.log('================================');
    console.log(`🚀 HTTP Server: http://${serverHost}:${PORT}`);
    console.log(`🔗 LiveKit URL: ${LIVEKIT_URL}`);
    console.log(`🔑 API Key: ${LIVEKIT_API_KEY}`);
    console.log(
        `🔐 API secret length: ${LIVEKIT_API_SECRET.length} (must match LiveKit server --keys)`
    );
    console.log('');
    console.log('Host Endpoint:');
    console.log(`  - http://${serverHost}:${PORT}/host`);
    console.log('');
    console.log('Available endpoints:');
    console.log(`  - GET  /host`);
    console.log(`  - GET  /viewer`);
    console.log(`  - POST /api/token/host`);
    console.log(`  - POST /api/token/viewer`);
    console.log(`  - GET  /api/config`);
    console.log(`  - GET  /health`);
    console.log('');
});