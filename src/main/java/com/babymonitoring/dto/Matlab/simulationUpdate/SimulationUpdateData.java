package com.babymonitoring.dto.Matlab.simulationUpdate;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class SimulationUpdateData {
    @JsonProperty("toco")
    public List<Double> toco;
    
    @JsonProperty("maternal_oxygen_saturation")
    public List<Double> maternal_oxygen_saturation;
    
    @JsonProperty("fetalheartrate")
    public List<List<Double>> fetalheartrate;
}

