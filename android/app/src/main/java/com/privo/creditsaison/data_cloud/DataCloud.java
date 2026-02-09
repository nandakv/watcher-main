package com.privo.creditsaison.data_cloud;

import android.content.Context;
import android.util.Log;

import com.salesforce.marketingcloud.cdp.CdpSdk;
import com.salesforce.marketingcloud.cdp.consent.Consent;
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk;
import com.salesforce.marketingcloud.sfmcsdk.components.events.EventManager;
import com.salesforce.marketingcloud.sfmcsdk.modules.ModuleIdentifier;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

public class DataCloud {

    final MethodCall call;
    final Context context;

    public DataCloud(MethodCall call, Context context) {
        this.call = call;
        this.context = context;
    }

    private static final String TAG = "DataCloud";

    public DataCloudResult login() {
        String phoneNumber = call.argument("phone_number");

        if (phoneNumber == null) {
            return new DataCloudResult(false, "Bad arguments");
        }

        try {
            SFMCSdk.requestSdk(sfmcSdk -> {
                sfmcSdk.getIdentity().setProfileAttribute("phoneNumber", phoneNumber, ModuleIdentifier.CDP);
                sfmcSdk.getIdentity().setProfileAttribute("isAnonymous", "0", ModuleIdentifier.CDP);
            });
            CdpSdk.requestSdk(cdpSdk -> cdpSdk.setConsent(Consent.OPT_IN));
            return new DataCloudResult(true, "success");
        } catch (Exception e) {
            return new DataCloudResult(false, e.getMessage());
        }

    }

    public DataCloudResult logout() {

        try {
            SFMCSdk.requestSdk(sfmcSdk -> {
                sfmcSdk.getIdentity().setProfileAttribute("isAnonymous", "1", ModuleIdentifier.CDP);
            });
            return new DataCloudResult(true, "success");
        } catch (Exception e) {
            return new DataCloudResult(false, e.getMessage());
        }

    }

    public DataCloudResult setUserAttributes() {
        String attributeName = call.argument("attributeName");
        String attributeValue = call.argument("attributeValue");

        if (attributeName == null || attributeValue == null) {
            return new DataCloudResult(false, "Bad arguments");
        }

        try {
            SFMCSdk.requestSdk(sfmcSdk -> {
                sfmcSdk.getIdentity().setProfileAttribute(attributeName, attributeValue, ModuleIdentifier.CDP);
            });
            return new DataCloudResult(true, "success");
        } catch (Exception e) {
            return new DataCloudResult(false, e.getMessage());
        }

    }

    public DataCloudResult trackEvents() {
        String eventName = call.argument("event_name");
        Map<String, ?> attributes = call.argument("attributes");

        if (eventName == null) {
            return new DataCloudResult(false, "Bad arguments");
        }

        try {

            Log.d(TAG, "trackEvents: eventName - " + eventName);
            Log.d(TAG, "trackEvents: attributes - " + attributes);

            if (attributes != null) {
                SFMCSdk.track(EventManager.customEvent(eventName, attributes));
            } else {
                SFMCSdk.track(EventManager.customEvent(eventName));
            }


            return new DataCloudResult(true, "success");
        } catch (Exception e) {
            return new DataCloudResult(false, e.getMessage());
        }

    }

}
