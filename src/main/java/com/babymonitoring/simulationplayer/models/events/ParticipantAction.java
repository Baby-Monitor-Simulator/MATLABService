package com.babymonitoring.simulationplayer.models.events;


public class ParticipantAction {
    private Long participantId;
    private String action;

    public ParticipantAction(Long participantId, String action) {
        this.participantId = participantId;
        this.action = action;
    }

    // Getters and Setters
    public Long getParticipantId() {
        return participantId;
    }

    public void setParticipantId(Long participantId) {
        this.participantId = participantId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}


