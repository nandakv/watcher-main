package com.privo.creditsaison.upi_intent_service;

import android.content.Intent;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class UPIIntentService implements EventChannel.StreamHandler {

    private static final String TAG = "UPIIntent";

    // To store the event sink whenever flutter starts listenting
    EventChannel.EventSink events;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d(TAG, "Got into onlisten " + events.toString());
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d(TAG, "onCancel: Cancelled");
    }


    // Based on the response we get from intent, we are processing and sending back to flutter side
    public void updateStatus(int resultCode, Intent data) {
        Map<String, Object> resultMap = new HashMap<>();
        String intentResponse = "";

        resultMap.put("resultCode", resultCode);

        if (data == null) {
            intentResponse = "user_cancelled";
        } else {
            try {
                String responseString = data.getStringExtra("response");
                intentResponse = responseString == null ? "no_response_received" : responseString;
            } catch (Exception e) {
                intentResponse = "no_response_received";
            }
        }

        resultMap.put("response", intentResponse);

        if (events != null) {
            events.success(resultMap);
            events.endOfStream();
        } else {
            Log.d(TAG, "Event is null");
        }
    }
}