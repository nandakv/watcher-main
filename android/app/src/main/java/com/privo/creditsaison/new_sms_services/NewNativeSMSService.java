package com.privo.creditsaison.new_sms_services;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.util.Log;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.EventChannel;

public class NewNativeSMSService implements SMSThreadInterface {
    private static final String TAG = "NativeSMSService";

    final NativeSMSInterface nativeSMSInterface;

    public NewNativeSMSService(NativeSMSInterface nativeSMSInterface) {
        this.nativeSMSInterface = nativeSMSInterface;
    }

    private boolean isError = false;
    private String errorMessage = "";

    public HashMap<String, Object> startSMSThread(Cursor cursor, String fromDateTime) {

        new SMSThread(this).startSMSThreading(cursor, fromDateTime);

        HashMap<String, Object> startHashMap = new HashMap<>();
        startHashMap.put("isError", isError);
        startHashMap.put("errorMessage", errorMessage);
        return startHashMap;
    }

    @Override
    public void onBackgroundTaskCompleted(HashMap<String, Object> valueHashMap) {

        if ((boolean) valueHashMap.get("isError")) {
            onSmsThreadError((String) valueHashMap.get("errorMessage"));
        } else {
            List<HashMap<String, String>> list = (List<HashMap<String, String>>) valueHashMap.get("smsList");
            Log.d(TAG, "onPostExecute: sms list length = " + list.size());
            nativeSMSInterface.sendSuccessBroadcast(INTENT_ACTION_SMS_THREAD_COMPLETED, list);
        }
    }

    private void onSmsThreadError(String message) {
        isError = true;
        errorMessage = message == null ? "" : message;
        nativeSMSInterface.sendFailureBroadcast(INTENT_ACTION_SMS_THREAD_COMPLETED);
    }

    public class SMSStreamHandler implements EventChannel.StreamHandler {
        private BroadcastReceiver smsThreadStatusReceiver;

        @Override
        public void onListen(Object arguments, EventChannel.EventSink events) {
            Log.d(TAG, "onListen: events = " + events.toString());
            smsThreadStatusReceiver = initReceiver(events);
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(INTENT_ACTION_SMS_THREAD_COMPLETED);

            nativeSMSInterface.registerBroadcastReceiver(smsThreadStatusReceiver, intentFilter);
        }

        private BroadcastReceiver initReceiver(EventChannel.EventSink events) {
            return new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    Log.d(TAG, "onReceive: action = " + intent.getAction());
                    if (intent.hasExtra("isError") && intent.hasExtra("errorMessage")) {
                        isError = intent.getBooleanExtra("isError", false);
                        errorMessage = intent.getStringExtra("errorMessage");
                    }
                    try {
                        events.success(computeReturnMap(isError, errorMessage));
                    } catch (Exception e) {
                        Log.e(TAG, "onReceive: execption", e);
                        events.success(computeReturnMap(true, e.getMessage()));
                    }
                }
            };
        }

        @Override
        public void onCancel(Object arguments) {
            Log.d(TAG, "onCancel: receiver cancelled");
            nativeSMSInterface.unRegisterBroadcastReceiver(smsThreadStatusReceiver);
            smsThreadStatusReceiver = null;
        }

//        private void splitSMSListAndSendData(EventChannel.EventSink events) {
//            try {
//
//                List<HashMap<String, String>> tempSMSList = new ArrayList<>();
//                int remainingItems = smsList.size();
//
//                int totalNumberOfPages = (smsList.size() / 5000) + (smsList.size() % 5000 == 0 ? 0 : 1);
//
//                Log.d(TAG, "onBackgroundTaskCompleted: totalNumberOfPages = " + totalNumberOfPages);
//
//                for (int i = 0; i < totalNumberOfPages; i++) {
//                    int currentRow = i * 5000;
//                    int lastRow;
//                    if (remainingItems < 5000) {
//                        lastRow = smsList.size();
//                    } else {
//                        lastRow = currentRow + 5000;
//                    }
//
//                    Log.d(TAG, "onBackgroundTaskCompleted: currentRow = " + currentRow);
//                    Log.d(TAG, "onBackgroundTaskCompleted: lastRow = " + lastRow);
//
//                    tempSMSList = smsList.subList(currentRow, lastRow);
//
//                    remainingItems = remainingItems - lastRow;
//
//                    Log.d(TAG, "onBackgroundTaskCompleted: sms list size = " + tempSMSList.size());
//
//                    events.success(computeReturnMap(isError, errorMessage, true));
//                }
//
//                events.success(computeReturnMap( isError, errorMessage, false));
//
//            } catch (Exception e) {
//                isError = true;
//                errorMessage = e.getMessage();
//                onSmsThreadError(errorMessage);
//            }
//        }

    }

    private static HashMap<String, Object> computeReturnMap(boolean isError, String errorMessage) {
        HashMap<String, Object> returnMap = new HashMap<>();
        returnMap.put("isError", isError);
        returnMap.put("errorMessage", errorMessage == null ? "" : errorMessage);
        return returnMap;
    }

}