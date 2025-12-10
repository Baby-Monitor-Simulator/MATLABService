package com.babymonitoring.dto.operatorEvent;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Parameters {
    @JsonProperty("event_type")
    public String eventType;
    
    @JsonProperty("intensity")
    public double intensity;
    
    @JsonProperty("duration_ms")
    public long durationMs;
}
