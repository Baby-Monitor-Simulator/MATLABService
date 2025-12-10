# Event Gateway API Documentation

This document describes the new Event Gateway API that handles operator events and keepalive messages with the specified message structure.

## Message Format Overview

The service now supports two main message types:

### 1. Operator Events
```json
{
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
}
```

### 2. Ping/Pong and Simple Commands
```json
{ "type": "ping.ping" }
{ "type": "ping.pong" }
{ "type": "start" }
{ "type": "stop" }
```

## REST API Endpoints

### Base URL
```
http://localhost:8087/api/gateway
```

### 1. Send Operator Event
**POST** `/event`

Send operator events for injection or simulation data requests.

**Request Body (Inject Event):**
```json
{
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
}
```

**Request Body (Simulation Data):**
```json
{
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
}
```

**Response:**
```json
{
  "type": "operator.event",
  "version": "1.0",
  "payload": {
    "action": "inject_event",
    "parameters": {
      "event_type": "success",
      "intensity": 1.0,
      "duration_ms": 0
    }
  }
}
```

### 2. Ping/Pong Keepalive
**POST** `/ping`

Handle keepalive messages and simple commands.

**Request Body (Ping):**
```json
{ "type": "ping.ping" }
```

**Response:**
```json
{ "type": "ping.pong" }
```

### 3. Simple Start Command
**POST** `/start`

Start simulation with default parameters.

**Response:**
```json
{ "type": "ping.pong" }
```

### 4. Simple Stop Command
**POST** `/stop`

Stop current simulation.

**Response:**
```json
{ "type": "ping.pong" }
```

### 5. Gateway Status
**GET** `/status`

Get gateway status and connection information.

**Response:**
```json
{
  "activeConnections": 2,
  "status": "UP",
  "timestamp": "2024-11-18T10:30:00",
  "supportedEvents": [
    "early_deceleration",
    "late_deceleration", 
    "variable_deceleration",
    "normal_ctg"
  ]
}
```

### 6. API Information
**GET** `/info`

Get API format and endpoint information.

**Response:**
```json
{
  "version": "1.0",
  "messageFormat": {
    "operatorEvent": {
      "type": "operator.event",
      "version": "1.0",
      "payload": {
        "action": "inject_event | simulation_data",
        "parameters": {
          "event_type": "string",
          "intensity": "0.0-1.0",
          "duration_ms": "positive integer"
        }
      }
    },
    "ping": {
      "type": "ping.ping | ping.pong | start | stop"
    }
  },
  "endpoints": {
    "POST /api/gateway/event": "Send operator events",
    "POST /api/gateway/ping": "Ping/pong keepalive",
    "POST /api/gateway/start": "Simple start command",
    "POST /api/gateway/stop": "Simple stop command",
    "GET /api/gateway/status": "Get gateway status",
    "GET /api/gateway/info": "Get API information"
  }
}
```

## RabbitMQ Integration

### Queue Configuration
- **Commands Queue**: `simulation.commands`
- **Updates Queue**: `simulation.updates`

### Message Routing Keys
- `gateway.event.response` - Operator event responses
- `gateway.ping.response` - Ping/pong responses
- `gateway.error.response` - Error responses

### Sending Messages to RabbitMQ

**Operator Event:**
```json
{
  "type": "operator.event",
  "version": "1.0",
  "payload": {
    "action": "inject_event",
    "parameters": {
      "event_type": "late_deceleration",
      "intensity": 0.8,
      "duration_ms": 3000
    }
  }
}
```

**Ping Message:**
```json
{ "type": "ping.ping" }
```

**Simple Commands:**
```json
{ "type": "start" }
{ "type": "stop" }
```

## Supported Event Types

### Cardiovascular Events
- `early_deceleration` - Early fetal heart rate decelerations
- `late_deceleration` - Late fetal heart rate decelerations  
- `variable_deceleration` - Variable fetal heart rate decelerations
- `normal_ctg` - Normal cardiotocography pattern

### Parameters
- **event_type** (string, required): Type of event to inject
- **intensity** (double, 0.0-1.0): Event intensity/severity
- **duration_ms** (long, ≥0): Event duration in milliseconds

### Actions
- **inject_event**: Inject an event into the simulation
- **simulation_data**: Request current simulation data

## Connection Management

### Keepalive Mechanism
The service implements automatic connection tracking using ping/pong messages:

1. Clients send `{ "type": "ping.ping" }` periodically
2. Service responds with `{ "type": "ping.pong" }`
3. Connections timeout after 30 seconds without ping
4. Service tracks active connections and removes expired ones

### Connection Monitoring
- Active connections are tracked per thread/client
- Automatic cleanup of expired connections every 10 seconds
- Connection count available via `/status` endpoint

