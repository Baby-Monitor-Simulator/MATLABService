package com.babymonitoring.simulationplayer.models.messages;

import com.babymonitoring.simulationplayer.models.results.FMPResult;

import java.util.UUID;

/**
 * Class for a FMPResult message to a UUID user
 */
public class CoordsMessage extends Message {
    FMPResult fmpResult;

    public CoordsMessage(UUID userId, FMPResult fmpResult) {
        UserId = userId;
        this.fmpResult = fmpResult;
    }

    public void setFMP(FMPResult fmpResult) {
        this.fmpResult = fmpResult;
    }

    public FMPResult getFMP() {
        return fmpResult;
    }
}