package com.privo.creditsaison;

import android.util.Log;


import androidx.annotation.NonNull;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.salesforce.marketingcloud.messages.push.PushMessageManager;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk;
import com.salesforce.marketingcloud.sfmcsdk.modules.ModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleReadyListener;
import com.webengage.sdk.android.WebEngage;

import java.util.Map;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

    private static final String TAG = "MyFirebaseMessagingServ";

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        Log.d("Firebase", "Message received");
        Map<String, String> data = remoteMessage.getData();

        if (PushMessageManager.isMarketingCloudPush(remoteMessage)) {
            SFMCSdk.requestSdk(sfmcSdk -> sfmcSdk.mp(new PushModuleReadyListener() {
                @Override
                public void ready(@NonNull PushModuleInterface pushModuleInterface) {
                    pushModuleInterface.getPushMessageManager().handleMessage(remoteMessage);
                }

                @Override
                public void ready(@NonNull ModuleInterface moduleInterface) {

                }
            }));
        }
        if (data.containsKey("source") && "webengage".equals(data.get("source"))) {
            WebEngage.get().receive(data);
            WebEngage.get().getWebEngageConfig().getDebugMode();

        }
    }

    @Override
    public void onNewToken(@NonNull String token) {
        super.onNewToken(token);
        try {
            SFMCSdk.requestSdk(sfmcSdk -> sfmcSdk.mp(new PushModuleReadyListener() {
                @Override
                public void ready(@NonNull PushModuleInterface pushModuleInterface) {
                    pushModuleInterface.getPushMessageManager().setPushToken(token);
                }

                @Override
                public void ready(@NonNull ModuleInterface moduleInterface) {

                }
            }));
        } catch (Exception e) {
            Log.d(TAG, "onNewToken: issue in setting up token on salesforce SDK " + e.getMessage());
        }
        WebEngage.get().setRegistrationID(token);
    }
}
