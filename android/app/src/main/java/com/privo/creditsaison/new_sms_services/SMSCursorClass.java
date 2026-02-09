package com.privo.creditsaison.new_sms_services;

import android.database.Cursor;
import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

public class SMSCursorClass {

    private static final String TAG = "SMSCursorClass";

    private final List<HashMap<String, String>> smsList = new ArrayList<>();
    private boolean isError = false;
    private String errorMessage = "";

    public HashMap<String, Object> fetchSMS(Cursor cursor, String fromDateTime) {
        try {
            ///limitation in backend api, so we are limiting the sms count to [MAX_SMS_LIMIT]
            int MAX_SMS_LIMIT = 9000;
            while (smsList.size() < MAX_SMS_LIMIT && cursor.moveToNext()) {
                HashMap<String, String> dataObject = new HashMap<>(cursor.getColumnCount());

                for (int i = 0; i < cursor.getColumnNames().length; i++) {
                    String columnName = cursor.getColumnNames()[i];
                    try {
                        int columnIndex = cursor.getColumnIndexOrThrow(columnName);
                        if (columnIndex >= 0) {
                            String value = cursor.getString(i);
//                            Log.d(TAG, "fetchSMS: columnName : " + columnName + ", value : " + value);
                            if (columnName.equals("_id")) columnName = "smsid";
                            if (columnName.equals("date")) columnName = "time";
                            dataObject.put(columnName, value);
                        }
                    } catch (IllegalArgumentException e) {
                        isError = true;
                        errorMessage = e.getMessage();
                    }
                }
                if (Objects.requireNonNull(dataObject.get("address")).length() < 13) {
                    if (fromDateTime.isEmpty()) {
                        smsList.add(dataObject);
                    } else {
                        long smsDateTime = Long.parseLong(Objects.requireNonNull(dataObject.get("time")));
                        if (isSMSDateTimeIsAfterFromDateTime(smsDateTime, fromDateTime)) {
                            smsList.add(dataObject);
                        }
                    }
                }
            }
            cursor.close();
        } catch (Exception e) {
            Log.e(TAG, "getAllSms: cursor failed", e);
            isError = true;
            errorMessage = e.getMessage();
            cursor.close();
        }
        HashMap<String, Object> valueHashMap = new HashMap<>();
        valueHashMap.put("isError", isError);
        valueHashMap.put("errorMessage", errorMessage);
        valueHashMap.put("smsList", smsList);
        return valueHashMap;
    }

    private boolean isSMSDateTimeIsAfterFromDateTime(long smsDateTime, String fromDateTime) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        try {
            Date givenDate = format.parse(fromDateTime);
            assert givenDate != null;
            long givenDateTimeMillis = givenDate.getTime();

            return smsDateTime > givenDateTimeMillis;
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
    }
}