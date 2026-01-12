package com.babymonitoring.service;

import com.babymonitoring.api.websocket.MatlabConnection;
import com.babymonitoring.dto.RabbitMQ.operatorEvent.OperatorEvent;
import com.babymonitoring.dto.RabbitMQ.simulationUpdate.SimulationUpdate;
import com.babymonitoring.utils.RabbitMQMatlabMapper;
import com.babymonitoring.dto.Matlab.simulationUpdate.MatlabSimulationUpdate;
import com.babymonitoring.dto.Matlab.operatorEvent.MatlabOperatorEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import com.babymonitoring.api.messaging.MessagingSender;

/**
 * Core business logic service for simulation operations.
 * Handles simulation lifecycle (start/stop) and operator events.
 * Used by both WebSocket (EventGatewayController) and RabbitMQ (MessagingListener) transport layers.
 */
@Service
public class SimulationService {
    
    private static final Logger logger = LoggerFactory.getLogger(SimulationService.class);
    private final MatlabConnection matlabConnection;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final MessagingSender messagingSender;
    private final BufferManagementService bufferManagementService;
    
    @Autowired
    public SimulationService(
            MatlabConnection matlabConnection, 
            MessagingSender messagingSender,
            @Lazy BufferManagementService bufferManagementService) {
        this.messagingSender = messagingSender;
        this.matlabConnection = matlabConnection;
        this.bufferManagementService = bufferManagementService;
    }
    
    /**
     * Start the simulation
     * @throws RuntimeException if simulation fails to start
     */
    public void startSimulation(OperatorEvent operatorEvent) {
        logger.info("SimulationService: Starting simulation");
        
        try {
            // create connection then send message
            matlabConnection.initialize();
            if (!matlabConnection.isConnected()) {
                throw new RuntimeException("MATLAB connection not available");
            }
            MatlabOperatorEvent matlabOperatorEvent = RabbitMQMatlabMapper.toMatlab(operatorEvent);
            
            // Start buffer management with initial parameters
            bufferManagementService.start(matlabOperatorEvent.parameters);
            
            boolean success = matlabConnection.sendMessage(matlabOperatorEvent);
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
            // Stop buffer management
            bufferManagementService.stop();
            
            if (!matlabConnection.isConnected()) {
                throw new RuntimeException("MATLAB connection not available");
            }
            
            boolean success = matlabConnection.stopScript();
            if (!success) {
                throw new RuntimeException("Failed to send stop command to MATLAB");
            }
            
            logger.info("SimulationService: Simulation stop command sent successfully");
            
        } catch (Exception e) {
            logger.error("SimulationService: Error stopping simulation", e);
            throw new RuntimeException("Failed to stop simulation: " + e.getMessage(), e);
        }
    }
    
    public void processOperatorEvent(OperatorEvent operatorEvent) {
        logger.info("SimulationService: Processing operator event: {}", operatorEvent.payload.action);
        try {
            MatlabOperatorEvent matlabOperatorEvent = RabbitMQMatlabMapper.toMatlab(operatorEvent);
            
            // Update buffer management parameters
            bufferManagementService.updateParameters(matlabOperatorEvent.parameters);
            
            boolean success = matlabConnection.sendMessage(matlabOperatorEvent);
            if (!success) {
                throw new RuntimeException("Failed to send operator event to MATLAB");
            }
            logger.info("SimulationService: Operator event sent successfully");
        } catch (Exception e) {
            logger.error("SimulationService: Error processing operator event", e);
            throw new RuntimeException("Failed to process operator event: " + e.getMessage(), e);
        }
    }
    
    /**
     * Get connection status
     */
    public boolean getConnectionStatus() {
        return matlabConnection.isConnected();
    }
    
    /**
     * Handle incoming message from RabbitMQ or other sources
     * Decodes message and routes to appropriate handler method
     * @param messageJson The JSON message to process
     */
    public void handleIncomingMessage(String messageJson) {
        try {
            logger.info("SimulationService: Handling command message: {}", messageJson);
            OperatorEvent operatorEvent = objectMapper.readValue(messageJson, OperatorEvent.class); 
            switch (operatorEvent.payload.action) {
                case "start":
                    this.startSimulation(operatorEvent);
                    break;
                case "stop":
                    this.stopSimulation();
                    break;
                case "operator.event":
                    this.processOperatorEvent(operatorEvent);
                    break;
                default:
                    logger.error("SimulationService: Unknown command type: {}", operatorEvent.payload.action);
                    break;
            }
            
        } catch (Exception e) {
            logger.error("SimulationService: Incoming json structure does not match expected structure from DTO", e);
        }
    }

    public void handleMatlabMessage(String messageJson) {
        try {
            logger.info("SimulationService: Handling MATLAB message: {}", messageJson);
            MatlabSimulationUpdate matlabSimulationUpdate = objectMapper.readValue(messageJson, MatlabSimulationUpdate.class);
            switch (matlabSimulationUpdate.type) {
                case "data":
                    // Notify buffer management of incoming data
                    bufferManagementService.processDataUpdate(matlabSimulationUpdate);
                    
                    // Convert and send to RabbitMQ
                    SimulationUpdate simulationUpdate = RabbitMQMatlabMapper.toRabbitMQ(matlabSimulationUpdate);
                    messagingSender.sendToTestExchange("simulation.update", simulationUpdate);
                    
                    // Mark data as consumed from buffer
                    int dataPoints = matlabSimulationUpdate.data.toco != null ? 
                        matlabSimulationUpdate.data.toco.size() : 0;
                    bufferManagementService.consumeDataPoints(dataPoints);
                    
                    break;
                default:
                    logger.error("SimulationService: Unknown MATLAB message type: {}", matlabSimulationUpdate.type);
                    break;
            }
        } catch (Exception e) {
            logger.error("SimulationService: Error handling MATLAB message", e);
        }
    }
}
