package com.babymonitoring.dto.RabbitMQ.simulationUpdate;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class MaternalData {
    @JsonProperty("toco")
    public List<Integer> toco;
    
    @JsonProperty("maternal_oxygen_saturation")
    public List<Integer> maternalOxygenSaturation;
}

