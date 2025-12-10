package com.babymonitoring.api.websocket;

import com.babymonitoring.dto.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.io.*;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.*;
import java.util.function.Consumer;

/**
 * Manages TCP socket connection to MATLAB script container
 */
@Component
public class MatlabConnection {
    
    private static final Logger logger = LoggerFactory.getLogger(MatlabConnection.class);
    
    private static final String MATLAB_HOST = "matlab-script";
    private static final int MATLAB_PORT = 12345;
    private static final int RECONNECT_DELAY_MS = 5000;
    
    private Socket socket;
    private BufferedReader reader;
    private PrintWriter writer;
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    private final ExecutorService executorService = Executors.newSingleThreadExecutor();
    private final ScheduledExecutorService reconnectScheduler = Executors.newSingleThreadScheduledExecutor();
    
    private volatile boolean running = false;
    private volatile boolean connected = false;
    private Consumer<String> messageHandler;
    
    @PostConstruct
    public void initialize() {
        logger.info("Initializing MATLAB connection...");
        connect();
    }
    
    @PreDestroy
    public void shutdown() {
        logger.info("Shutting down MATLAB connection...");
        running = false;
        disconnect();
        executorService.shutdown();
        reconnectScheduler.shutdown();
    }
    
    /**
     * Establish connection to MATLAB
     */
    private synchronized void connect() {
        if (connected) {
            return;
        }
        
        try {
            logger.info("Connecting to MATLAB at {}:{}...", MATLAB_HOST, MATLAB_PORT);
            socket = new Socket(MATLAB_HOST, MATLAB_PORT);
            socket.setKeepAlive(true);
            socket.setSoTimeout(60000); // 60 second read timeout
            
            reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            writer = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()), true);
            
            connected = true;
            running = true;
            logger.info("✓ Connected to MATLAB successfully");
            
            // Start listening for messages from MATLAB
            executorService.submit(this::listenForMessages);
            
        } catch (Exception e) {
            logger.error("Failed to connect to MATLAB: {}", e.getMessage());
            scheduleReconnect();
        }
    }
    
    /**
     * Disconnect from MATLAB
     */
    private synchronized void disconnect() {
        connected = false;
        
        try {
            if (writer != null) writer.close();
            if (reader != null) reader.close();
            if (socket != null && !socket.isClosed()) socket.close();
        } catch (IOException e) {
            logger.error("Error closing MATLAB connection", e);
        }
    }
    
    /**
     * Schedule reconnection attempt
     */
    private void scheduleReconnect() {
        if (!running) return;
        
        logger.info("Scheduling reconnection in {}ms...", RECONNECT_DELAY_MS);
        reconnectScheduler.schedule(() -> {
            if (!connected && running) {
                connect();
            }
        }, RECONNECT_DELAY_MS, TimeUnit.MILLISECONDS);
    }
    
    /**
     * Listen for incoming messages from MATLAB
     */
    private void listenForMessages() {
        logger.info("Started listening for MATLAB messages");
        
        while (running && connected) {
            try {
                String line = reader.readLine();
                if (line == null) {
                    logger.warn("MATLAB connection closed by remote host");
                    handleDisconnect();
                    break;
                }
                
                logger.debug("Received from MATLAB: {}", line);
                
                if (messageHandler != null) {
                    messageHandler.accept(line);
                } else {
                    handleMatlabMessage(line);
                }
                
            } catch (SocketException e) {
                if (running) {
                    logger.error("Socket error while reading from MATLAB", e);
                    handleDisconnect();
                }
                break;
            } catch (IOException e) {
                if (running) {
                    logger.error("Error reading from MATLAB", e);
                    handleDisconnect();
                }
                break;
            } catch (Exception e) {
                logger.error("Unexpected error processing MATLAB message", e);
            }
        }
        
        logger.info("Stopped listening for MATLAB messages");
    }
    
    /**
     * Handle incoming message from MATLAB
     */
    private void handleMatlabMessage(String message) {
        try {
            // Parse JSON message from MATLAB
            // Expected format: {"type": "simulation.update", "payload": {...}}
            logger.info("Processing MATLAB message: {}", message);
            
            // TODO: Parse and forward to WebSocket clients or process as needed
            
        } catch (Exception e) {
            logger.error("Error handling MATLAB message: {}", message, e);
        }
    }
    
    /**
     * Handle disconnection
     */
    private void handleDisconnect() {
        disconnect();
        scheduleReconnect();
    }
    
    /**
     * Send message to MATLAB
     */
    public synchronized boolean sendMessage(Object message) {
        if (!connected) {
            logger.warn("Cannot send message - not connected to MATLAB");
            return false;
        }
        
        try {
            String json = objectMapper.writeValueAsString(message);
            logger.debug("Sending to MATLAB: {}", json);
            writer.println(json);
            return !writer.checkError();
        } catch (Exception e) {
            logger.error("Error sending message to MATLAB", e);
            return false;
        }
    }
    
    /**
     * Send start simulation command
     */
    public boolean startSimulation() {
        logger.info("Sending start command to MATLAB");
        SimpleCommandMessage message = SimpleCommandMessage.start();
        return sendMessage(message);
    }
    
    /**
     * Send stop simulation command
     */
    public boolean stopSimulation() {
        logger.info("Sending stop command to MATLAB");
        SimpleCommandMessage message = SimpleCommandMessage.stop();
        return sendMessage(message);
    }
    
    /**
     * Send operator event to MATLAB
     */
    public boolean sendOperatorEvent(String eventType, double intensity, long durationMs) {
        logger.info("Sending operator event to MATLAB: {} (intensity={}, duration={}ms)", 
                   eventType, intensity, durationMs);
        OperatorEventMessage message = OperatorEventMessage.createInjectEvent(eventType, intensity, durationMs);
        return sendMessage(message);
    }
    
    /**
     * Send ping to MATLAB
     */
    public boolean sendPing() {
        PingMessage message = PingMessage.ping();
        return sendMessage(message);
    }
    
    /**
     * Check if connected
     */
    public boolean isConnected() {
        return connected && socket != null && !socket.isClosed();
    }
    
    /**
     * Set custom message handler
     */
    public void setMessageHandler(Consumer<String> handler) {
        this.messageHandler = handler;
    }
    
    /**
     * Get connection status
     */
    public String getStatus() {
        if (connected) {
            return "Connected to " + MATLAB_HOST + ":" + MATLAB_PORT;
        } else {
            return "Disconnected (reconnecting...)";
        }
    }
}

