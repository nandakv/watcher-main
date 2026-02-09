package com.privo.creditsaison.new_sms_services;

import android.database.Cursor;

import java.util.HashMap;

public class SMSThread {

    private static final String TAG = "SMSAsyncTask";
    private final SMSThreadInterface smsThreadInterface;

    SMSThread(SMSThreadInterface smsThreadInterface) {
        this.smsThreadInterface = smsThreadInterface;
    }

    public void startSMSThreading(Cursor cursor, String fromDateTime) {
        Thread thread = new Thread(() -> {
            SMSCursorClass smsCursorClass = new SMSCursorClass();
            HashMap<String, Object> valueHashMap = smsCursorClass.fetchSMS(cursor, fromDateTime);
            smsThreadInterface.onBackgroundTaskCompleted(valueHashMap);
        });
        thread.start();
    }

}