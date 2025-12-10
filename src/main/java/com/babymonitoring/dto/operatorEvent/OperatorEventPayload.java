package com.babymonitoring.dto.operatorEvent;

import com.fasterxml.jackson.annotation.JsonProperty;

public class OperatorEventPayload {
    @JsonProperty("action")
    public String action;
    
    @JsonProperty("timestamp_in_timesteps")
    public int timestampInTimesteps;
    
    @JsonProperty("parameters")
    public Parameters parameters;
}
