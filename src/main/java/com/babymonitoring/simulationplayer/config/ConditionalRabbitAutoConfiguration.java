package com.babymonitoring.simulationplayer.config;

import org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Import;

@Configuration
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
@Import(RabbitAutoConfiguration.class)
public class ConditionalRabbitAutoConfiguration {
    // This class conditionally imports RabbitAutoConfiguration
}
