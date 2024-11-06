package com.babymonitoring.simulationplayer.models.events;

public class SimulationUpdate {
    private Long lobbyId;
    private String status;

    public SimulationUpdate() {}

    public SimulationUpdate(Long lobbyId, String status) {
        this.lobbyId = lobbyId;
        this.status = status;
    }

    // Getters and Setters
    public Long getLobbyId() {
        return lobbyId;
    }

    public void setLobbyId(Long lobbyId) {
        this.lobbyId = lobbyId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
