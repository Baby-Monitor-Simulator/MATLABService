# MATLAB DTOs - JSON Format

## 1. MatlabOperatorEvent (Java → MATLAB)

Sent when starting simulation and continuing it. The service automatically manages a data buffer and requests more data when buffer falls below 20 points.

**Automatic Buffer Management:**
- Buffer threshold: 20 points
- Request batch size: 30 points
- Service automatically sends "continue" requests when buffer is low

**Fields:**
- `type`: String - "start" or "continue"
- `parameters`: Object containing:
  - `speed`: Integer - Simulation speed multiplier
  - `duration_in_timesteps`: Integer - Number of data points to generate
  - `CTG_type`: String - Type of CTG pattern
  - `intensity`: Integer - Event intensity level

### Start Request Example

```json
{
  "type": "start",
  "parameters": {
    "speed": 1,
    "duration_in_timesteps": 100,
    "CTG_type": "normal",
    "intensity": 50
  }
}
```

### Continue Request Example (Auto-sent by BufferManagementService)

```json
{
  "type": "continue",
  "parameters": {
    "speed": 1,
    "duration_in_timesteps": 30,
    "CTG_type": "normal",
    "intensity": 50
  }
}
```

---

## 2. MatlabSimulationUpdate (MATLAB → Java)

Sent by MATLAB with simulation data updates.

```json
{
  "type": "data",
  "timesteps": 150,
  "activeFetusCount": 2,
  "data": {
    "toco": [10.5, 12.3, 15.8],
    "maternal_oxygen_saturation": [98.5, 97.8, 98.1],
    "fetalheartrate": [
      [140.0, 142.5, 138.9],
      [145.2, 143.8, 146.1]
    ]
  }
}
```

**Fields:**
- `type`: String - Always "data"
- `timesteps`: Integer - Current simulation timestep
- `activeFetusCount`: Integer - Number of active fetuses in simulation
- `data`: Object containing:
  - `toco`: Array of Doubles - Tocography (contraction) values
  - `maternal_oxygen_saturation`: Array of Doubles - Maternal O2 saturation percentages
  - `fetalheartrate`: 2D Array of Doubles - Heart rate for each fetus (outer array = fetuses, inner array = timesteps)

---

## 3. Stop Command (Java → MATLAB)

Simple command to stop the simulation.

```json
{
  "type": "stop"
}
```

**Fields:**
- `type`: String - "stop"



# RabbitMQ DTOs - JSON Format

## 1. OperatorEvent (RabbitMQ → Java Service)

Received from RabbitMQ to control simulation and trigger operator events.

**Actions:**
- `start` - Start new simulation
- `stop` - Stop current simulation
- `operator.event` - Trigger operator event with parameter changes

```json
{
  "type": "operator.event",
  "version": "1.0",
  "payload": {
    "action": "start",
    "timestamp_in_timesteps": 0,
    "parameters": {
      "event_type": "normal",
      "intensity": 50.0,
      "duration_ms": 100
    }
  }
}
```

**Fields:**
- `type`: String - Always "operator.event"
- `version`: String - Protocol version (e.g., "1.0")
- `payload`: Object containing:
  - `action`: String - "start", "stop", or "operator.event"
  - `timestamp_in_timesteps`: Integer - Timestamp in simulation timesteps
  - `parameters`: Object containing:
    - `event_type`: String - Type of CTG event
    - `intensity`: Double - Event intensity level
    - `duration_ms`: Long - Duration in milliseconds (mapped to timesteps for MATLAB)

---

## 2. SimulationUpdate (Java Service → RabbitMQ)

Sent to RabbitMQ with simulation data updates from MATLAB.

```json
{
  "type": "simulation.update",
  "version": "1.0",
  "payload": {
    "total_timesteps": 0,
    "timesteps": 150,
    "fetus_count": 2,
    "maternal_data": {
      "toco": [10, 12, 15],
      "maternal_oxygen_saturation": [98, 97, 98]
    },
    "fetus_data": [
      [140, 142, 138],
      [145, 143, 146]
    ]
  }
}
```

**Fields:**
- `type`: String - Always "simulation.update"
- `version`: String - Protocol version (e.g., "1.0")
- `payload`: Object containing:
  - `total_timesteps`: Integer - Total timesteps since simulation start
  - `timesteps`: Integer - Current timestep
  - `fetus_count`: Integer - Number of active fetuses
  - `maternal_data`: Object containing:
    - `toco`: Array of Integers - Tocography (contraction) values
    - `maternal_oxygen_saturation`: Array of Integers - Maternal O2 saturation percentages
  - `fetus_data`: 2D Array of Integers - Heart rate for each fetus (outer array = fetuses, inner array = timesteps)

---

## Message Flow

```
RabbitMQ → MatlabService → MATLAB
(OperatorEvent)  ↓  (MatlabOperatorEvent)
                 ↓
                 ↓ BufferManagementService
                 ↓ (auto-requests more data)
                 ↓
MATLAB → MatlabService → RabbitMQ
(MatlabSimulationUpdate)  ↓  (SimulationUpdate)
```