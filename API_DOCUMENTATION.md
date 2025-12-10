# MATLAB Simulation Service API Documentation

This service provides REST API and RabbitMQ interfaces for controlling MATLAB cardiovascular simulation scripts.

## Overview

The service acts as a bridge between external clients and MATLAB simulation scripts, providing:
- **REST API** endpoints for direct HTTP communication
- **RabbitMQ** messaging for event-driven communication
- **TCP client** for communicating with MATLAB server
- **Real-time status tracking** and health monitoring

## Architecture

```
Client → REST API / RabbitMQ → SimulationControlService → MatlabTcpClientService → MATLAB
```

## REST API Endpoints

### Base URL
```
http://localhost:8087/api/simulation
```

### 1. Start Simulation
**POST** `/start`

Start a new MATLAB simulation with specified parameters.

**Request Body:**
```json
{
  "script": "FMP_aanpassingen.m",
  "ncyclemax": 300,
  "scen": 0,
  "HES": false,
  "persen": false
}
```

**Parameters:**
- `script` (string, required): MATLAB script name (default: "FMP_aanpassingen.m")
- `ncyclemax` (integer, 1-10000, required): Maximum number of simulation cycles
- `scen` (integer, 0-3, required): Scenario type:
  - `0`: Normal CTG
  - `1`: Early decelerations
  - `2`: Late decelerations  
  - `3`: Variable decelerations
- `HES` (boolean, required): Fluid bolus administration
- `persen` (boolean, required): Maternal pushing simulation

**Response:**
```json
{
  "success": true,
  "message": "Simulation started successfully",
  "command": "start",
  "timestamp": "2024-11-18T10:30:00",
  "matlabResponse": "{\"status\":\"started\"}"
}
```

**Status Codes:**
- `200 OK`: Simulation started successfully
- `400 Bad Request`: Invalid parameters or simulation already running
- `500 Internal Server Error`: MATLAB service unavailable or internal error

### 2. Update Simulation
**PUT** `/update`

Update parameters of a running simulation.

**Request Body:**
```json
{
  "ncyclemax": 500,
  "scen": 2,
  "HES": true,
  "persen": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Simulation updated successfully",
  "command": "update",
  "timestamp": "2024-11-18T10:35:00",
  "matlabResponse": "{\"status\":\"updated\"}"
}
```

### 3. Stop Simulation
**POST** `/stop`

Stop the currently running simulation.

**Response:**
```json
{
  "success": true,
  "message": "Simulation stopped successfully",
  "command": "stop",
  "timestamp": "2024-11-18T10:40:00",
  "matlabResponse": "{\"status\":\"stopped\"}"
}
```

### 4. Get Status
**GET** `/status`

Get current simulation status.

**Response:**
```json
{
  "success": true,
  "message": "Simulation running: FMP_aanpassingen.m with params: [300, 0, 0, 0]",
  "command": "status",
  "timestamp": "2024-11-18T10:45:00"
}
```

### 5. Health Check
**GET** `/health`

Check MATLAB service health and connectivity.

**Response:**
```json
{
  "matlabAvailable": true,
  "simulationRunning": true,
  "currentScript": "FMP_aanpassingen.m",
  "status": "UP",
  "timestamp": "2024-11-18T10:50:00"
}
```

### 6. Force Reset
**POST** `/reset`

Emergency endpoint to reset simulation state.

**Response:**
```json
{
  "success": true,
  "message": "Simulation state has been reset",
  "command": "reset",
  "timestamp": "2024-11-18T10:55:00"
}
```

### 7. Get Info
**GET** `/info`

Get information about supported parameters and scenarios.

**Response:**
```json
{
  "supportedScenarios": {
    "0": "Normal CTG",
    "1": "Early decelerations",
    "2": "Late decelerations", 
    "3": "Variable decelerations"
  },
  "parameters": {
    "ncyclemax": "Maximum number of cycles (1-10000)",
    "scen": "Scenario type (0-3)",
    "HES": "Fluid bolus administration (boolean)",
    "persen": "Maternal pushing simulation (boolean)"
  },
  "defaultScript": "FMP_aanpassingen.m",
  "version": "1.0.0"
}
```

## RabbitMQ Integration

### Configuration
The service uses RabbitMQ for asynchronous command processing and event notifications.

**Exchange:** `topic-exchange`
**Queues:**
- `simulation.commands` - Receives simulation commands
- `simulation.updates` - Publishes simulation status updates

### Command Format
Send commands to the `simulation.commands` queue:

```json
{
  "type": "start",
  "params": {
    "script": "FMP_aanpassingen.m",
    "ncyclemax": 300,
    "scen": 0,
    "HES": false,
    "persen": false
  }
}
```

**Supported Command Types:**
- `start` - Start new simulation
- `update` - Update simulation parameters
- `stop` - Stop current simulation
- `status` - Get current status
- `reset` - Force reset simulation state

### Response Routing Keys
Responses are published with routing keys:
- `simulation.response.start`
- `simulation.response.update`
- `simulation.response.stop`
- `simulation.response.status`
- `simulation.response.reset`
- `simulation.response.error`

### Status Updates
Automatic status updates are published with routing key `matlab.simulationUpdated`:

```json
{
  "status": "STARTED",
  "message": "Simulation started successfully",
  "timestamp": "2024-11-18T10:30:00",
  "script": "FMP_aanpassingen.m",
  "params": [300, 0, 0, 0]
}
```

## Configuration

### Environment Variables

**MATLAB Connection:**
- `MATLAB_HOST` (default: matlab-script)
- `MATLAB_PORT` (default: 12345)
- `MATLAB_CONNECTION_TIMEOUT` (default: 5000ms)
- `MATLAB_READ_TIMEOUT` (default: 10000ms)

