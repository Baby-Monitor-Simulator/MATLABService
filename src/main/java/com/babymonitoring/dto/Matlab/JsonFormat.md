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

