package com.babymonitoring.simulationplayer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration;

@SpringBootApplication
public class SimulationplayerApplication {

	public static void main(String[] args) {
		SpringApplication.run(SimulationplayerApplication.class, args);
	}

}

