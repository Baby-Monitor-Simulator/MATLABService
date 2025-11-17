package com.babymonitoring.simulationplayer.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.net.Socket;
import java.net.InetSocketAddress;

/**
 * Tests MATLAB socket connection on application startup.
 * Remove @Component annotation to disable.
 */
@Component
public class MatlabConnectionTester implements CommandLineRunner {

    @Override
    public void run(String... args) {
        testMatlabSocketConnection();
    }

    private void testMatlabSocketConnection() {
        System.out.println("Testing MATLAB socket connection...");
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress("matlab-script", 12345), 5000);
            System.out.println("✓ MATLAB socket connected successfully on port 12345!");
            socket.close();
        } catch (Exception e) {
            System.err.println("✗ Failed to connect to MATLAB socket: " + e.getMessage());
            System.err.println("  Make sure the 'matlab-script' container is running");
        }
    }
}

