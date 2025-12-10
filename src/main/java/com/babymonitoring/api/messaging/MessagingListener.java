package com.babymonitoring.api.messaging;

import com.babymonitoring.config.RabbitMQConfig;
import com.babymonitoring.service.SimulationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.babymonitoring.dto.operatorEvent.OperatorEvent;
import com.babymonitoring.dto.simulationUpdate.SimulationUpdate;
import java.nio.charset.StandardCharsets;

/**
 * RabbitMQ message listener for commands from test-exchange.
 * Delegates all business logic to SimulationService.
 */
@Service
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class MessagingListener {
    
    private static final Logger logger = LoggerFactory.getLogger(MessagingListener.class);
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    private final SimulationService simulationService;
    
    @Autowired
    public MessagingListener(SimulationService simulationService) {
        this.simulationService = simulationService;
    }
    
    /**
     * Listen for command messages from test-exchange
     * Routing key: command
     */
    @RabbitListener(queues = RabbitMQConfig.MATLAB_QUEUE)
    public void handleCommandMessage(Message message) {
        try {
            String routingKey = message.getMessageProperties().getReceivedRoutingKey();
            String messageJson = new String(message.getBody(), StandardCharsets.UTF_8);
            
            logger.info("MessagingListener: Received message with routing key: {}", routingKey);
            this.sendToService(messageJson);
        } catch (Exception e) {
            logger.error("MessagingListener: Failed to process message", e);
            // Don't rethrow - message gets acknowledged
        }
    }

    /**
     * Decode message and send to appropriate method
     * @param message The command message
     */
    public void sendToService(String message) {
        try {
            logger.info("SimulationService: Handling command message: {}", message);
            OperatorEvent commandMessage = objectMapper.readValue(message, OperatorEvent.class); 
            switch (commandMessage.getPayload().getAction()) {
                case "start":
                    simulationService.startSimulation();
                    break;
                case "stop":
                    simulationService.stopSimulation();
                    break;
                case "operator.event":
                    simulationService.processOperatorEvent(null, 0, 0);
                    break;
                default:
                    logger.error("SimulationService: Unknown command type: {}", commandMessage.getType());
                    break;
            }
            
        } catch (Exception e) {
            logger.error("Incoming json structure does not match expected structure from DTO: {}", e.getMessage());
        }
    }
}

