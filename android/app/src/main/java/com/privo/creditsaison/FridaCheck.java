package com.privo.creditsaison;

import android.util.Log;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class FridaCheck {
    private static final String TAG = "FridaDetection";

    public static boolean isFridaRunning() {
        return isProcessRunning("pidof frida-server") ||
                isProcessRunning("ps -A | grep frida") ||
                isProcessRunning("cmd activity dump | grep frida");
    }

    private static boolean isProcessRunning(String command) {
        try {
            Log.d(TAG, "Command: "+command);
            Process process = Runtime.getRuntime().exec(new String[]{"sh", "-c", command});
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
                Log.d(TAG, "Output line: " + line);
            }

            boolean detected = output.toString().contains("frida");
            Log.i(TAG, "Full Process Output: " + output);
            Log.i(TAG, "Frida detected: " + detected);
            return detected;
        } catch (Exception e) {
            Log.e(TAG, "Error executing command: " + command, e);
            return false;
        }
    }


    /** Check if Frida ports (27042, 27043) are open */
    public static boolean isFridaPortOpen() {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<Boolean> future = executor.submit(() -> {
            int[] fridaPorts = {27042, 27043};
            for (int port : fridaPorts) {
                try (Socket socket = new Socket()) {
                    socket.connect(new InetSocketAddress("127.0.0.1", port), 100);
                    socket.close();
                    Log.w(TAG, "Frida port open: " + port);
                    return true;
                } catch (IOException ignored) {
                }
            }
            return false;
        });

        try {
            return future.get();  // Wait for the result
        } catch (Exception e) {
            Log.e(TAG, "Error checking Frida port", e);
            return false;
        } finally {
            executor.shutdown();
        }
    }

    /** Check for Frida shared libraries */
    public static boolean isFridaLibraryLoaded() {
        String[] fridaLibs = {"libfrida-gadget.so", "gum-js"};
        for (String lib : fridaLibs) {
            if (new File("/system/lib/" + lib).exists() || new File("/system/lib64/" + lib).exists()) {
                Log.w(TAG, "Frida library detected: " + lib);
                return true;
            }
        }
        return false;
    }


    /** Run all Frida detection checks */
    public static Map<String, Object> isFridaDetected() {
        Map<String, Object> responseHashMap = new HashMap<>();
        try {
            boolean fridaRunning = isFridaRunning();
            boolean fridaPortOpen = isFridaPortOpen();
            boolean fridaLibraryLoaded = isFridaLibraryLoaded();

            Log.d(TAG, "Frida Detection Results:");
            Log.d(TAG, "Frida Process Running: " + fridaRunning);
            Log.d(TAG, "Frida Port Open: " + fridaPortOpen);
            Log.d(TAG, "Frida Library Loaded: " + fridaLibraryLoaded);

            String logMessage = "Process:"+fridaRunning+",Port:"+fridaPortOpen+",Lib:"+fridaLibraryLoaded;

            boolean isDetected= fridaRunning || fridaPortOpen || fridaLibraryLoaded;
            responseHashMap.put("isError",false);
            responseHashMap.put("isDetected",isDetected);
            responseHashMap.put("logMessage",logMessage);
            return responseHashMap;
        }
        catch (Exception e){
            responseHashMap.put("isError",true);
            responseHashMap.put("isDetected",false);
            responseHashMap.put("errorMessage",e.getMessage());
            return responseHashMap;
        }
    }
}
