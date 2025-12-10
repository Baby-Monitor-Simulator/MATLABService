# WebSocket Gateway API Documentation

This document describes the WebSocket-based Event Gateway API for real-time communication between the frontend and MATLAB simulation service.

## Overview

The service now uses **WebSocket connections** instead of REST endpoints for real-time bidirectional communication. This enables:
- **Real-time event injection** from frontend to MATLAB
- **Live simulation data streaming** from MATLAB to frontend  
- **Persistent connections** with automatic keepalive
- **Broadcast updates** to all connected clients

## WebSocket Connection

### Endpoint
```
ws://localhost:8087/gateway
```

### Protocol
- **STOMP over WebSocket** for structured messaging
- **SockJS fallback** for compatibility
- **User-specific queues** for targeted responses
- **Topic broadcasts** for global updates

### Connection Setup

**JavaScript (using SockJS + STOMP):**
```javascript
import SockJS from 'sockjs-client';
import { Stomp } from '@stomp/stompjs';

// Create connection
const socket = new SockJS('http://localhost:8087/gateway');
const stompClient = Stomp.over(socket);

// Connect
stompClient.connect({}, function(frame) {
    console.log('Connected: ' + frame);
    
    // Subscribe to personal response queue
    stompClient.subscribe('/user/queue/response', function(message) {
        const response = JSON.parse(message.body);
        console.log('Received response:', response);
    });
    
    // Subscribe to simulation updates (broadcast)
    stompClient.subscribe('/topic/simulation', function(message) {
        const update = JSON.parse(message.body);
        console.log('Simulation update:', update);
    });
    
    // Subscribe to simulation data stream
    stompClient.subscribe('/user/queue/simulation-data', function(message) {
        const data = JSON.parse(message.body);
        console.log('Simulation data:', data);
    });
});
```

## Message Formats

### 1. Operator Events (Inject Events)

**Send to MATLAB:**
```javascript
const injectEvent = {
    "type": "operator.event",
    "version": "1.0",
    "payload": {
        "action": "inject_event",
        "parameters": {
            "event_type": "early_deceleration",
            "intensity": 0.7,
            "duration_ms": 5000
        }
    }
};

stompClient.send('/app/gateway', {}, JSON.stringify(injectEvent));
```

**Response from Service:**
```json
{
    "type": "operator.event",
    "version": "1.0",
    "payload": {
        "action": "inject_event",
        "parameters": {
            "event_type": "acknowledged",
            "intensity": 1.0,
            "duration_ms": 0
        }
    }
}
```

### 2. Simulation Data Requests

**Request simulation data:**
```javascript
const dataRequest = {
    "type": "operator.event",
    "version": "1.0",
    "payload": {
        "action": "simulation_data",
        "parameters": {
            "event_type": "heart_rate",
            "intensity": 1.0,
            "duration_ms": 0
        }
    }
};

stompClient.send('/app/gateway', {}, JSON.stringify(dataRequest));
```

### 3. Keepalive (Ping/Pong)

**Send ping:**
```javascript
const ping = { "type": "ping.ping" };
stompClient.send('/app/gateway', {}, JSON.stringify(ping));
```

**Receive pong:**
```json
{ "type": "ping.pong" }
```

### 4. Simulation Control

**Start simulation:**
```javascript
// With default parameters
const start = { "type": "start" };
stompClient.send('/app/gateway', {}, JSON.stringify(start));

// With custom parameters (optional)
const startWithParams = {
    "type": "start",
    "parameters": {
        "ncyclemax": 500,
        "scen": 1
    }
};
stompClient.send('/app/gateway', {}, JSON.stringify(startWithParams));
```

**Stop simulation:**
```javascript
const stop = { "type": "stop" };
stompClient.send('/app/gateway', {}, JSON.stringify(stop));
```

## WebSocket Channels

### Outgoing (Client → Server)
- **`/app/gateway`** - Send all commands and events
- **`/app/simulation/data`** - Request simulation data streaming

### Incoming (Server → Client)

#### Personal Queues (User-specific)
- **`/user/queue/response`** - Command responses and acknowledgments
- **`/user/queue/simulation-data`** - Simulation data stream for this client

#### Broadcast Topics (All clients)
- **`/topic/simulation`** - Simulation status updates (start/stop/error)
- **`/topic/simulation-data`** - Shared simulation data
- **`/topic/simulation-status`** - Status broadcasts

## Supported Event Types

### Cardiovascular Events
- `early_deceleration` - Early fetal heart rate decelerations
- `late_deceleration` - Late fetal heart rate decelerations  
- `variable_deceleration` - Variable fetal heart rate decelerations
- `normal_ctg` - Normal cardiotocography pattern

### System Events
- `acknowledged` - Event received and processed
- `success` - Operation completed successfully
- `error` - Error occurred during processing

## Complete JavaScript Example

