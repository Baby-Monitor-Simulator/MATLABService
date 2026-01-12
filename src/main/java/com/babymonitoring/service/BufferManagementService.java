package com.babymonitoring.service;

import com.babymonitoring.api.websocket.MatlabConnection;
import com.babymonitoring.dto.Matlab.operatorEvent.MatlabOperatorEvent;
import com.babymonitoring.dto.Matlab.operatorEvent.OperatorEventParameters;
import com.babymonitoring.dto.Matlab.simulationUpdate.MatlabSimulationUpdate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Manages simulation data buffer to ensure continuous data availability.
 * Automatically requests more data from MATLAB when buffer falls below threshold.
 */
@Service
public class BufferManagementService {
    
    private static final Logger logger = LoggerFactory.getLogger(BufferManagementService.class);
    
    private static final int BUFFER_LOW_THRESHOLD = 20;
    private static final int REQUEST_BATCH_SIZE = 30;
    
    private final MatlabConnection matlabConnection;
    
    private final AtomicInteger bufferSize = new AtomicInteger(0);
    private final AtomicBoolean isRunning = new AtomicBoolean(false);
    private final AtomicBoolean requestInProgress = new AtomicBoolean(false);
    
    // Store last known parameters for continue requests
    private volatile OperatorEventParameters lastParameters;
    
    @Autowired
    public BufferManagementService(MatlabConnection matlabConnection) {
        this.matlabConnection = matlabConnection;
    }
    
    /**
     * Start buffer management with initial parameters
     */
    public void start(OperatorEventParameters initialParameters) {
        logger.info("BufferManagementService: Starting with parameters: speed={}, CTG_type={}, intensity={}", 
            initialParameters.speed, initialParameters.CTG_type, initialParameters.intensity);
        
        this.lastParameters = initialParameters;
        this.isRunning.set(true);
        this.bufferSize.set(0);
        this.requestInProgress.set(false);
    }
    
    /**
     * Stop buffer management
     */
    public void stop() {
        logger.info("BufferManagementService: Stopping");
        this.isRunning.set(false);
        this.bufferSize.set(0);
        this.requestInProgress.set(false);
    }
    
    /**
     * Update buffer parameters (for operator events)
     */
    public void updateParameters(OperatorEventParameters newParameters) {
        logger.info("BufferManagementService: Updating parameters: speed={}, CTG_type={}, intensity={}", 
            newParameters.speed, newParameters.CTG_type, newParameters.intensity);
        this.lastParameters = newParameters;
    }
    
    /**
     * Process incoming data update from MATLAB and manage buffer
     */
    public void processDataUpdate(MatlabSimulationUpdate update) {
        if (!isRunning.get()) {
            logger.debug("BufferManagementService: Not running, ignoring update");
            return;
        }
        
        // Count data points (use toco array length as reference)
        int dataPoints = update.data.toco != null ? update.data.toco.size() : 0;
        
        // Update buffer size (add new points)
        int currentBuffer = bufferSize.addAndGet(dataPoints);
        logger.debug("BufferManagementService: Received {} points, buffer now at {}", dataPoints, currentBuffer);
        
        // Check if we need to request more data
        checkAndRequestMoreData();
    }
    
    /**
     * Consume data points from buffer (called when data is sent to RabbitMQ)
     */
    public void consumeDataPoints(int count) {
        if (!isRunning.get()) {
            return;
        }
        
        int newSize = bufferSize.addAndGet(-count);
        logger.debug("BufferManagementService: Consumed {} points, buffer now at {}", count, Math.max(0, newSize));
        
        // Ensure buffer doesn't go negative
        if (newSize < 0) {
            bufferSize.set(0);
        }
        
        // Check if we need to request more data
        checkAndRequestMoreData();
    }
    
    /**
     * Check buffer level and request more data if needed
     */
    private void checkAndRequestMoreData() {
        if (!isRunning.get()) {
            return;
        }
        
        int currentBuffer = bufferSize.get();
        
        // If buffer is low and no request is already in progress
        if (currentBuffer < BUFFER_LOW_THRESHOLD && !requestInProgress.getAndSet(true)) {
            logger.info("BufferManagementService: Buffer low ({} < {}), requesting {} more points", 
                currentBuffer, BUFFER_LOW_THRESHOLD, REQUEST_BATCH_SIZE);
            
            requestMoreData();
        }
    }
    
    /**
     * Send continue request to MATLAB for more data
     */
    private void requestMoreData() {
        if (lastParameters == null) {
            logger.error("BufferManagementService: Cannot request more data - no parameters set");
            requestInProgress.set(false);
            return;
        }
        
        try {
            // Create continue request
            MatlabOperatorEvent continueRequest = new MatlabOperatorEvent();
            continueRequest.type = "continue";
            continueRequest.parameters = new OperatorEventParameters();
            continueRequest.parameters.speed = lastParameters.speed;
            continueRequest.parameters.duration_in_timesteps = REQUEST_BATCH_SIZE;
            continueRequest.parameters.CTG_type = lastParameters.CTG_type;
            continueRequest.parameters.intensity = lastParameters.intensity;
            
            boolean success = matlabConnection.sendMessage(continueRequest);
            
            if (success) {
                logger.info("BufferManagementService: Continue request sent successfully for {} points", REQUEST_BATCH_SIZE);
            } else {
                logger.error("BufferManagementService: Failed to send continue request");
            }
            
        } catch (Exception e) {
            logger.error("BufferManagementService: Error sending continue request", e);
        } finally {
            // Reset request flag after a short delay to allow MATLAB to respond
            requestInProgress.set(false);
        }
    }
    
    /**
     * Get current buffer size
     */
    public int getBufferSize() {
        return bufferSize.get();
    }
    
    /**
     * Check if buffer management is running
     */
    public boolean isRunning() {
        return isRunning.get();
    }
}

