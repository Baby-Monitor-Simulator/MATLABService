package com.babymonitoring.simulationplayer.service;

import com.babymonitoring.simulationplayer.config.RabbitMQConfig;
import com.babymonitoring.simulationplayer.models.events.SimulationUpdate;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class RabbitMQSenderService {

    private final RabbitTemplate rabbitTemplate;

    @Autowired
    public RabbitMQSenderService(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void sendSimulationUpdate(SimulationUpdate update) {
        String routingKey = "matlab.simulationUpdated"; // Define the routing key for this event
        System.out.println("Sending simulation update: " + update.getStatus() + " with routing key: " + routingKey);

        // Send the message to the topic exchange with the routing key
        rabbitTemplate.convertAndSend(RabbitMQConfig.TOPIC_EXCHANGE_NAME, routingKey, update);
    }

}
