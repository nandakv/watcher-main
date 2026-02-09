package com.privo.creditsaison;
import android.os.Build;
import android.util.Log;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmulatorCheck {

    private static final String TAG = "EmulatorDetection";

    //#region Files String
    private static List<String> GENY_FILES = new ArrayList<>(
            Arrays.asList(
                    "/dev/socket/genyd",
                    "/dev/socket/baseband_genyd"
            )
    );

    private static List<String> PIPES = new ArrayList<>(
            Arrays.asList(
                    "/dev/socket/qemud",
                    "/dev/qemu_pipe"
            )
    );

    private static List<String> X86_FILES = new ArrayList<>(
            Arrays.asList(
                    "ueventd.android_x86.rc",
                    "x86.prop",
                    "ueventd.ttVM_x86.rc",
                    "init.ttVM_x86.rc",
                    "fstab.ttVM_x86",
                    "fstab.vbox86",
                    "init.vbox86.rc",
                    "ueventd.vbox86.rc"
            )
    );

    private static List<String> ANDY_FILES = new ArrayList<>(
            Arrays.asList(
                    "fstab.andy",
                    "ueventd.andy.rc"
            )
    );

    private static List<String> NOX_FILES = new ArrayList<>(
            Arrays.asList(
                    "fstab.nox",
                    "init.nox.rc",
                    "ueventd.nox.rc"
            )
    );
    //#endregion

    //#region Methods
    public static Map<String,Object> isEmulator() {
        Map<String, Object> responseHashMap = new HashMap<>();
        try {
            boolean isEmulator = Build.FINGERPRINT.startsWith("generic")
                    || Build.FINGERPRINT.startsWith("unknown")
                    || Build.MODEL.contains("google_sdk")
                    || Build.MODEL.contains("Emulator")
                    || Build.MODEL.contains("Android SDK built for x86")
                    || Build.MANUFACTURER.contains("Genymotion")
                    || Build.MODEL.startsWith("sdk_")
                    || Build.DEVICE.startsWith("emulator")
                    || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                    || "google_sdk".equals(Build.PRODUCT)
                    //bluestacks
                    || "QC_Reference_Phone" == Build.BOARD && !"xiaomi".equalsIgnoreCase(Build.MANUFACTURER)
                    //bluestacks
                    || Build.MANUFACTURER.contains("Genymotion")
                    || (Build.HOST.startsWith("Build") && !Build.MANUFACTURER.equalsIgnoreCase("sony"))
                    //MSI App Player
                    || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                    || Build.PRODUCT == "google_sdk"
                    // another Android SDK emulator check
//                || SystemProperties.get("ro.kernel.qemu") == "1"
                    || Build.HARDWARE.contains("goldfish")
                    || Build.HARDWARE.contains("ranchu")
                    || Build.PRODUCT.contains("vbox86p")
                    || Build.PRODUCT.toLowerCase().contains("nox")
                    || Build.BOARD.toLowerCase().contains("nox")
                    || Build.HARDWARE.toLowerCase().contains("nox")
                    || Build.MODEL.toLowerCase().contains("droid4x")
                    || Build.HARDWARE == "vbox86"
                    || checkEmulatorFiles();

            responseHashMap.put("isDetected",isEmulator);
            responseHashMap.put("isError",false);
        }
        catch (Exception e){
            Log.d(TAG, "Emulator check failed with error message - "+e.getMessage());
            responseHashMap.put("isDetected",false);
            responseHashMap.put("isError",true);
            responseHashMap.put("errorMessage",e.getMessage());
        }
        return responseHashMap ;
    }
    //#endregion

    //#region Utils
    private static boolean checkFiles(List<String> targets){
        for(String pipe : targets){
            File file = new File(pipe);
            if (file.exists())
                {return true;}
        }
        return false;
    }

    private static boolean checkEmulatorFiles (){
        return (checkFiles(GENY_FILES)
                || checkFiles(ANDY_FILES)
                || checkFiles(NOX_FILES)
                || checkFiles(X86_FILES)
                || checkFiles(PIPES));
    }
    //#endregion
}
