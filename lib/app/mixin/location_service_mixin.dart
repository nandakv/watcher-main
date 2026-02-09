import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/common_widgets/blue_border_button.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/request_permission_again_dialog.dart';
import 'package:privo/app/common_widgets/request_permission_settings_dialog.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/native_channels.dart';

class LocationServiceMixin {
  var dialogKey = GlobalKey<NavigatorState>();

  isLocationEnabled() async {
    var checkLocationEnabledResult =
        await NativeFunctions().checkIfLocationEnabled();
    if (checkLocationEnabledResult != null &&
        checkLocationEnabledResult["isLocationEnabled"] != null) {
      Get.log("CheckLocationResult $checkLocationEnabledResult");
      return checkLocationEnabledResult["isLocationEnabled"];
    }
    return false;
  }

  checkAndRequestLocationPermission() async {
    Get.log("location status - ${await Permission.location.status}");
    if (await Permission.location.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  onPermissionNotGranted() async {
    late PermissionStatus status;
    try {
      status = await Permission.location.request();
    } on Exception catch (e) {
      Get.log("Exception - $e");
      status = await Permission.location.status;
    }
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.permanentlyDenied:
        await Get.dialog(
          RequestPermissionSettingsDialog(
            onRequestAgainClicked: () async {
              Get.back();
              await AppSettings.openAppSettings();
            },
            label: "Location",
          ),
        );
        break;
      default:
        await Get.dialog(
          RequestPermissionAgainDialog(
            onRequestAgainClicked: () {
              Get.back();
              checkAndRequestLocationPermission();
            },
            label: "Location",
          ),
        );
    }
  }

  Future<dynamic> showPermissionRetryDialog(
      {required Function onRetryClicked,
      required Function onTryAgainClicked}) async {
    return await Get.defaultDialog(
      navigatorKey: dialogKey,
      onWillPop: () async => false,
      title: "OOPS",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "We are unable to retrieve your location at this point.\nPlease try after some time.",
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20,
          ),
          BlueButton(
            onPressed: () {
              AppAnalytics.locationDataRetry();
              Get.back();
              AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: "Location Retry Clicked",
              );
              onRetryClicked();
            },
            buttonColor: activeButtonColor,
            title: "RETRY",
          ),
          const SizedBox(
            height: 10,
          ),
          BlueBorderButton(
            onPressed: () {
              AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: "Location Try Again Later Clicked",
              );
              onTryAgainClicked();
              Get.back(result: true);
            },
            buttonColor: activeButtonColor,
            title: "Try again Later",
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(12),
    );
  }

  logLocationRequestStartEvent(bool isLocationPermissionGranted) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "Requesting Location Service");
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: "Requesting Location Service Completed",
      attributeName: {
        "result": isLocationPermissionGranted,
      },
    );
  }
}
