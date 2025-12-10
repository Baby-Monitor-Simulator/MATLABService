package com.babymonitoring.service;

import com.babymonitoring.api.websocket.MatlabConnection;
//import com.babymonitoring.dto.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;

/**
 * Core business logic service for simulation operations.
 * Handles simulation lifecycle (start/stop) and operator events.
 * Used by both WebSocket (EventGatewayController) and RabbitMQ (MessagingListener) transport layers.
 */
@Service
public class SimulationService {
    
    private static final Logger logger = LoggerFactory.getLogger(SimulationService.class);
    private final MatlabConnection matlabConnection;

    
    @Autowired
    public SimulationService(MatlabConnection matlabConnection) {
        this.matlabConnection = matlabConnection;
    }
    
    /**
     * Start the simulation
     * @throws RuntimeException if simulation fails to start
     */
    public void startSimulation() {
        logger.info("SimulationService: Starting simulation");
        
        try {
            if (!matlabConnection.isConnected()) {
                throw new RuntimeException("MATLAB connection not available");
            }
            
            boolean success = matlabConnection.startSimulation();
            if (!success) {
                throw new RuntimeException("Failed to send start command to MATLAB");
            }
            
            logger.info("SimulationService: Simulation start command sent successfully");
            
        } catch (Exception e) {
            logger.error("SimulationService: Error starting simulation", e);
            throw new RuntimeException("Failed to start simulation: " + e.getMessage(), e);
        }
    }
    
    /**
     * Stop the simulation
     * @throws RuntimeException if simulation fails to stop
     */
    public void stopSimulation() {
        logger.info("SimulationService: Stopping simulation");
        
        try {
            if (!matlabConnection.isConnected()) {
                throw new RuntimeException("MATLAB connection not available");
            }
            
            boolean success = matlabConnection.stopSimulation();
            if (!success) {
                throw new RuntimeException("Failed to send stop command to MATLAB");
            }
            
            logger.info("SimulationService: Simulation stop command sent successfully");
            
        } catch (Exception e) {
            logger.error("SimulationService: Error stopping simulation", e);
            throw new RuntimeException("Failed to stop simulation: " + e.getMessage(), e);
        }
    }
    
    /**
     * Process operator events (inject_event, etc.)
     * Returns a CompletableFuture for async processing
     * @param eventType The type of event to inject
     * @param intensity The intensity of the event
     * @param durationMs The duration of the event in milliseconds
     */
    public CompletableFuture<Void> processOperatorEvent(String eventType, double intensity, long durationMs) {
        logger.info("SimulationService: Processing operator event - type: {}, intensity: {}, duration: {}ms", 
                   eventType, intensity, durationMs);
        
        return CompletableFuture.runAsync(() -> {
            try {
                if (!matlabConnection.isConnected()) {
                    throw new RuntimeException("MATLAB connection not available");
                }
                
                boolean success = matlabConnection.sendOperatorEvent(eventType, intensity, durationMs);
                if (!success) {
                    throw new RuntimeException("Failed to send operator event to MATLAB");
                }
                
                logger.info("SimulationService: Operator event sent successfully");
                
            } catch (Exception e) {
                logger.error("SimulationService: Error processing operator event", e);
                throw new RuntimeException("Failed to process operator event: " + e.getMessage(), e);
            }
        });
    }
    
    /**
     * Check if the simulation is alive (keepalive/health check)
     * @return true if simulation is responsive
     */
    public boolean isSimulationAlive() {
        logger.debug("SimulationService: Checking simulation health");
        
        try {
            return matlabConnection.isConnected();
            
        } catch (Exception e) {
            logger.error("SimulationService: Error checking simulation health", e);
            return false;
        }
    }
    
    /**
     * Get connection status
     */
    public String getConnectionStatus() {
        return matlabConnection.getStatus();
    }
}
