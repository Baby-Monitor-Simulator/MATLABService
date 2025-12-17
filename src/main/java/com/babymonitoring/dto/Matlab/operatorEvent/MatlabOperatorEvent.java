package com.babymonitoring.dto.Matlab.operatorEvent;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MatlabOperatorEvent {
    @JsonProperty("type")
    public String type; // "start" or "continue"
    
    @JsonProperty("parameters")
    public OperatorEventParameters parameters;

    public MatlabOperatorEvent() {
        this.parameters = new OperatorEventParameters();
    }
}

