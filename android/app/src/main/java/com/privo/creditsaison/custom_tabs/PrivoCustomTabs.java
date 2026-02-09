package com.privo.creditsaison.custom_tabs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import androidx.browser.customtabs.CustomTabsIntent;

import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;


public class PrivoCustomTabs {

    private static final String TAG = "PrivoCustomTabs";

    public CustomTabsIntent getCustomTabIntent() {
        CustomTabsIntent.Builder customIntentBuilder = new CustomTabsIntent.Builder();

        customIntentBuilder.setInstantAppsEnabled(false);
        customIntentBuilder.setShareState(CustomTabsIntent.SHARE_STATE_OFF);
        customIntentBuilder.setShowTitle(true);
        customIntentBuilder.setCloseButtonPosition(CustomTabsIntent.CLOSE_BUTTON_POSITION_END);
        customIntentBuilder.setUrlBarHidingEnabled(true);
        customIntentBuilder.setColorScheme(COLOR_SCHEME_LIGHT);
        CustomTabsIntent customTabsIntent = customIntentBuilder.build();
//        customTabsIntent.intent.setPackage("com.android.chrome");

        return customTabsIntent;
    }

}