package com.babymonitoring.dto.Matlab.operatorEvent;

import com.fasterxml.jackson.annotation.JsonProperty;

public class OperatorEventParameters {
    @JsonProperty("speed")
    public int speed;
    
    @JsonProperty("duration_in_timesteps")
    public int duration_in_timesteps;
    
    @JsonProperty("CTG_type")
    public String CTG_type;
    
    @JsonProperty("intensity")
    public int intensity;
}

