package com.privo.creditsaison.web_view;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import com.google.android.material.snackbar.Snackbar;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.util.Log;
import android.view.View;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toolbar;

import com.privo.creditsaison.R;

public class EmandateWebViewActivity extends AppCompatActivity {

    private static final String TAG = "EmandateWebViewActivity";
    //    private ValueCallback<Uri> mUploadMessage;
    private static boolean CALLBACK_TRIGGERED = false;
//    public static final int REQUEST_SELECT_FILE = 100;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String data = getIntent().getStringExtra("url");
        String callBackUrl = getIntent().getStringExtra("callback_url");
        setContentView(R.layout.activity_emandate_web_view);

        WebViewClient webViewClient = new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                Log.d(TAG, "onPageStarted: url = " + url);
                Log.d(TAG, "onPageStarted: callbackUrl = " + callBackUrl);
                CALLBACK_TRIGGERED = url.contains(callBackUrl);
                if (CALLBACK_TRIGGERED) {
                    onBackPressed();
                }
            }
        };


//        WebChromeClient webChromeClient = new WebChromeClient(){
//            public void onProgressChanged(WebView view, int progress) {
//
//            }
//
//            //The undocumented magic method override
//            //Eclipse will swear at you if you try to put @Override here
//            // For Android 3.0+
//            public void openFileChooser(ValueCallback<Uri> uploadMsg) {
//
//                mUploadMessage = uploadMsg;
//                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
//                i.addCategory(Intent.CATEGORY_OPENABLE);
//                i.setType("image/*");
//                startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_RESULTCODE);
//            }
//
//            // For Android 3.0+
//            public void openFileChooser(ValueCallback uploadMsg, String acceptType) {
//                mUploadMessage = uploadMsg;
//                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
//                i.addCategory(Intent.CATEGORY_OPENABLE);
//                i.setType("*/*");
//                startActivityForResult(
//                        Intent.createChooser(i, "File Browser"),
//                        FILECHOOSER_RESULTCODE);
//            }
//
//            //For Android 4.1
//            public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture) {
//                mUploadMessage = uploadMsg;
//                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
//                i.addCategory(Intent.CATEGORY_OPENABLE);
//                i.setType("image/*");
//                startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_RESULTCODE);
//
//            }
//
//        };
        WebView webView = (WebView) findViewById(R.id.web);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
//        webView.getSettings().setAppCacheEnabled(true);
        webView.getSettings().setAllowContentAccess(true);
        webView.getSettings().setAllowFileAccess(true);
        webView.setWebViewClient(webViewClient);
        webView.setClickable(true);
        webView.setWebChromeClient(new WebChromeClient());
        webView.loadDataWithBaseURL(null, data, "text/html", "utf-8", null);
        // this will enable the javascript.
    }

    @Override
    public void onBackPressed() {
        Log.d(TAG, "onBackPressed: webview = " + CALLBACK_TRIGGERED);
        if (getParent() == null) {
            setResult(CALLBACK_TRIGGERED ? Activity.RESULT_OK : Activity.RESULT_CANCELED);
        } else {
            getParent().setResult(CALLBACK_TRIGGERED ? Activity.RESULT_OK : Activity.RESULT_CANCELED);
        }

        finishActivity(396);
        super.onBackPressed();
    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent intent) {
//        if (requestCode == FILECHOOSER_RESULTCODE) {
//            if (null == mUploadMessage) return;
//            Uri result = intent == null || resultCode != RESULT_OK ? null
//                    : intent.getData();
//            mUploadMessage.onReceiveValue(result);
//            mUploadMessage = null;
//        }
//        super.onActivityResult(requestCode, resultCode, intent);
//    }
}