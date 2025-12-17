package com.babymonitoring.api.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;
import com.babymonitoring.service.SimulationService;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.io.*;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.*;
import java.util.function.Consumer;
import java.util.HashMap;

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

    private final SimulationService simulationService;
    
    @Autowired
    public MatlabConnection(@Lazy SimulationService simulationService) {
        this.simulationService = simulationService;
    }
    
    @PostConstruct
    public void initialize() {
        logger.info("Initializing MATLAB connection...");
        running = true;  // Set this before connect() so reconnects work
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
         * Handle incoming message from MATLAB
         */
    private void handleMatlabMessage(String message) {
        try {
            logger.info("Processing MATLAB message: {}", message);
            this.simulationService.handleMatlabMessage(message);
            
        } catch (Exception e) {
            logger.error("Error handling MATLAB message: {}", message, e);
        }
    }
    /**
     * Create json {"type": "stop"} and send to MATLAB
     */
    public boolean stopScript() {
        HashMap<String, String> stopCommand = new HashMap<String, String>();
        stopCommand.put("type", "stop");
        return sendMessage(stopCommand);
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
            logger.info("✓ Connected to MATLAB successfully");
            
            // Start listening for messages from MATLAB
            executorService.submit(this::listenForMessages);
            
        } catch (Exception e) {
            logger.error("Failed to connect to MATLAB: {}", e.getMessage());
            scheduleReconnect();
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
     * Handle disconnection
     */
    private void handleDisconnect() {
        disconnect();
        scheduleReconnect();
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
    public boolean isConnected() {
        if (connected) {
            return true;
        } else {
            return false;
        }
    }
}