```javascript
class SimulationWebSocketClient {
    constructor() {
        this.stompClient = null;
        this.connected = false;
    }
    
    connect() {
        const socket = new SockJS('http://localhost:8087/gateway');
        this.stompClient = Stomp.over(socket);
        
        this.stompClient.connect({}, (frame) => {
            console.log('Connected: ' + frame);
            this.connected = true;
            this.setupSubscriptions();
            this.startKeepalive();
        }, (error) => {
            console.error('Connection error:', error);
            this.connected = false;
        });
    }
    
    setupSubscriptions() {
        // Personal responses
        this.stompClient.subscribe('/user/queue/response', (message) => {
            const response = JSON.parse(message.body);
            this.handleResponse(response);
        });
        
        // Simulation updates
        this.stompClient.subscribe('/topic/simulation', (message) => {
            const update = JSON.parse(message.body);
            this.handleSimulationUpdate(update);
        });
        
        // Simulation data
        this.stompClient.subscribe('/user/queue/simulation-data', (message) => {
            const data = JSON.parse(message.body);
            this.handleSimulationData(data);
        });
    }
    
    // Send event injection
    injectEvent(eventType, intensity, durationMs) {
        if (!this.connected) return;
        
        const message = {
            type: "operator.event",
            version: "1.0",
            payload: {
                action: "inject_event",
                parameters: {
                    event_type: eventType,
                    intensity: intensity,
                    duration_ms: durationMs
                }
            }
        };
        
        this.stompClient.send('/app/gateway', {}, JSON.stringify(message));
    }
    
    // Request simulation data
    requestSimulationData(dataType = "heart_rate") {
        if (!this.connected) return;
        
        const message = {
            type: "operator.event",
            version: "1.0",
            payload: {
                action: "simulation_data",
                parameters: {
                    event_type: dataType,
                    intensity: 1.0,
                    duration_ms: 0
                }
            }
        };
        
        this.stompClient.send('/app/gateway', {}, JSON.stringify(message));
    }
    
    // Start simulation
    startSimulation(parameters = null) {
        if (!this.connected) return;
        
        const message = {
            type: "start",
            parameters: parameters
        };
        
        this.stompClient.send('/app/gateway', {}, JSON.stringify(message));
    }
    
    // Stop simulation
    stopSimulation() {
        if (!this.connected) return;
        
        const message = { type: "stop" };
        this.stompClient.send('/app/gateway', {}, JSON.stringify(message));
    }
    
    // Send ping for keepalive
    ping() {
        if (!this.connected) return;
        
        const message = { type: "ping.ping" };
        this.stompClient.send('/app/gateway', {}, JSON.stringify(message));
    }
    
    // Start automatic keepalive
    startKeepalive() {
        setInterval(() => {
            this.ping();
        }, 10000); // Ping every 10 seconds
    }
    
    // Event handlers
    handleResponse(response) {
        console.log('Response received:', response);
        // Handle different response types
        if (response.type === 'operator.event') {
            const eventType = response.payload.parameters.event_type;
            if (eventType === 'acknowledged') {
                console.log('Event acknowledged');
            } else if (eventType === 'error') {
                console.error('Event error');
            }
        }
    }
    
    handleSimulationUpdate(update) {
        console.log('Simulation update:', update);
        // Update UI based on simulation status
        if (update.status === 'STARTED') {
            console.log('Simulation started');
        } else if (update.status === 'STOPPED') {
            console.log('Simulation stopped');
        }
    }
    
    handleSimulationData(data) {
        console.log('Simulation data:', data);
        // Process real-time simulation data
        // Update charts, graphs, etc.
    }
    
    disconnect() {
        if (this.stompClient) {
            this.stompClient.disconnect();
            this.connected = false;
        }
    }
}

// Usage
const client = new SimulationWebSocketClient();
client.connect();

// Inject early deceleration event
setTimeout(() => {
    client.injectEvent('early_deceleration', 0.7, 5000);
}, 2000);

// Start simulation
setTimeout(() => {
    client.startSimulation();
}, 1000);
```

## Error Handling

### Connection Errors
```javascript
stompClient.connect({}, 
    (frame) => {
        // Success callback
        console.log('Connected');
    },
    (error) => {
        // Error callback
        console.error('Connection failed:', error);
        // Implement reconnection logic
        setTimeout(() => {
            this.connect();
        }, 5000);
    }
);
```

### Message Errors
All error responses follow this format:
```json
{
    "type": "operator.event",
    "version": "1.0",
    "payload": {
        "action": "inject_event",
        "parameters": {
            "event_type": "error",
            "intensity": 0.0,
            "duration_ms": 0
        }
    }
}
```

## Health Check (REST)

While the main API is WebSocket-based, health checks remain available via REST:

```bash
# Check service health
curl http://localhost:8087/api/health

# Get API information
curl http://localhost:8087/api/info
```

## Migration from REST API

### Before (REST):
```javascript
// POST /api/gateway/event
fetch('/api/gateway/event', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(eventMessage)
});
```

### After (WebSocket):
```javascript
// Send via WebSocket
stompClient.send('/app/gateway', {}, JSON.stringify(eventMessage));
```

## Benefits of WebSocket Approach

1. **Real-time Communication**: Instant bidirectional messaging
2. **Persistent Connections**: No connection overhead per message
3. **Server Push**: Service can send data without client request
4. **Efficient**: Lower latency and bandwidth usage
5. **Scalable**: Better handling of multiple concurrent clients
6. **Live Updates**: Real-time simulation data streaming

## Connection Management

- **Automatic Reconnection**: Implement client-side reconnection logic
- **Keepalive**: Send ping every 10 seconds to maintain connection
- **Timeout**: Server closes connections after 30 seconds of inactivity
- **Session Tracking**: Each connection gets a unique session ID
- **Graceful Shutdown**: Properly close connections when done

This WebSocket API provides a robust, real-time communication channel between your frontend and the MATLAB simulation service, enabling responsive and interactive simulation control.
