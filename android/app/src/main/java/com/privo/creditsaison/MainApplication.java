package com.privo.creditsaison;

import static android.util.Log.VERBOSE;

import android.app.PendingIntent;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.webkit.WebView;


import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessaging;
import com.salesforce.marketingcloud.cdp.CdpConfig;
import com.salesforce.marketingcloud.cdp.CdpSdk;
import com.salesforce.marketingcloud.cdp.consent.Consent;
import com.salesforce.marketingcloud.sfmcsdk.components.identity.Identity;
import com.salesforce.marketingcloud.sfmcsdk.components.identity.ModuleIdentity;
import com.salesforce.marketingcloud.sfmcsdk.modules.ModuleIdentifier;
import com.salesforce.marketingcloud.sfmcsdk.modules.ModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.cdp.CdpModuleConfig;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleReadyListener;
import com.webengage.sdk.android.AbstractWebEngage;
import com.salesforce.marketingcloud.MCLogListener;
import com.salesforce.marketingcloud.MarketingCloudConfig;
import com.salesforce.marketingcloud.MarketingCloudSdk;
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions;
import com.salesforce.marketingcloud.notifications.NotificationManager;
import com.salesforce.marketingcloud.notifications.NotificationMessage;
import com.salesforce.marketingcloud.sfmcsdk.BuildConfig;
import com.salesforce.marketingcloud.sfmcsdk.InitializationStatus;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkReadyListener;
import com.salesforce.marketingcloud.sfmcsdk.components.logging.LogLevel;
import com.salesforce.marketingcloud.sfmcsdk.components.logging.LogListener;
import com.webengage.sdk.android.LocationTrackingStrategy;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.security.SecureRandom;
import java.util.Map;
import java.util.Objects;

import io.flutter.app.FlutterApplication;
import kotlin.Unit;

public class MainApplication extends FlutterApplication {


    String prodKey = "in~11b5642c7";
    String debugKey = "in~76aa303";

    private static final String TAG = "MainApplication";


    @Override
    public void onCreate() {
        super.onCreate();

        String processName = "";

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            processName = getProcessName();
            if (!Objects.equals(getPackageName(), processName))
                WebView.setDataDirectorySuffix(processName);
        } else {
            processName = getApplicationProcessName();
        }

