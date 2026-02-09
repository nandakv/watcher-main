package com.privo.creditsaison.services;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.EventChannel;

public class NativeLocationService implements EventChannel.StreamHandler {


    private static final String TAG = "LocationService";

    private LocationManager locationManager;
    private LocationListener locationListener;

    Context context;

    EventChannel.EventSink events;
    private boolean isError = false;
    private String errorMessage = "";


    public NativeLocationService(Context context, LocationManager locationManager) {
        this.context = context;
        this.locationManager = locationManager;
    }

    public HashMap<String, Object> fetchLocation(boolean fetchLastKnownLocation) {
        if(fetchLastKnownLocation){
            fetchLastKnownLocation();
        }
        else{
            fetchCoarseLocation();
        }
        HashMap<String, Object> errorHashMap = new HashMap<>();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && !locationManager.isLocationEnabled()) {
            errorHashMap.put("errorMessage", "LOCATION_DISABLED");
            isError = true;
        } else {
            errorHashMap.put("errorMessage", errorMessage);
        }
        errorHashMap.put("isError", isError);
        return errorHashMap;
    }

    private void fetchLastKnownLocation() {

        Log.d(TAG, "fetchLastKnownLocation: Fetching last known location");
        @SuppressLint("MissingPermission") Location location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        if(location != null){
            removeLocationUpdates();
            try {
                isError = false;
                events.success(locationToJsonMap(location,true));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        Log.d(TAG, "fetchLastLnownLocation: " + location.toString());
    }

    @NonNull
    public HashMap<String, Object> checkIfLocationEnabled() {
        HashMap<String, Object> resultMap = new HashMap<>();
        boolean isLocationEnabled = Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && locationManager.isLocationEnabled();
        resultMap.put("isLocationEnabled", isLocationEnabled);
        return resultMap;
    }

    @SuppressLint("MissingPermission")
    private void fetchCoarseLocation() {

        Log.d(TAG, "fetchCoarseLocation: Fetching coarse location");
        locationListener = new LocationListener() {
            @Override
            public void onLocationChanged(Location location) {
                Log.d(TAG, "onLocationChanged: " + location.getLatitude() + "   long-" + location.getLongitude());
                removeLocationUpdates();
                try {
                    isError = false;
                    events.success(locationToJsonMap(location,false));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                // Do something with the latitude and longitude
            }

            @Override
            public void onLocationChanged(@NonNull List<Location> locations) {
                LocationListener.super.onLocationChanged(locations);
            }

            @Override
            public void onStatusChanged(String provider, int status, Bundle extras) {
                Log.d(TAG, "onStatusChanged: Location changed " + provider + status);
            }

            @Override
            public void onProviderEnabled(String provider) {
            }

            @Override
            public void onProviderDisabled(String provider) {
            }
        };
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);
    }

    private void removeLocationUpdates() {
        if(locationManager != null && locationListener != null){
            locationManager.removeUpdates(locationListener);
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
        Log.d(TAG, "Got into onlisten " + events.toString());
    }

    @Override
    public void onCancel(Object arguments) {
        ///Cancel the locaiton service
        if (locationListener != null) {
            locationManager.removeUpdates(locationListener);
            locationListener = null;
            Log.d(TAG, "onCancel: Cancelled");
        }
    }

    private HashMap<String, Object> locationToJsonMap(Location location,boolean isLastKnownLocation) throws Exception {
        HashMap<String, Object> locationMap = new HashMap<String, Object>();
        locationMap.put("latitude", location.getLatitude());
        locationMap.put("longitude", location.getLongitude());
        locationMap.put("altitude", location.getAltitude());
        locationMap.put("accuracy", location.getAccuracy());
        locationMap.put("bearing", location.getBearing());
        locationMap.put("speed", location.getSpeed());
        locationMap.put("provider", location.getProvider());
        locationMap.put("time", location.getTime());

        if(isLastKnownLocation){
            locationMap.put("isLastKnownLocation", true);
        }

        return locationMap;
    }



}
