package com.privo.creditsaison.services;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.Telephony;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;


public class NativeSMSService {
    private Context context;

    public NativeSMSService(Context context) {
        this.context = context;
    }


    List<HashMap<String, String>> lstSms = new ArrayList<>();

    List<String> smsColumnsList = new ArrayList<>();


    ///Fetch all sms from device and parse the required data
    public List<HashMap<String, String>> getAllSms() {
        ContentResolver cr = context.getContentResolver();
        smsColumnsList.addAll(Arrays.asList("creator", "address", "date_sent", "reply_path_present", "read", "body", "type", "seen", "thread_id", "protocol", "service_center", "status"));
        Cursor c = cr.query(Telephony.Sms.Inbox.CONTENT_URI, null, null, null, null);
        int totalSMS = c.getCount();
        if (c.moveToFirst()) {
            iterateSmsFromCursor(c, totalSMS);
        }
        c.close();
        return lstSms;
    }

    private void iterateSmsFromCursor(Cursor c, int totalSMS) {
        for (int i = 0; i < totalSMS; i++) {
            try {
                parseMapForSms(c);
            } catch (Exception e) {
                e.printStackTrace();
            }
            c.moveToNext();
        }
    }


    private void parseMapForSms(Cursor c) {
        HashMap<String, String> smsMap = new HashMap<>();
        for (int i = 0; i < smsColumnsList.size(); i++) {
            smsMap.put(smsColumnsList.get(i), c.getString(c.getColumnIndexOrThrow(smsColumnsList.get(i))));
        }
        smsMap.put("smsid", c.getString(c.getColumnIndexOrThrow("_id")));
        smsMap.put("time", c.getString(c.getColumnIndexOrThrow("date")));
        lstSms.add(smsMap);
    }
}