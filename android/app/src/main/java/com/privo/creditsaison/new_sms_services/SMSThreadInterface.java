package com.privo.creditsaison.new_sms_services;

import java.util.HashMap;

public interface SMSThreadInterface {

    String INTENT_ACTION_SMS_THREAD_COMPLETED = "com.privo.sms_thread_completed";

    void onBackgroundTaskCompleted(HashMap<String,Object> valueHashmap);
}