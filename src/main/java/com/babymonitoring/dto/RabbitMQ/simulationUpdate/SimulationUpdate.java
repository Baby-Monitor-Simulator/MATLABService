package com.babymonitoring.dto.RabbitMQ.simulationUpdate;

import com.fasterxml.jackson.annotation.JsonProperty;

public class SimulationUpdate {
    @JsonProperty("type")
    public String type = "simulation.update";
    
    @JsonProperty("version")
    public String version = "1.0";
    
    @JsonProperty("payload")
    public SimulationUpdatePayload payload;

    public SimulationUpdate() {
        this.payload = new SimulationUpdatePayload();
    }
}
