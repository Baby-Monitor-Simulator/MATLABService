package com.babymonitoring.simulationplayer.service;

import com.babymonitoring.simulationplayer.config.RabbitMQConfig;
import com.babymonitoring.simulationplayer.models.events.ParticipantAction;
import com.babymonitoring.simulationplayer.models.events.SimulationUpdate;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class RabbitMQListenerService {

    private final RabbitMQSenderService rabbitMQSenderService;

    @Autowired
    public RabbitMQListenerService(RabbitMQSenderService rabbitMQSenderService) {
        this.rabbitMQSenderService = rabbitMQSenderService;
    }

    @RabbitListener(
        bindings = @QueueBinding(
            value = @org.springframework.amqp.rabbit.annotation.Queue(value = RabbitMQConfig.LOBBY_QUEUE, durable = "true"),
            exchange = @Exchange(value = RabbitMQConfig.TOPIC_EXCHANGE_NAME, type = "topic"),
            key = "lobby.participantAction" // Matches the routing key sent by the sender
    ))
    public void receiveParticipantAction(ParticipantAction action) {
        System.out.println("Received Participant Action");
        // Process the update as needed
        SimulationUpdate simulationUpdate = new SimulationUpdate(1L, "Updated");
        rabbitMQSenderService.sendSimulationUpdate(simulationUpdate);
    }
}
