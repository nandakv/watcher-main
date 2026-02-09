import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../flavors.dart';
import '../../data/repository/app_permission_repository.dart';
import 'platform_services.dart';

class IosPlatformServices extends PrivoPlatform {
  @override
  int getCursorPositionForCommaFormattedTextField(int position) {
    return position - 1;
  }

  @override
  Future<bool> checkAllPermissionsOnSplashScreen() async {
    return await Permission.location.isGranted &&
        await Permission.camera.isGranted;
  }

  @override
  Future<bool> requestSMSPermission() async {
    return true;
  }

  @override
  triggerSMS({String? formattedTime}) {}

  @override
  String getCameraPermissionDescription() {
    return "Camera permission helps to expedite the KYC process so that we can provide the best offer to you.";
  }

  @override
  String getLocationPermissionDescription() {
    return "This will allow us to check if your location is serviceable and also provides security against any unauthorised access to your account.";
  }

  @override
  Future<PermissionStatus> requestCameraPermission() async {
    await Permission.camera.request();

    ///returning `granted` purposely as a guideline from Apple App Store
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestLocationPermission() async {
    await Permission.location.request();

    ///returning `granted` purposely as a guideline from Apple App Store
    return PermissionStatus.granted;
  }

  @override
  Future<bool> checkAllPermissionsOnAppPermissionScreen() async {
    return true;
  }

  @override
  String getAppStoreLink() {
    return "https://apps.apple.com/us/app/privo-instant-credit-line-app/id6450202147";
  }

  @override
  Future fetchAndPostDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var build = await deviceInfoPlugin.iosInfo;
    Map<dynamic, dynamic> requestBody = {
      "deviceDetails": {
        "deviceType": "mobile",
        "operatingSystem": Platform.operatingSystem,
        "appType": "mobile",
        "deviceModel": build.model,
        "deviceManufacturer": build.identifierForVendor
      }
    };
    AppPermissionRepository().postDeviceInfo(requestBody);
  }

  @override
  Future<String?> fetchAdId() async {
    return null;
  }

  @override
  Future<SecurityCheckModel?> checkSecurityIssues(
      Map<String, bool> securityCheckList) async {
    return null;
  }

  @override
  Future<bool> isRooted() async {
    return false;
  }

  @override
  Future turnOnScreenProtection() async {
    if (F.appFlavor == Flavor.prod || F.appFlavor == Flavor.integration) {
      try {
        await ScreenProtector.protectDataLeakageWithBlur();
      } catch (e) {
        Get.log("prevent screenshot execption - $e");
      }
    }
  }

  @override
  Future turnOffScreenProtection() async {
    try {
      await ScreenProtector.protectDataLeakageWithBlurOff();
    } catch (e) {
      Get.log("prevent screenshot execption - $e");
    }
  }

  @override
  StatefulWidget pdfViewWidget({
    required PageChangedCallback? onPageChanged,
    required String filePath,
  }) {
    return PDFView(
      onPageChanged: onPageChanged,
      filePath: filePath,
      swipeHorizontal: false,
      autoSpacing: true,
      nightMode: false,
      pageSnap: false,
      fitPolicy: FitPolicy.HEIGHT,
      fitEachPage: true,
      pageFling: false,
    );
  }

  @override
  String getVKYCRedirectURL() {
    if(F.appFlavor == Flavor.prod) {
      return "https://privo.onelink.me/eIVI";
    }
    return "https://uatapp.uat.csifin.xyz/FCvh/tvkghqf7";
  }
  
  @override
  String getAppStoreText() {
    return "app store";
  }
}
