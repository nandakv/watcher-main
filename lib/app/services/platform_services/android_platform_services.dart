import 'dart:async';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';

import '../../../flavors.dart';
import '../../data/repository/app_permission_repository.dart';
import '../../firebase/analytics.dart';
import '../../utils/native_channels.dart';
import '../../utils/web_engage_constant.dart';
import '../preprocessor_service/sms_service.dart';
import 'platform_services.dart';

class AndroidPlatformServices extends PrivoPlatform {
  final NativeFunctions _nativeFunctions = NativeFunctions();

  @override
  int getCursorPositionForCommaFormattedTextField(int position) {
    return position;
  }

  @override
  Future<bool> checkAllPermissionsOnSplashScreen() async {
    return await Permission.location.isGranted &&
        await Permission.camera.isGranted &&
        await Permission.sms.isGranted;
  }

  @override
  Future<bool> requestSMSPermission() async {
    bool result = await Permission.sms.isGranted;
    if (result) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.smsPermissionGranted,
          attributeName: {'Status': true});
    }
    return result;
  }

  @override
  triggerSMS({String? formattedTime}) {
    SmsService().readSMSFlag(fromDateTime: formattedTime);
  }

  @override
  String getCameraPermissionDescription() {
    return "This will allow us to take your picture for KYC verification";
  }

  @override
  String getLocationPermissionDescription() {
    return "We track your device's location to process your loan, reduce risk, offer personalised pre-approved offers, verify your address, and expedite KYC";
  }

  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  @override
  Future<SecurityCheckModel?> checkSecurityIssues(
      Map<String, bool> securityCheckList) {
    return _nativeFunctions.checkSecurityIssues(
      securityCheckList: securityCheckList,
    );
  }

  @override
  Future<bool> isRooted() async {
    return _nativeFunctions.isDeviceRooted();
  }

  @override
  Future<bool> checkAllPermissionsOnAppPermissionScreen() async {
    return await Permission.location.isGranted &&
        await Permission.camera.isGranted &&
        await Permission.sms.isGranted;
  }

  @override
  String getAppStoreLink() {
    return "https://play.google.com/store/apps/details?id=com.privo.creditsaison";
  }

  @override
  Future fetchAndPostDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var build = await deviceInfoPlugin.androidInfo;
    Map<String, dynamic> requestBody = {
      "deviceDetails": {
        "deviceType": "mobile",
        "operatingSystem": Platform.operatingSystem,
        "appType": "mobile",
        "deviceModel": build.model,
        "deviceManufacturer": build.manufacturer
      }
    };
    AppPermissionRepository().postDeviceInfo(requestBody);
  }

  @override
  Future<String?> fetchAdId() async {
    try {
      return await AdvertisingId.id(true);
    } catch (e) {
      Get.log("error while fetching AD_ID - $e");
      return null;
    }
  }

  @override
  Future turnOnScreenProtection() async {}

  @override
  Future turnOffScreenProtection() async {}

  @override
  StatefulWidget pdfViewWidget({
    required PageChangedCallback? onPageChanged,
    required String filePath,
  }) {
    return PDFView(
      onPageChanged: onPageChanged,
      filePath: filePath,
      swipeHorizontal: false,
      autoSpacing: false,
      nightMode: false,
      pageSnap: true,
      fitPolicy: FitPolicy.WIDTH,
      fitEachPage: false,
      pageFling: true,
    );
  }

  @override
  String getVKYCRedirectURL() {
    if (F.appFlavor == Flavor.prod) {
      return "https://privo.onelink.me/eIVI";
    }
    return "https://low-env-utm-params.onelink.me/FCvh";
  }
  
  @override
  String getAppStoreText() {
    return "play store";
  }
}