        if (!processName.contains("DigioActivity")) {

            Log.d(TAG, "onCreate: not DigioActivity");

            configureSFMCSDK();
            updatePushNotificationToken();

            Log.d("webengage", "MainApplicationstarts");

            WebEngageConfig webEngageConfig = new WebEngageConfig.Builder()
                    .setWebEngageKey(isProd() ? prodKey : debugKey)
                    .setAutoGCMRegistrationFlag(false)
                    .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                    .setDebugMode(BuildConfig.DEBUG) // only in development mode
                    .setPushSmallIcon(R.drawable.ic_privo_launcher)
                    .build();
            registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(this, webEngageConfig));
        }
    }

    private void configureSFMCSDK() {
        Log.d(TAG, "onCreate: logs for salesforce. is debug = " + BuildConfig.DEBUG);

        if (BuildConfig.DEBUG) {

            Log.d(TAG, "onCreate: salesforce logs started");

            // Enable Logging _BEFORE_ calling the SDK's configure/init method
            SFMCSdk.setLogging(LogLevel.DEBUG, new LogListener.AndroidLogger());
            MarketingCloudSdk.setLogLevel(VERBOSE);
            MarketingCloudSdk.setLogListener(new MCLogListener.AndroidLogListener());

// When the SDK is ready, output its state to the logs
            SFMCSdk.requestSdk(sdk -> {
                Log.d(TAG, "onCreate: salesforce logs started " + sdk.toString());
                try {
                    // Specifically get the push state information
                    JSONObject pushState = (JSONObject) sdk.getSdkState().get("PUSH");

                    // General Troubleshooting
                    Log.i("~#SdkState", "initConfig: " + pushState.get("initConfig"));
                    Log.i("~#SdkState", "initStatus: " + pushState.get("initStatus"));
                    Log.i("~#SdkState", "PushMessageManager: " + ((JSONObject) pushState.get("PushMessageManager")).toString(2));
                    Log.i("~#SdkState", "RegistrationManager: " + ((JSONObject) pushState.get("RegistrationManager")).toString(2));

                    // Troubleshoot InApp Messages
                    Log.i("~#SdkState", "InAppMessageManager: " + ((JSONObject) pushState.get("InAppMessageManager")).toString(2));
                    Log.i("~#SdkState", "InApp Messages: " + ((JSONArray) ((JSONObject) pushState.get("InAppMessageManager")).get("messages")).toString(2));

                    // Get Everything
                    Log.i("~#SdkState", "InApp Events: " + ((JSONObject) pushState.get("Event")).toString(2));
                } catch (JSONException e) {
                    Log.e("~#SdkState", "Error parsing SDK state", e);
                }
            });
        }

        ///salesforce SDK
        SFMCSdk.configure(getApplicationContext(), SFMCSdkModuleConfig.build(config -> {
            config.setPushModuleConfig(getMarketingCouldConfig());
            config.setCdpModuleConfig(getCdpModuleConfig());
            return Unit.INSTANCE;
        }), initStatus -> {
            switch (initStatus.getStatus()) {
                case InitializationStatus.SUCCESS:
                    Log.d(TAG, "SFMC SDK Initialization Successful");
                    CdpSdk.requestSdk(cdpSdk -> cdpSdk.setConsent(Consent.OPT_IN));
                    break;
                case InitializationStatus.FAILURE:
                    Log.d(TAG, "SFMC SDK Initialization Failed");
                    break;
                default:
                    Log.d(TAG, "SFMC SDK Initialization Status: Unknown");
                    break;
            }
            return Unit.INSTANCE;
        });
    }

    private void updatePushNotificationToken() {
        FirebaseMessaging.getInstance().getToken().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                String token = task.getResult();
                try {
                    Log.d(TAG, "onCreate: token = " + token);
                    SFMCSdk.requestSdk(sfmcSdk -> {
                        sfmcSdk.mp(new PushModuleReadyListener() {
                            @Override
                            public void ready(@NonNull PushModuleInterface pushModuleInterface) {
                                Log.d(TAG, "ready: push module");
                                pushModuleInterface.getPushMessageManager().setPushToken(task.getResult());
                                Log.d(TAG, "ready: sfmc token set");
                            }

                            @Override
                            public void ready(@NonNull ModuleInterface moduleInterface) {

                            }
                        });
                    });
                } catch (Exception e) {
                    Log.e(TAG, "onCreate: SFMC token set error", e);
                }
                WebEngage.get().setRegistrationID(token);

            }
        });
    }

    private String getApplicationProcessName() {
        int myPiD = Process.myPid();
        ActivityManager activityManager = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo runningAppProcess : activityManager.getRunningAppProcesses()) {
            if (runningAppProcess.pid == myPiD) {
                return runningAppProcess.processName;
            }
        }
        return "";
    }

    boolean isProd() {
        return getPackageName().equals("com.privo.creditsaison");
    }

    private MarketingCloudConfig getMarketingCouldConfig() {
        SFMCConfigs sfmcConfigs = new SFMCConfigs(isProd()).getConfigs();
        return MarketingCloudConfig.builder()
                .setApplicationId(sfmcConfigs.appId)
                .setAccessToken(sfmcConfigs.accessToken)
                .setMarketingCloudServerUrl(sfmcConfigs.appEndpointURL)
                .setSenderId(sfmcConfigs.senderId)
                .setMid(sfmcConfigs.mid)
                .setAnalyticsEnabled(true)
                .setDelayRegistrationUntilContactKeyIsSet(false)
                .setNotificationCustomizationOptions(NotificationCustomizationOptions.create(this::setNotification))
//                .setNotificationCustomizationOptions(NotificationCustomizationOptions.create(R.mipmap.launcher_icon))
                .build(getApplicationContext());
    }

    private CdpModuleConfig getCdpModuleConfig() {
        SFMCConfigs sfmcConfigs = new SFMCConfigs(isProd()).getConfigs();
        return new CdpConfig.Builder(getApplicationContext(), sfmcConfigs.dataCloudAppId, sfmcConfigs.dataCloudEndpoint)
                .trackLifecycle(true)
                .trackScreens(true)
                .sessionTimeout(600)
                .build();
    }


    @NonNull
    private NotificationCompat.Builder setNotification(Context context, NotificationMessage notificationMessage) {
        String channelId = NotificationManager.createDefaultNotificationChannel(context);
        return NotificationManager
                .getDefaultNotificationBuilder(context, notificationMessage, channelId, R.drawable.launcher_icon)
                .setContentInfo(NotificationManager
                        .redirectIntentForAnalytics(context, getPendingIntent(context, notificationMessage), notificationMessage, true).toString());
    }

    private PendingIntent getPendingIntent(Context context, NotificationMessage notificationMessage) {
        return PendingIntent.getActivities(context, new SecureRandom().nextInt(), getIntent(context, notificationMessage), provideIntentFlags());
    }

    private Intent[] getIntent(Context context, NotificationMessage notificationMessage) {
        return new Intent[]{notificationMessage != null && Objects.requireNonNull(notificationMessage.url).isEmpty()
                ? context.getPackageManager().getLaunchIntentForPackage(context.getPackageName())
                : new Intent(Intent.ACTION_VIEW, Uri.parse(Objects.requireNonNull(notificationMessage).url))};
    }

    private int provideIntentFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE;
        } else {
            return PendingIntent.FLAG_UPDATE_CURRENT;
        }
    }

    private static class SFMCConfigs {
        String appId;
        String accessToken;
        String appEndpointURL;
        String mid;

        String dataCloudAppId;
        String dataCloudEndpoint;

        String senderId;

        boolean isProd;

        public SFMCConfigs(boolean isProd) {
            this.isProd = isProd;
        }

        private SFMCConfigs(String appId, String accessToken, String appEndpointURL, String mid, String senderId, String dataCloudAppId, String dataCloudEndpoint) {
            this.appId = appId;
            this.accessToken = accessToken;
            this.appEndpointURL = appEndpointURL;
            this.mid = mid;
            this.senderId = senderId;
            this.dataCloudAppId = dataCloudAppId;
            this.dataCloudEndpoint = dataCloudEndpoint;
        }

        public SFMCConfigs getConfigs() {
            return isProd
                    ? new SFMCConfigs(
                    appId = "93889541-33d8-4f05-8c59-4695352bcc1f",
                    accessToken = "4A7CAXSCVAXMCi06dbNyBjQd",
                    appEndpointURL = "https://mczd0zxgv0hpkrzr6jj5w60mrbf4.device.marketingcloudapis.com/",
                    mid = "542000947",
                    senderId = "562483669765",
                    dataCloudAppId = "a23c7c14-bfb8-4b11-9012-156b5a9f36ed",
                    dataCloudEndpoint = "https://h0zd8zt0h1zd9nzzgm3dsmj-mq.c360a.salesforce.com"
            )
                    : new SFMCConfigs(
                    appId = "51f0b8fd-e8e6-4d2c-9644-fa38c60de8e7",
                    accessToken = "1OiCQGgamTvkyVEDiIdRpuPC",
                    appEndpointURL = "https://mczd0zxgv0hpkrzr6jj5w60mrbf4.device.marketingcloudapis.com/",
                    mid = "542000947",
                    senderId = "726639982263",
                    dataCloudAppId = "1e289552-e2e1-4b41-991c-ebf1959ac5a1",
                    dataCloudEndpoint = "https://h0zd8zt0h1zd9nzzgm3dsmj-mq.c360a.salesforce.com"
            );
        }

    }

}
