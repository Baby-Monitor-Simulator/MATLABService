package com.babymonitoring.dto.Matlab.simulationUpdate;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MatlabSimulationUpdate {
    @JsonProperty("type")
    public final String type = "data";
    
    @JsonProperty("timesteps")
    public int timesteps;
    
    @JsonProperty("activeFetusCount")
    public int activeFetusCount;
    
    @JsonProperty("data")
    public SimulationUpdateData data;

    public MatlabSimulationUpdate() {
        this.data = new SimulationUpdateData();
    }
}

