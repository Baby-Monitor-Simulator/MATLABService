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
import java.nio.charset.StandardCharsets;

/**
 * RabbitMQ message listener for commands from test-exchange.
 * Delegates all business logic to SimulationService.
 */
@Service
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class MessagingListener {
    
    private static final Logger logger = LoggerFactory.getLogger(MessagingListener.class);
    private final SimulationService simulationService;
    
    @Autowired
    public MessagingListener(SimulationService simulationService) {
        this.simulationService = simulationService;
    }
    
    /**
     * Listen for command messages from matlab-exchange
     * Delegates message processing to SimulationService
     */
    @RabbitListener(queues = RabbitMQConfig.MATLAB_QUEUE)
    public void handleCommandMessage(Message message) {
        try {
            String routingKey = message.getMessageProperties().getReceivedRoutingKey();
            String messageJson = new String(message.getBody(), StandardCharsets.UTF_8);
            
            logger.info("MessagingListener: Received message with routing key: {}", routingKey);
            simulationService.handleIncomingMessage(messageJson);
        } catch (Exception e) {
            logger.error("MessagingListener: Failed to process message", e);
            // Don't rethrow - message gets acknowledged
        }
    }
}

