package com.babymonitoring.dto.RabbitMQ.simulationUpdate;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class SimulationUpdatePayload {
    @JsonProperty("total_timesteps")
    public int totalTimesteps;
    
    @JsonProperty("timesteps")
    public int timesteps;
    
    @JsonProperty("fetus_count")
    public int fetusCount;
    
    @JsonProperty("maternal_data")
    public MaternalData maternalData;
    
    @JsonProperty("fetus_data")
    public List<List<Integer>> fetusData;
}
