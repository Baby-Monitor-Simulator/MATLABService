package com.babymonitoring.simulationplayer.controllers;

import com.babymonitoring.simulationplayer.Simulation;
import com.babymonitoring.simulationplayer.models.messages.CoordsMessage;
import com.babymonitoring.simulationplayer.models.messages.Message;
import com.babymonitoring.simulationplayer.models.messages.TextMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

import java.util.concurrent.ExecutionException;

@Controller
public class MessageController {

    private SimpMessagingTemplate template;
    @Autowired
    public MessageController(SimpMessagingTemplate template) {
        this.template = template;
    }

    @MessageMapping("/simulation")
    public void lobby(Message message) throws Exception {
        Thread newThread = new Thread(() -> {
            try {
                //----- For sine script -----
//                int t               = 10;
//                int steps           = 1000;
//                double a            = 5;
//                double f            = 0.5;
//                double ts           = 0;
//                double tsp          = 0.01;
//                double te           = 10;
//                new Simulation(this).startSimulation(t, steps, a, f, ts, tsp, te, message.getUserId());
                //---------------------------

                //----- For production script -----
                boolean mother      = true;
                boolean uterus      = true;
                boolean foetus      = true;
                int umbilical       = 2;
                boolean brain       = true;
                int CAVmodel        = 2;
                int scen            = 2;
                boolean HES         = false;
                boolean persen      = false;
                boolean duty        = false;
                int ncyclemax       = 300;
                boolean lamb        = false;
                new Simulation(this).startProductionSimulation(mother, uterus, foetus, umbilical, brain, CAVmodel, scen, HES, persen, duty, ncyclemax, lamb, message.getUserId());
                //---------------------------------

            } catch (ExecutionException e) {
                throw new RuntimeException(e);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        });
        newThread.start();
        SendText(new TextMessage(message.getUserId(),"Hello, " + HtmlUtils.htmlEscape(message.getUserId().toString()) + "!"));
    }

    public void SendText(TextMessage message) {
        this.template.convertAndSend("/lobby/" + message.getUserId(), message);
    }

    public void SendCoords(CoordsMessage message) {
        this.template.convertAndSend("/lobby/" + message.getUserId(), message);
    }

}