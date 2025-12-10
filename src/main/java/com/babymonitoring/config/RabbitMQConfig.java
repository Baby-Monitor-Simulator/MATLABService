package com.babymonitoring.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class RabbitMQConfig {

    public static final String TOPIC_EXCHANGE_NAME = "matlab-exchange";
    public static final String MATLAB_QUEUE = "MatlabService";


    @Bean
    public Declarables rabbitMQDeclarables() {
        TopicExchange topicExchange = new TopicExchange(TOPIC_EXCHANGE_NAME);     
        Queue matlabQueue = new Queue(MATLAB_QUEUE, false);
        
        return new Declarables(
            matlabQueue,
            topicExchange,
            BindingBuilder.bind(matlabQueue).to(topicExchange).with("matlab.*")
        );
    }

    /*
    @Bean
    public Jackson2JsonMessageConverter messageConverter() {

        return new Jackson2JsonMessageConverter();
    }
*/
    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        //rabbitTemplate.setMessageConverter(messageConverter());
        return rabbitTemplate;
    }
}
