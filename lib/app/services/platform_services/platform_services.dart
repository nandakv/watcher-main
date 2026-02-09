import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';
import 'package:privo/app/services/platform_services/android_platform_services.dart';
import 'package:privo/app/services/platform_services/ios_platform_services.dart';

abstract class PrivoPlatform {
  static late final PrivoPlatform platformService;

  static void initializePlatformServices() {
    platformService =
        Platform.isIOS ? IosPlatformServices() : AndroidPlatformServices();
  }

  String getAppStoreLink();

  String getAppStoreText();

  Future<bool> checkAllPermissionsOnSplashScreen();

  Future<bool> checkAllPermissionsOnAppPermissionScreen();

  int getCursorPositionForCommaFormattedTextField(int position);

  Future<PermissionStatus> requestLocationPermission();

  Future<PermissionStatus> requestCameraPermission();

  Future<bool> requestSMSPermission();

  triggerSMS({String? formattedTime});

  String getLocationPermissionDescription();

  String getCameraPermissionDescription();

  Future fetchAndPostDeviceDetails();

  Future<String?> fetchAdId();

  Future turnOnScreenProtection();

  Future turnOffScreenProtection();

  Future<SecurityCheckModel?> checkSecurityIssues(
      Map<String, bool> securityCheckList);

  Future<bool> isRooted();

  StatefulWidget pdfViewWidget({
    required PageChangedCallback? onPageChanged,
    required String filePath,
  });

  String getVKYCRedirectURL();

}