## Usage Examples

### cURL Examples

**Inject Early Deceleration:**
```bash
curl -X POST http://localhost:8087/api/gateway/event \
  -H "Content-Type: application/json" \
  -d '{
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
  }'
```

**Send Ping:**
```bash
curl -X POST http://localhost:8087/api/gateway/ping \
  -H "Content-Type: application/json" \
  -d '{ "type": "ping.ping" }'
```

**Simple Start:**
```bash
curl -X POST http://localhost:8087/api/gateway/start
```

**Simple Stop:**
```bash
curl -X POST http://localhost:8087/api/gateway/stop
```

### JavaScript Example

```javascript
const axios = require('axios');

const baseURL = 'http://localhost:8087/api/gateway';

// Inject event
async function injectEvent() {
  const message = {
    type: "operator.event",
    version: "1.0",
    payload: {
      action: "inject_event",
      parameters: {
        event_type: "late_deceleration",
        intensity: 0.8,
        duration_ms: 4000
      }
    }
  };
  
  try {
    const response = await axios.post(`${baseURL}/event`, message);
    console.log('Event injected:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}

// Send ping
async function sendPing() {
  try {
    const response = await axios.post(`${baseURL}/ping`, { type: "ping.ping" });
    console.log('Ping response:', response.data);
  } catch (error) {
    console.error('Ping error:', error.response.data);
  }
}

// Start simulation
async function startSimulation() {
  try {
    const response = await axios.post(`${baseURL}/start`);
    console.log('Start response:', response.data);
  } catch (error) {
    console.error('Start error:', error.response.data);
  }
}
```

### Python Example

```python
import requests
import json
import time

base_url = 'http://localhost:8087/api/gateway'

def inject_event():
    message = {
        "type": "operator.event",
        "version": "1.0",
        "payload": {
            "action": "inject_event",
            "parameters": {
                "event_type": "variable_deceleration",
                "intensity": 0.9,
                "duration_ms": 6000
            }
        }
    }
    
    response = requests.post(f'{base_url}/event', json=message)
    print('Event response:', response.json())

def send_ping():
    ping_message = {"type": "ping.ping"}
    response = requests.post(f'{base_url}/ping', json=ping_message)
    print('Ping response:', response.json())

def keepalive_loop():
    """Example keepalive loop"""
    while True:
        try:
            send_ping()
            time.sleep(10)  # Send ping every 10 seconds
        except Exception as e:
            print(f'Keepalive error: {e}')
            time.sleep(5)

# Start simulation
def start_simulation():
    response = requests.post(f'{base_url}/start')
    print('Start response:', response.json())

# Stop simulation  
def stop_simulation():
    response = requests.post(f'{base_url}/stop')
    print('Stop response:', response.json())
```

## Error Handling

### Error Response Format
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

### Common Errors
- **Invalid message type**: Unknown or missing `type` field
- **Missing payload**: Operator event without `payload`
- **Invalid parameters**: Missing or invalid `event_type`, `intensity`, or `duration_ms`
- **MATLAB unavailable**: Backend MATLAB service not responding
- **Validation errors**: Parameter values outside allowed ranges

## Integration with MATLAB

The service translates incoming messages to MATLAB TCP commands:

### Event Injection → MATLAB
```json
{
  "type": "inject_event",
  "event_type": "early_deceleration",
  "intensity": 0.7,
  "duration_ms": 5000
}
```

### Data Request → MATLAB
```json
{
  "type": "get_data",
  "data_type": "heart_rate"
}
```

### Simple Commands → MATLAB
```json
{ "type": "start" }
{ "type": "stop" }
```

## Monitoring and Logging

The service provides comprehensive logging:
- **INFO**: Event processing, command execution
- **DEBUG**: Ping/pong messages, connection tracking
- **WARN**: Connection timeouts, invalid messages
- **ERROR**: Processing failures, MATLAB communication errors

Log messages include:
- Timestamp and log level
- Component identifier (Gateway/RabbitMQ)
- Message details and processing results
- Error information when applicable

## Security and Validation

1. **Input Validation**: All parameters validated before processing
2. **Range Checking**: Intensity (0.0-1.0), duration (≥0)
3. **Type Safety**: Strong typing for all message components
4. **Error Isolation**: Exceptions contained and logged
5. **Resource Limits**: Connection timeout and cleanup

## Backward Compatibility

The new Event Gateway API runs alongside the existing simulation API:
- **Legacy API**: `/api/simulation/*` - Still available for detailed simulation control
- **New Gateway API**: `/api/gateway/*` - Simplified event-driven interface
- **Shared Backend**: Both APIs use the same MATLAB TCP client service
- **Independent Operation**: APIs can be used simultaneously without conflicts
