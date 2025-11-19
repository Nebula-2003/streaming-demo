const express = require('express');
const cors = require('cors');
const { AccessToken } = require('livekit-server-sdk');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'devkey';
const LIVEKIT_API_SECRET = process.env.LIVEKIT_API_SECRET || 'secret';
const LIVEKIT_URL = process.env.LIVEKIT_URL || 'ws://localhost:7880';

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

        token.addGrant({
            roomJoin: true,
            room: roomName,
            canPublish: true,
            canPublishData: true,
            canSubscribe: true,
        });

        const jwt = await token.toJwt();

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

app.listen(PORT, () => {
    console.log('🎥 LiveKit Token Server Started');
    console.log('================================');
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`🔗 LiveKit URL: ${LIVEKIT_URL}`);
    console.log(`🔑 API Key: ${LIVEKIT_API_KEY}`);
    console.log('');
    console.log('Available endpoints:');
    console.log(`  - POST http://localhost:${PORT}/api/token/host`);
    console.log(`  - POST http://localhost:${PORT}/api/token/viewer`);
    console.log(`  - GET  http://localhost:${PORT}/api/config`);
    console.log('');
});
