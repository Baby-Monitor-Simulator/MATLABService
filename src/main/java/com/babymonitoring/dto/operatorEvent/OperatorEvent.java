package com.babymonitoring.dto.operatorEvent;

import com.fasterxml.jackson.annotation.JsonProperty;

public class OperatorEvent {
    @JsonProperty("type")
    public final String type = "operator.event";
    
    @JsonProperty("version")
    public String version = "1.0";
    
    @JsonProperty("payload")
    public OperatorEventPayload payload;

    public OperatorEvent() {
        this.payload = new OperatorEventPayload();
    }
}
