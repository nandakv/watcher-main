package com.privo.creditsaison;

import android.provider.Settings;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Telephony;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Base64;
import android.util.Log;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.browser.customtabs.CustomTabsIntent;

import com.facebook.FacebookSdk;
//import com.karza.aadhaarsdk.AadharActivity;
import com.google.firebase.messaging.FirebaseMessaging;
import com.privo.creditsaison.custom_tabs.PrivoCustomTabs;
import com.privo.creditsaison.data_cloud.DataCloud;
import com.privo.creditsaison.root_checker.RootChecker;
import com.privo.creditsaison.new_sms_services.NewNativeSMSService;
import com.privo.creditsaison.new_sms_services.NativeSMSInterface;
import com.privo.creditsaison.services.NativeLocationService;
import com.privo.creditsaison.services.NativeSMSService;
import com.privo.creditsaison.upi_intent_service.UPIIntentService;
import com.privo.creditsaison.web_view.EmandateWebViewActivity;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk;
import com.salesforce.marketingcloud.sfmcsdk.modules.ModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleInterface;
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleReadyListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements NativeSMSInterface {

    private static final String TAG = "MainActivity";

    private static final String CHANNEL = "privo";
    private static final String DATA_CLOUD_CHANNEL = "data_cloud";
    private static final String SMS_EVENT_CHANNEL = "sms_event_channel";
    private static final String REVERSE_PENNY_DROP_CHANNEL = "reverse_penny_drop_channel";
    private static final String LOCATION_EVENT_CHANNEL = "location_event_channel";
    private static final int WEBVIEW_REQUEST_CODE = 396;
    private static final int REVERSE_PENNY_DROP_REQUEST_CODE = 123;
    public static final int PERMISSION_REQUEST_CODE = 1;

    private MethodChannel.Result result;

    private int upiAppListLimit = 8;
    private List<String> topUpiAppsList = Arrays.asList(
            "com.google.android.apps.nbu.paisa.user", // gpay
            "com.phonepe.app", // phonepe
            "net.one97.paytm", // paytm
            "in.org.npci.upiapp" // BHIM
    );

    private final Context context = MainActivity.this;
    private final Activity activity = MainActivity.this;

    NativeSMSService nativeSmsService = new NativeSMSService(context);

    UPIIntentService upiIntentService = new UPIIntentService();


    /// raw sms file name from dart
    private String rawSMSFileName = "";

    private boolean enableScreenProtection = false;

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);

        Log.d(TAG, "onWindowFocusChanged: has Focus = " + hasFocus);
        if (enableScreenProtection && !hasFocus) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                    WindowManager.LayoutParams.FLAG_SECURE);
        } else {
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
//         MethodChannel methodChannel = new MethodChannel(binaryMessenger, CHANNEL);
        EventChannel smsEventChannel = new EventChannel(binaryMessenger, SMS_EVENT_CHANNEL);
        EventChannel reversePennyDropChannel = new EventChannel(binaryMessenger, REVERSE_PENNY_DROP_CHANNEL);
        EventChannel locationEventChannel = new EventChannel(binaryMessenger, LOCATION_EVENT_CHANNEL);
        NewNativeSMSService newNativeSMSService = new NewNativeSMSService(this);
        NewNativeSMSService.SMSStreamHandler smsStreamHandler = newNativeSMSService.new SMSStreamHandler();
        LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        NativeLocationService nativeLocationService = new NativeLocationService(context, locationManager);
        locationEventChannel.setStreamHandler(nativeLocationService);
        smsEventChannel.setStreamHandler(smsStreamHandler);
        reversePennyDropChannel.setStreamHandler(upiIntentService);

        setUpDataCloudMethodChannel(binaryMessenger);

        new MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    this.result = result;
                    switch (call.method) {
                        case "e_mandate_web_view":
                            String url = call.argument("url");
                            String callBackUrl = call.argument("callback_url");

                            Intent intent = new Intent(context, EmandateWebViewActivity.class);
                            intent.putExtra("url", url);
                            intent.putExtra("callback_url", callBackUrl);
                            activity.startActivityForResult(intent, WEBVIEW_REQUEST_CODE);
                            break;

                        case "root_checker":
                            try {
                                RootChecker rootChecker = new RootChecker(context);
                                result.success(rootChecker.checkHpBodong());
                            } catch (Exception e) {
                                Log.d(TAG, "configureFlutterEngine: root checker failed = " + e.getMessage());
                                result.success(false);
                            }
                            break;

                        case "security_check":
                            Map<String, Boolean> checklistMap = call.argument("checklist_map");
                            if (checklistMap == null) {
                                checklistMap = new HashMap<>();
                            }
                            result.success(checkSecurityIssue(checklistMap));
                            break;

                        case "facebook_sdk_init": {
                            initFacebookSdk();
                            break;
                        }

                        case "enable_screen_protection": {
                            enableScreenProtection = Boolean.TRUE.equals(call.argument("enable_screen_protection"));
                            break;
                        }

                        case "fetch_sms": {
                            List<HashMap<String, String>> sms = nativeSmsService.getAllSms();
                            result.success(sms);
                            break;
                        }

                        case "new_start_sms_fetch":
                            rawSMSFileName = call.argument("fileName");
                            String fromDateTime = call.argument("from_date_time");
                            if (fromDateTime == null)
                                fromDateTime = "";
                            startSMSFetch(newNativeSMSService, result, fromDateTime);
                            break;

                        case "start_location_fetch":
                            boolean fetchLastKnownLocation = call.argument("fetch_last_known_location");
                            startLocationFetch(result, nativeLocationService, locationManager, fetchLastKnownLocation);
                            break;

                        case "check_if_location_enabled":
                            try {
                                result.success(nativeLocationService.checkIfLocationEnabled());
                            } catch (Exception e) {
                                HashMap<String, Object> errorHashMap = new HashMap<>();
                                errorHashMap.put("isError", true);
                                errorHashMap.put("errorMessage", e.getMessage());
                                result.success(errorHashMap);
                            }
                            break;

                        case "fetch_carrier_details":
                            fetchCarrierDetails(result);
                            break;

                        case "start_reverse_penny_drop":
                            String intentURL = call.argument("intentURL");
                            String packageName = call.argument("packageName");
                            handleIntent(intentURL, packageName);
                            break;

                        case "get_all_upi_apps_list":
                            String intentUrl = call.argument("intentURL");
                            getAllUpiApps(intentUrl);
                            break;

                        case "open_custom_tab":
                            String customTabURL = call.argument("custom_tab_url");
                            openCustomTab(customTabURL, result);
                            break;

                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    private void setUpDataCloudMethodChannel(BinaryMessenger binaryMessenger) {
        new MethodChannel(binaryMessenger, DATA_CLOUD_CHANNEL).setMethodCallHandler(
                ((call, dataCloudResult) -> {
                    this.result = dataCloudResult;
                    DataCloud dataCloud = new DataCloud(call, context);
                    String method = call.method;

                    switch (method) {
                        case "login":
                            result.success(dataCloud.login().getResult());
                            break;
                        case "logout":
                            result.success(dataCloud.logout().getResult());
                            break;
                        case "set_user_attribute":
                            result.success(dataCloud.setUserAttributes().getResult());
                            break;
                        case "track_event":
                            result.success(dataCloud.trackEvents().getResult());
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                })
        );
    }


    private Map<String, Object> checkSecurityIssue(Map<String, Boolean> checkList) {
        HashMap<String, Object> responseHashMap = new HashMap<>();
        String securityDisplayType = "";
        try {
            if (Boolean.TRUE.equals(checkList.get("magisk_check"))) {
                Map<String, Object> magiskCheckRes = MagiskCheck.isMagiskDetected(context);
                if (Boolean.TRUE.equals(magiskCheckRes.get("isDetected"))) {
                    securityDisplayType = "magisk_check";
                }
                responseHashMap.put("magisk_check", magiskCheckRes);
                Log.d(TAG, "Entered True case");
            } else {
                Log.d(TAG, "Entered False case");
            }
            if (Boolean.TRUE.equals(checkList.get("frida_check"))) {
                Map<String, Object> fridaCheckRes = FridaCheck.isFridaDetected();
                if (Boolean.TRUE.equals(fridaCheckRes.get("isDetected"))) {
                    securityDisplayType = "frida_check";
                }
                responseHashMap.put("frida_check", fridaCheckRes);
            }
            if (Boolean.TRUE.equals(checkList.get("debug_check"))) {
                Map<String, Object> debugCheckRes = isUsbDebuggingEnabled();
                if (Boolean.TRUE.equals(debugCheckRes.get("isDetected"))) {
                    securityDisplayType = "debug_check";
                }
                responseHashMap.put("debug_check", debugCheckRes);
            }
            if (Boolean.TRUE.equals(checkList.get("emulator_check"))) {
                Map<String, Object> emulatorCheckRes = EmulatorCheck.isEmulator();
                if (Boolean.TRUE.equals(emulatorCheckRes.get("isDetected"))) {
                    securityDisplayType = "emulator_check";
                }
                responseHashMap.put("emulator_check", emulatorCheckRes);
            }
            responseHashMap.put("security_display_type", securityDisplayType);
            responseHashMap.put("isError", false);
        } catch (Exception e) {
            responseHashMap.put("isError", true);
            responseHashMap.put("errorMessage", e.getMessage());
        }
        return responseHashMap;
    }


    private Map<String, Object> isUsbDebuggingEnabled() {
        HashMap<String, Object> responseHashMap = new HashMap<>();
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                boolean isEnabled = Settings.Global.getInt(getContentResolver(), Settings.Global.ADB_ENABLED, 0) == 1;
                responseHashMap.put("isDetected", isEnabled);
                responseHashMap.put("isError", false);
            } else {
                responseHashMap.put("isDetected", false);
                responseHashMap.put("isError", false);
            }
        } catch (Exception e) {
            responseHashMap.put("isDetected", false);
            responseHashMap.put("isError", true);
            responseHashMap.put("errorMessage", e.getMessage());
        }
        return responseHashMap;
    }

    public void openCustomTab(String url, MethodChannel.Result result) {
        CustomTabsIntent customTabsIntent = new PrivoCustomTabs().getCustomTabIntent();
        try {
            customTabsIntent.launchUrl(activity, Uri.parse(url));
            Log.d(TAG, "onCreate: vkyc completed");
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "onCreate: crash", e);
            result.success(false);
        }
    }

    private void handleIntent(String uriString, String packageName) {
        Intent upiIntent = new Intent(Intent.ACTION_VIEW);
        upiIntent.setPackage(packageName);
        upiIntent.setData(Uri.parse(uriString));
        HashMap<String, Object> responseHashMap = new HashMap<>();
        try {
            activity.startActivityForResult(upiIntent, REVERSE_PENNY_DROP_REQUEST_CODE);
            responseHashMap.put("isError", false);
            responseHashMap.put("errorMessage", "");
        } catch (ActivityNotFoundException e) {
            responseHashMap.put("isError", true);
            responseHashMap.put("errorMessage", "ActivityNotFoundException " + e.getMessage());
        } catch (Exception e) {
            responseHashMap.put("isError", true);
            responseHashMap.put("errorMessage", e.getMessage());
        }
        result.success(responseHashMap);
    }

    private void getAllUpiApps(String uriString) {
        HashMap<String, Object> dataMap = new HashMap<>();
        List<Map<String, Object>> packages = new ArrayList<>();
        Intent intent = new Intent(Intent.ACTION_VIEW);
        String packageName;
        String name;
        Drawable dIcon;
        Bitmap bIcon;
        byte[] icon;

        Uri uri = Uri.parse(uriString);
        intent.setData(uri);
        // TODO: y is it required ?
        if (activity == null) {
            result.error("activity_missing", "No attached activity found!", null);
            return;
        }

        PackageManager pm = activity.getPackageManager();
        List<ResolveInfo> resolveAppsList = pm.queryIntentActivities(intent, 0);

        Map<String, Object> filteredAppsMap = filterUPIApps(resolveAppsList);
        if ((filteredAppsMap.get("isError").equals(true))) {
            result.error("package_get_failed",
                    "Error during filtering of apps, Error: " + filteredAppsMap.get("errorMsg"), null);
            return;
        }
        List<ResolveInfo> filteredAppsList = (List<ResolveInfo>) filteredAppsMap.get("appList");

        for (ResolveInfo appInfo : filteredAppsList) {
            try {
                // Get Package name of the app.
                packageName = appInfo.activityInfo.packageName;

                // Get Actual name of the app to display.
                name = (String) pm
                        .getApplicationLabel(pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA));

                // Get app icon as Drawable
                dIcon = pm.getApplicationIcon(packageName);

                // Convert the Drawable Icon as Bitmap.
                bIcon = getBitmapFromDrawable(dIcon);

                // Convert the Bitmap icon to byte[] received as Uint8List by dart.
                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                bIcon.compress(Bitmap.CompressFormat.PNG, 100, stream);
                icon = stream.toByteArray();

                // Put everything in a map
                Map<String, Object> m = new HashMap<>();
                m.put("packageName", packageName);
                m.put("name", name);
                m.put("icon", icon);

                // Add this app info to the list.
                packages.add(m);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("package_get_failed", "Failed to get list of installed UPI apps", null);
                return;
            }
        }

        dataMap.put("dataList", packages);
        result.success(dataMap);
    }

    private Map<String, Object> filterUPIApps(List<ResolveInfo> installedApps) {
        List<ResolveInfo> filteredApps = new ArrayList<ResolveInfo>();
        Map<String, Object> resMap = new HashMap<>();
        try {
            // Filtering top apps
            for (ResolveInfo app : installedApps) {
                String packageName = app.activityInfo.packageName;
                if (topUpiAppsList.contains(packageName)) {
                    filteredApps.add(app);
                }
            }

            // To remove apps which are already added to filteredApps
            installedApps.removeAll(filteredApps);

            // Adding next apps until limit based on 1st come 1st serve (Not Required)
            // while (filteredApps.size() < upiAppListLimit) {
            // if (installedApps.isEmpty()) {
            // break;
            // }
            // filteredApps.add(installedApps.remove(0));
            // }
            resMap.put("isError", false);
        } catch (Exception e) {
            e.printStackTrace();
            resMap.put("isError", true);
            resMap.put("errorMsg", e.getMessage());
        }
        resMap.put("appList", filteredApps);
        return resMap;
    }

    // It converts the Drawable to Bitmap. There are other inbuilt methods too.
    private Bitmap getBitmapFromDrawable(Drawable drawable) {
        Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(),
                Bitmap.Config.ARGB_8888);
        Log.d("Bitmap", "width: " + drawable.getIntrinsicWidth() + " height: " + drawable.getIntrinsicHeight());
        Canvas canvas = new Canvas(bmp);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bmp;
    }

    private void startLocationFetch(MethodChannel.Result result, NativeLocationService locationService,
                                    LocationManager locationManager, boolean fetchLastKnownLocation) {
        try {
            result.success(locationService.fetchLocation(fetchLastKnownLocation));
        } catch (Exception e) {
            HashMap<String, Object> errorHashMap = new HashMap<>();
            errorHashMap.put("isError", true);
            errorHashMap.put("errorMessage", e.getMessage());
            result.success(errorHashMap);
        }

    }

    @SuppressLint("MissingPermission")
    private void fetchCarrierDetails(MethodChannel.Result result) {
        HashMap<String, String> carrierInfo = new HashMap<>();
        try {
            // above 22
            if (Build.VERSION.SDK_INT > 22) {
                // for dual sim mobile
                SubscriptionManager localSubscriptionManager = SubscriptionManager.from(this);
                if (localSubscriptionManager.getActiveSubscriptionInfoCount() > 1) {
                    // if there are two sims in dual sim mobile
                    final String[] dualSimNames = getDualSimName(localSubscriptionManager);

                    carrierInfo.put("primarySim", dualSimNames[0]);
                    carrierInfo.put("secondarySim", dualSimNames[1]);
                } else {
                    // if there is 1 sim in dual sim mobile
                    carrierInfo.put("primarySim", getPrimarySimName());
                }
            } else {
                // below android version 22
                carrierInfo.put("primarySim", getPrimarySimName());
            }

            result.success(carrierInfo);
        } catch (Exception e) {
            HashMap<String, String> errorHashMap = new HashMap<>();
            errorHashMap.put("isError", "true");
            errorHashMap.put("errorMessage", e.getMessage());
            result.success(errorHashMap);
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    private String[] getDualSimName(SubscriptionManager localSubscriptionManager) {
        @SuppressLint("MissingPermission")
        List localList = localSubscriptionManager.getActiveSubscriptionInfoList();
        SubscriptionInfo primarySimInfo = (SubscriptionInfo) localList.get(0);
        SubscriptionInfo secondarySimInfo = (SubscriptionInfo) localList.get(1);

        final String primarySim = primarySimInfo.getDisplayName().toString();
        final String secondarySim = secondarySimInfo.getDisplayName().toString();

        String[] simDetails = new String[2];
        simDetails[0] = primarySim;
        simDetails[1] = secondarySim;

        return simDetails;
    }

    private String getPrimarySimName() {
        TelephonyManager tManager = (TelephonyManager) getBaseContext()
                .getSystemService(Context.TELEPHONY_SERVICE);

        return tManager.getNetworkOperatorName();
    }

    private void startSMSFetch(NewNativeSMSService newNativeSMSService, MethodChannel.Result result,
                               String fromDateTime) {
        try {
            ContentResolver cr = context.getContentResolver();
            String[] projections = new String[]{"creator", "address", "date_sent", "reply_path_present", "read",
                    "body", "type", "seen", "thread_id", "protocol", "service_center", "status", "_id", "date"};
            Cursor cursor = cr.query(Telephony.Sms.Inbox.CONTENT_URI, projections, null, null, null);
            result.success(newNativeSMSService.startSMSThread(cursor, fromDateTime));
        } catch (Exception e) {
            HashMap<String, Object> errorHashMap = new HashMap<>();
            errorHashMap.put("isError", true);
            errorHashMap.put("errorMessage", e.getMessage());
            result.success(errorHashMap);
        }

    }

    private void initFacebookSdk() {
        FacebookSdk.setAutoInitEnabled(true);
        FacebookSdk.fullyInitialize();
        Log.d(TAG, "Facebook Sdk initialized");
        result.success(true);
    }

    // private void postFacebookAppEvent(String eventName, String eventValue) {
    // AppEventsLogger logger = AppEventsLogger.newLogger(this);
    // Bundle params = new Bundle();
    // params.putString("event_value", eventValue);
    // logger.logEvent(eventName,params);
    // Log.d(TAG, "Facebook app event logged");
    // result.success(true);
    // }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d(TAG, "onActivityResult: requestCode = " + requestCode + " result code = " + resultCode);
        if (data != null) {
            // Log.d(TAG, "onActivityResult: intent data = " + data.getExtras().toString());
            // Log.d(TAG, "onActivityResult: intent data = " + data.getExtras().keySet());
            // for (int i = 0; i < data.getExtras().keySet().size(); i++) {
            // String key = data.getExtras().keySet().toArray()[i].toString();
            // Log.d(TAG, "onActivityResult: key = " +
            // data.getExtras().keySet().toArray()[i]);
            // Log.d(TAG, "onActivityResult: value = " + data.getStringExtra(key));
            // }
            // Log.d(TAG, "onActivityResult: intent data = " +
            // data.getStringExtra("response"));
        }
        if (requestCode == REVERSE_PENNY_DROP_REQUEST_CODE) {
            upiIntentService.updateStatus(resultCode, data);
        }
        if (requestCode == WEBVIEW_REQUEST_CODE) {
            Log.d(TAG, "onActivityResult: emandate resultCode = " + resultCode);
            Log.d(TAG, "onActivityResult: emandate requestCode = " + requestCode);
            result.success(resultCode == Activity.RESULT_OK);
        }
    }

    @Override
    public void sendFailureBroadcast(String intentAction) {
        activity.sendBroadcast(new Intent(intentAction));
    }

    @Override
    public void sendSuccessBroadcast(String intentAction, List<HashMap<String, String>> smsList) {
        // FileOutputStream fileOutputStream;
        boolean isError = false;
        String errorMessage = "";

        try (FileWriter fileWriter = new FileWriter(context.getFilesDir().getAbsolutePath() + "/" + rawSMSFileName)) {
            Log.d(TAG, "filePath: " + context.getFilesDir().getAbsolutePath() + "/" + rawSMSFileName);
            JSONArray jsonArray = new JSONArray(smsList);
            String encodedSMSString = Base64.encodeToString(jsonArray.toString().getBytes("UTF-8"), Base64.DEFAULT);
            fileWriter.write(encodedSMSString);
            Log.d(TAG, "sendIntentBroadcast: file stored");
        } catch (IOException e) {
            Log.e(TAG, "sendIntentBroadcast: io exception", e);
            isError = true;
            errorMessage = e.getMessage();
        }

        // try {
        //
        // fileOutputStream = context.openFileOutput(rawSMSFileName + ".txt",
        // Context.MODE_PRIVATE);
        // if (fileOutputStream != null) {
        // JSONArray jsonArray = new JSONArray(smsList);
        //
        // String smsDataString = jsonArray.toString();
        // String encodedSMSString =
        // Base64.encodeToString(smsDataString.getBytes("UTF-8"), Base64.DEFAULT);
        // fileOutputStream.write(encodedSMSString.getBytes());
        // fileOutputStream.close();
        // Log.d(TAG, "sendIntentBroadcast: file stored");
        // } else {
        // isError = true;
        // errorMessage = "error in file output stream. File output stream is null";
        // }
        // } catch (IOException e) {
        // Log.e(TAG, "sendIntentBroadcast: io exception", e);
        // e.printStackTrace();
        // isError = true;
        // errorMessage = e.getMessage();
        // }
        Intent intent = new Intent(intentAction);
        intent.putExtra("isError", isError);
        intent.putExtra("errorMessage", errorMessage);
        intent.setPackage(context.getPackageName());
        activity.sendBroadcast(intent);
    }

    @Override
    public void registerBroadcastReceiver(BroadcastReceiver broadcastReceiver, IntentFilter intentFilter) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            activity.registerReceiver(broadcastReceiver, intentFilter, RECEIVER_NOT_EXPORTED);
        } else {
            activity.registerReceiver(broadcastReceiver, intentFilter);
        }
    }

    @Override
    public void unRegisterBroadcastReceiver(BroadcastReceiver broadcastReceiver) {
        activity.unregisterReceiver(broadcastReceiver);
    }
}