**RabbitMQ Connection:**
- `RABBITMQ_HOST`
- `RABBITMQ_PORT`
- `RABBITMQ_USERNAME`
- `RABBITMQ_PASSWORD`
- `RABBITMQ_VHOST`

**Server:**
- `SERVER_PORT` (default: 8087)

### Docker Compose
```yaml
services:
  matlab-service:
    environment:
      MATLAB_HOST: matlab-script
      MATLAB_PORT: 12345
      RABBITMQ_HOST: rabbitmq
      RABBITMQ_PORT: 5672
      RABBITMQ_USERNAME: guest
      RABBITMQ_PASSWORD: guest
```

## Error Handling

### Common Error Responses

**Simulation Already Running:**
```json
{
  "success": false,
  "message": "Simulation is already running. Stop it first or use update.",
  "command": "start",
  "timestamp": "2024-11-18T10:30:00"
}
```

**MATLAB Service Unavailable:**
```json
{
  "success": false,
  "message": "MATLAB service is not available",
  "command": "start",
  "timestamp": "2024-11-18T10:30:00"
}
```

**Invalid Parameters:**
```json
{
  "success": false,
  "message": "Validation failed: ncyclemax must be between 1 and 10000",
  "command": "start",
  "timestamp": "2024-11-18T10:30:00"
}
```

## Usage Examples

### cURL Examples

**Start Simulation:**
```bash
curl -X POST http://localhost:8087/api/simulation/start \
  -H "Content-Type: application/json" \
  -d '{
    "script": "FMP_aanpassingen.m",
    "ncyclemax": 300,
    "scen": 0,
    "HES": false,
    "persen": false
  }'
```

**Update Parameters:**
```bash
curl -X PUT http://localhost:8087/api/simulation/update \
  -H "Content-Type: application/json" \
  -d '{
    "ncyclemax": 500,
    "scen": 2
  }'
```

**Stop Simulation:**
```bash
curl -X POST http://localhost:8087/api/simulation/stop
```

**Check Status:**
```bash
curl http://localhost:8087/api/simulation/status
```

### JavaScript/Node.js Example

```javascript
const axios = require('axios');

const baseURL = 'http://localhost:8087/api/simulation';

// Start simulation
async function startSimulation() {
  try {
    const response = await axios.post(`${baseURL}/start`, {
      script: 'FMP_aanpassingen.m',
      ncyclemax: 300,
      scen: 0,
      HES: false,
      persen: false
    });
    console.log('Simulation started:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}

// Update simulation
async function updateSimulation() {
  try {
    const response = await axios.put(`${baseURL}/update`, {
      ncyclemax: 500,
      scen: 2
    });
    console.log('Simulation updated:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}

// Stop simulation
async function stopSimulation() {
  try {
    const response = await axios.post(`${baseURL}/stop`);
    console.log('Simulation stopped:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}
```

### Python Example

```python
import requests
import json

base_url = 'http://localhost:8087/api/simulation'

# Start simulation
def start_simulation():
    payload = {
        'script': 'FMP_aanpassingen.m',
        'ncyclemax': 300,
        'scen': 0,
        'HES': False,
        'persen': False
    }
    
    response = requests.post(f'{base_url}/start', json=payload)
    
    if response.status_code == 200:
        print('Simulation started:', response.json())
    else:
        print('Error:', response.json())

# Update simulation
def update_simulation():
    payload = {
        'ncyclemax': 500,
        'scen': 2
    }
    
    response = requests.put(f'{base_url}/update', json=payload)
    print('Update response:', response.json())

# Check status
def check_status():
    response = requests.get(f'{base_url}/status')
    print('Status:', response.json())

# Health check
def health_check():
    response = requests.get(f'{base_url}/health')
    print('Health:', response.json())
```

## Monitoring and Logging

The service provides comprehensive logging at different levels:
- **INFO**: Command execution, status changes
- **DEBUG**: Detailed communication with MATLAB
- **WARN**: Connection issues, retry attempts
- **ERROR**: Failures, exceptions

Log messages include:
- Timestamp
- Log level
- Component (REST/RabbitMQ/TCP)
- Action and details
- Error information when applicable

## Security Considerations

1. **Network Security**: Ensure MATLAB TCP port (12345) is not exposed externally
2. **Input Validation**: All parameters are validated before sending to MATLAB
3. **Resource Limits**: Simulation parameters have reasonable bounds
4. **Error Handling**: Sensitive information is not exposed in error messages
5. **Authentication**: Consider adding authentication for production use

## Troubleshooting

### Common Issues

**MATLAB Service Not Available:**
- Check if MATLAB container is running
- Verify network connectivity between containers
- Check MATLAB startup logs for errors

**Simulation Won't Start:**
- Verify all required parameters are provided
- Check parameter ranges (ncyclemax: 1-10000, scen: 0-3)
- Ensure no simulation is already running

**RabbitMQ Connection Issues:**
- Verify RabbitMQ service is running
- Check connection parameters
- Ensure queues and exchanges are properly configured

**Timeout Issues:**
- Increase MATLAB_READ_TIMEOUT for long-running operations
- Check MATLAB script performance
- Monitor system resources

### Debug Commands

```bash
# Check service health
curl http://localhost:8087/api/simulation/health

# Force reset if stuck
curl -X POST http://localhost:8087/api/simulation/reset

# Check logs
docker logs matlab-service

# Test MATLAB connectivity
docker exec matlab-service nc -zv matlab-script 12345
```
