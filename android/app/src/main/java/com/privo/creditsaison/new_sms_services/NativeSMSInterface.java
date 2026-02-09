package com.privo.creditsaison.new_sms_services;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;

import java.util.HashMap;
import java.util.List;

public interface NativeSMSInterface {

    void sendFailureBroadcast(String intentAction);

    void sendSuccessBroadcast(String intentAction, List<HashMap<String, String>> smsList);

    void registerBroadcastReceiver(BroadcastReceiver broadcastReceiver, IntentFilter intentFilter);

    void unRegisterBroadcastReceiver(BroadcastReceiver broadcastReceiver);

}