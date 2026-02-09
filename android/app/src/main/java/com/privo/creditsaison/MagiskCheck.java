package com.privo.creditsaison;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

public class MagiskCheck {

    private static final String TAG = "MagiskCheck";

    /**
     * Check if Magisk app is installed.
     * Limitations:
     * Magisk Manager can be renamed or hidden.
     * Users can remove the manager after configuring Magisk.
     */
    public static boolean isMagiskInstalled(Context context) {
        String[] knownMagiskPackages = {
                "com.topjohnwu.magisk",
                "com.topjohnwu.magisk.beta",
                "com.topjohnwu.magisk.manager"
        };

        PackageManager pm = context.getPackageManager();
        for (String packageName : knownMagiskPackages) {
            try {
                pm.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES);
                return true;  // Magisk detected
            } catch (PackageManager.NameNotFoundException ignored) {
            }
        }
        return false;
    }

    /**
     * Check for Magisk-related files on the device.
     * Even if Magisk Manager is hidden, Magisk itself leaves behind files in specific locations. You can scan for these files:
     * Limitations:
     * Magisk Hide (or Zygisk) can remove or obfuscate these files.
     * Some files may only exist temporarily during boot.
     */
    public static boolean isMagiskFilesPresent() {
        String[] magiskPaths = {
                "/sbin/.magisk",
                "/sbin/magisk",
                "/data/adb/magisk",
                "/data/adb/magisk.img",
                "/cache/magisk.log",
                "/data/adb/modules"
        };

        for (String path : magiskPaths) {
            File file = new File(path);
            if (file.exists()) {
                return true;  // Magisk detected
            }
        }
        return false;
    }

    /**
     * Check if system properties have been modified by Magisk.
     * Magisk modifies certain system properties to enable root access. You can query system properties to detect anomalies.
     * Limitations:
     * Advanced users can modify these values using Magisk.
     * Some custom ROMs also modify these properties.
     */
    public static boolean isMagiskPropertyModified() {
        // Predefined secure values
        Map<String, String> expectedValues = new HashMap<>();
        expectedValues.put("ro.debuggable", "0");  // Should be 0 on production
        expectedValues.put("ro.secure", "1");      // Should be 1 on production
        expectedValues.put("ro.boot.verifiedbootstate", "green"); // Should be green on secure devices
        // gives orange when bootloader is unlocked, yellow when unlocked (some devices), red when verification failed

        for (Map.Entry<String, String> entry : expectedValues.entrySet()) {
            String prop = entry.getKey();
            String expectedValue = entry.getValue();

            String actualValue = getSystemProperty(prop);
            
            // Handle empty or null value
            if (actualValue == null || actualValue.trim().isEmpty()) {
                Log.w("SecurityCheck", "Property " + prop + " returned empty!");
                continue; // Skip checking this property if it's unavailable
            }

            if (!actualValue.equalsIgnoreCase(expectedValue)) {
                return true; // Suspicious modification detected
            }
        }
        return false;
    }


    /**
     * Helper method to get system properties.
     */
    private static String getSystemProperty(String property) {
        try {
            Process process = Runtime.getRuntime().exec("getprop " + property);
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String value = reader.readLine();
            reader.close();
            return value;
        } catch (IOException e) {
            Log.e(TAG, "Error reading system property: " + property, e);
            return null;
        }
    }

    /**
     * Check if Magisk modules directory exists.
     * Magisk allows users to install modules that modify the system. Check for the presence of such modules:
     * Limitations:
     * Modules can be hidden or uninstalled after use.
     */
    public static boolean isMagiskModuleInstalled() {
        File modulesDir = new File("/data/adb/modules");
        return modulesDir.exists() && modulesDir.isDirectory();
    }

    /**
     * Check if Magisk is mounted in the system.
     * Magisk modifies the filesystem and uses overlay mounts. Checking /proc/mounts can reveal suspicious entries.
     * Limitations:
     * Magisk Hide can mask these mounts.
     * Some custom ROMs may have similar mounts.
     */
    public static boolean isMagiskMounted() {
        try {
            BufferedReader reader = new BufferedReader(new FileReader("/proc/mounts"));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("magisk") || line.contains("/sbin/.magisk")) {
                    reader.close();
                    return true;  // Magisk detected
                }
            }
            reader.close();
        } catch (IOException e) {
            Log.e(TAG, "Error reading mount points", e);
        }
        return false;
    }

    /**
     * Perform all Magisk detection checks.
     */
    public static Map<String, Object> isMagiskDetected(Context context) {
        HashMap<String, Object> responseHashMap = new HashMap<>();
        try {
            boolean isMagiskInstalled = isMagiskInstalled(context);
            boolean isMagiskFilesPresent = isMagiskFilesPresent();
            boolean isMagiskPropertyModified = isMagiskPropertyModified();
            boolean isMagiskMounted = isMagiskMounted();
            boolean isMagiskModuleInstalled = isMagiskModuleInstalled();

            Log.d(TAG, "Magisk Detection Results: ");
            Log.d(TAG, "isMagiskInstalled: " + isMagiskInstalled);
            Log.d(TAG, "isMagiskFilesPresent: " + isMagiskFilesPresent);
            Log.d(TAG, "isMagiskPropertyModified: " + isMagiskPropertyModified);
            Log.d(TAG, "isMagiskMounted: " + isMagiskMounted);
            Log.d(TAG, "isMagiskModuleInstalled: " + isMagiskModuleInstalled);

            String logMessage = "Install:"+isMagiskInstalled+",Files:"+isMagiskFilesPresent+",Property:"+isMagiskPropertyModified+",Mounted:"+isMagiskMounted+",Module:"+isMagiskModuleInstalled;
            
            boolean isDetected =  isMagiskInstalled ||
                    isMagiskFilesPresent ||
                    isMagiskPropertyModified ||
                    isMagiskMounted ||
                    isMagiskModuleInstalled;

            responseHashMap.put("isError",false);
            responseHashMap.put("isDetected",isDetected);
            responseHashMap.put("logMessage",logMessage);
            return responseHashMap;

        }
        catch (Exception e){
            responseHashMap.put("isError",true);
            responseHashMap.put("isDetected",false);
            responseHashMap.put("errorMessage",e.getMessage());
            return responseHashMap;
        }
    }

}
