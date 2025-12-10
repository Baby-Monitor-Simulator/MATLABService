package com.babymonitoring.api.messaging;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

/**
 * RabbitMQ message sender for publishing messages to exchanges.
 */
@Service
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class MessagingSender {
    
    private static final Logger logger = LoggerFactory.getLogger(MessagingSender.class);
    private static final String TEST_EXCHANGE = "test-exchange";
    
    private final RabbitTemplate rabbitTemplate;
    
    @Autowired
    public MessagingSender(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }
    
    /**
     * Send a message to the test-exchange with a specific message type
     * 
     * @param routingKey The routing key / message type
     * @param message The message object to send
     */
    public void sendToTestExchange(String routingKey, Object message) {
        try {
            logger.info("MessagingSender: Sending message of type '{}' to test-exchange", routingKey);
            rabbitTemplate.convertAndSend(TEST_EXCHANGE, routingKey, message);
            logger.debug("MessagingSender: Message sent successfully");
        } catch (Exception e) {
            logger.error("MessagingSender: Failed to send message to test-exchange", e);
            throw e;
        }
    }
}
