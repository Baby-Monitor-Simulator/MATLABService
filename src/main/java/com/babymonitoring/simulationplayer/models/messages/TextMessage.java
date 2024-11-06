package com.babymonitoring.simulationplayer.models.messages;

import jdk.jfr.Description;

import java.util.UUID;

/**
 * Class for a string message to a UUID user
 */
public class TextMessage extends Message {
    String Msg;

    public TextMessage (String msg) {
        Msg = msg;
    }

    public TextMessage (UUID userId, String msg) {
        UserId = userId;
        Msg = msg;
    }

    public void setMessage(String msg) {
        Msg = msg;
    }

    public String getMessage() {
        return Msg;
    }
}
