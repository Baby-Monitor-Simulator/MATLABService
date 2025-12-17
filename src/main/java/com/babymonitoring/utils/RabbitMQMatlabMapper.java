package com.babymonitoring.utils;

import com.babymonitoring.dto.Matlab.operatorEvent.MatlabOperatorEvent;
import com.babymonitoring.dto.Matlab.operatorEvent.OperatorEventParameters;
import com.babymonitoring.dto.Matlab.simulationUpdate.MatlabSimulationUpdate;
import com.babymonitoring.dto.Matlab.simulationUpdate.SimulationUpdateData;
import com.babymonitoring.dto.RabbitMQ.operatorEvent.OperatorEvent;
import com.babymonitoring.dto.RabbitMQ.operatorEvent.Parameters;
import com.babymonitoring.dto.RabbitMQ.simulationUpdate.SimulationUpdate;
import com.babymonitoring.dto.RabbitMQ.simulationUpdate.MaternalData;

import java.util.stream.Collectors;

public class RabbitMQMatlabMapper {
    
    // ============== OperatorEvent Mappings ==============
    
    public static OperatorEvent toRabbitMQ(MatlabOperatorEvent matlab) {
        OperatorEvent rabbitmq = new OperatorEvent();
        rabbitmq.payload.action = matlab.type; // "start" or "continue"
        rabbitmq.payload.timestampInTimesteps = 0; // You may need to set this appropriately
        
        rabbitmq.payload.parameters = new Parameters();
        rabbitmq.payload.parameters.eventType = matlab.parameters.CTG_type;
        rabbitmq.payload.parameters.intensity = matlab.parameters.intensity;
        rabbitmq.payload.parameters.durationMs = matlab.parameters.duration_in_timesteps / 4; // May need conversion
        
        return rabbitmq;
    }
    
    public static MatlabOperatorEvent toMatlab(OperatorEvent rabbitmq) {
        MatlabOperatorEvent matlab = new MatlabOperatorEvent();
        matlab.type = rabbitmq.payload.action; // "start" or "continue"
        
        matlab.parameters = new OperatorEventParameters();
        matlab.parameters.CTG_type = rabbitmq.payload.parameters.eventType;
        matlab.parameters.intensity = (int) rabbitmq.payload.parameters.intensity;
        matlab.parameters.duration_in_timesteps = (int) rabbitmq.payload.parameters.durationMs; // May need conversion
        matlab.parameters.speed = 1; // Default value, you may need to set this appropriately
        
        return matlab;
    }
    
    // ============== SimulationUpdate Mappings ==============
    
    public static SimulationUpdate toRabbitMQ(MatlabSimulationUpdate matlab) {
        SimulationUpdate rabbitmq = new SimulationUpdate();
        
        rabbitmq.payload.timesteps = matlab.timesteps;
        rabbitmq.payload.fetusCount = matlab.activeFetusCount;
        rabbitmq.payload.totalTimesteps = 0; // You may need to track this separately
        
        // Map maternal data (convert Double to Integer)
        rabbitmq.payload.maternalData = new MaternalData();
        rabbitmq.payload.maternalData.toco = matlab.data.toco.stream()
            .map(Double::intValue)
            .collect(Collectors.toList());
        rabbitmq.payload.maternalData.maternalOxygenSaturation = matlab.data.maternal_oxygen_saturation.stream()
            .map(Double::intValue)
            .collect(Collectors.toList());
        
        // Map fetal data (convert List<List<Double>> to List<List<Integer>>)
        rabbitmq.payload.fetusData = matlab.data.fetalheartrate.stream()
            .map(innerList -> innerList.stream()
                .map(Double::intValue)
                .collect(Collectors.toList()))
            .collect(Collectors.toList());
        
        return rabbitmq;
    }
    
    public static MatlabSimulationUpdate toMatlab(SimulationUpdate rabbitmq) {
        MatlabSimulationUpdate matlab = new MatlabSimulationUpdate();
        
        matlab.timesteps = rabbitmq.payload.timesteps;
        matlab.activeFetusCount = rabbitmq.payload.fetusCount;
        
        // Map maternal data (convert Integer to Double)
        matlab.data = new SimulationUpdateData();
        matlab.data.toco = rabbitmq.payload.maternalData.toco.stream()
            .map(Integer::doubleValue)
            .collect(Collectors.toList());
        matlab.data.maternal_oxygen_saturation = rabbitmq.payload.maternalData.maternalOxygenSaturation.stream()
            .map(Integer::doubleValue)
            .collect(Collectors.toList());
        
        // Map fetal data (convert List<List<Integer>> to List<List<Double>>)
        matlab.data.fetalheartrate = rabbitmq.payload.fetusData.stream()
            .map(innerList -> innerList.stream()
                .map(Integer::doubleValue)
                .collect(Collectors.toList()))
            .collect(Collectors.toList());
        
        return matlab;
    }
}

