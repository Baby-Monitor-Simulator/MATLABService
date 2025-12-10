package com.babymonitoring.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.InetSocketAddress;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import com.fasterxml.jackson.databind.ObjectMapper;

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
        
        int maxRetries = 30; // Try for up to 30 seconds
        int retryDelay = 1000; // 1 second between retries
        
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try (Socket socket = new Socket()) {
                SocketAddress address = new InetSocketAddress("matlab-script", 12345);
                socket.connect(address, 5000); // 5 second timeout per attempt
                System.out.println("✓ MATLAB socket connected successfully on port 12345!");
                
                // Send a test message
                ObjectMapper mapper = new ObjectMapper();
                java.util.Map<String, Object> testMessage = new java.util.HashMap<>();
                java.util.Map<String, Object> params = new java.util.HashMap<>();
                params.put("test", "connection_test");
                testMessage.put("type", "update");
                testMessage.put("params", params);
                
                PrintWriter out = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()), true);
                out.println(mapper.writeValueAsString(testMessage));
                System.out.println("✓ Test message sent to MATLAB");
                
                socket.close();
                return; // Success, exit the method
                
            } catch (Exception e) {
                if (attempt < maxRetries) {
                    System.out.println("⏳ MATLAB not ready yet (attempt " + attempt + "/" + maxRetries + "), retrying in " + (retryDelay/1000) + " seconds...");
                    try {
                        Thread.sleep(retryDelay);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        System.err.println("✗ Connection test interrupted");
                        return;
                    }
                } else {
                    System.err.println("✗ Failed to connect to MATLAB socket after " + maxRetries + " attempts: " + e.getMessage());
                }
            }
        }
    }
}

