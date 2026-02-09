import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/request_permission_again_dialog.dart';
import 'package:privo/app/common_widgets/request_permission_settings_dialog.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/refree_widget/refree_bottom_sheet.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../data/repository/app_permission_repository.dart';
import '../../models/whatsapp_opt_in_model.dart';
import '../../utils/web_engage_constant.dart';

class AppPermissionsLogic extends GetxController with ErrorLoggerMixin {
  ///This variable prevents recalling [requestPermission]
  ///inside on resume
  bool settingsDialogShown = false;

  ///Opens all the permission dialogs
  ///after users interaction. checks for the mandatory permissions
  ///if user denied shows a pop-up to alert user for granting the permissions
  ///if user permanently denied shows a pop-up to alert user to open settings and enable permissions manually
  requestPermission() async {
    await _requestLocationPermission();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update(['bt']);
  }

  bool _showWelcomeScreen = false;

  bool get showWelcomeScreen => _showWelcomeScreen;

  set showWelcomeScreen(bool value) {
    _showWelcomeScreen = value;
    update();
  }

  _requestLocationPermission() async {
    Get.log("location status - ${await Permission.location.status}");
    if (await Permission.location.isGranted) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.locationPermissionGranted,
          attributeName: {'Status': true});
      _requestCameraPermission();
    } else {
      late PermissionStatus status;
      try {
        status =
            await PrivoPlatform.platformService.requestLocationPermission();
      } on Exception catch (e) {
        Get.log("Exception - $e");
        status = await Permission.location.status;
      }

      if (status == PermissionStatus.granted) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.locationPermissionGranted,
            attributeName: {'Status': true});
        AppPermissionRepository().onAppPermissions("Location");
        _requestCameraPermission();
      } else if (status == PermissionStatus.permanentlyDenied) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.locationPermissionGranted,
            attributeName: {'Status': false});
        _requestSettingsDialog(
            label: "Location", permission: Permission.location);
      } else {
        _requestAgainDialog(label: "Location", permission: Permission.location);
      }
    }
  }

  _requestCameraPermission() async {
    Get.log("camera status - ${(await Permission.camera.status).toString()}");
    if (await Permission.camera.isGranted) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.cameraPermissionGranted,
          attributeName: {'Status': true});
      _requestSMSPermission();
    } else {
      PermissionStatus status =
          await PrivoPlatform.platformService.requestCameraPermission();

      if (status == PermissionStatus.granted) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.cameraPermissionGranted,
            attributeName: {'Status': true});
        AppPermissionRepository().onAppPermissions("Camera");
        _requestSMSPermission();
      } else if (status == PermissionStatus.permanentlyDenied) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.cameraPermissionGranted,
            attributeName: {'Status': false});
        _requestSettingsDialog(label: "Camera", permission: Permission.camera);
      } else {
        _requestAgainDialog(label: "Camera", permission: Permission.camera);
      }
    }
  }

  _requestSMSPermission() async {
    if (await PrivoPlatform.platformService.requestSMSPermission()) {
      await _requestNotificationPermission();
    } else {
      PermissionStatus status = await Permission.sms.request();

      if (status == PermissionStatus.granted) {
        await AppPermissionRepository().onAppPermissions("SMS");
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.smsPermissionGranted,
            attributeName: {'Status': true});
        await _onSMSPermissionGranted();
      } else if (status == PermissionStatus.permanentlyDenied) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.smsPermissionGranted,
            attributeName: {'Status': false});
        _requestSettingsDialog(label: "SMS", permission: Permission.sms);
      } else {
        _requestAgainDialog(label: "SMS", permission: Permission.sms);
      }
    }
  }

  _requestNotificationPermission() async {
    await Permission.notification.request();
    await _onSMSPermissionGranted();
  }

  Future<void> _onSMSPermissionGranted() async {
    if (await PrivoPlatform.platformService
        .checkAllPermissionsOnAppPermissionScreen()) {
      await _onAllPermissionGranted();
    } else {
      requestPermission();
    }
  }

  Future<void> _onAllPermissionGranted() async {
    isLoading = true;
    AppAuthProvider.setPermissionPageShown();
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.permissionGranted);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.allPermissionGranted,
        attributeName: {'Status': true});
    await onAllPermissionGranted();
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "whatsapp_opt_in", userAttributeValue: true);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "Push Opt In", userAttributeValue: true);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "SMS Opt In", userAttributeValue: true);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "Email_Opt_In", userAttributeValue: true);
    WebEngagePlugin.setUserOptIn("whatsapp", true);
    PrivoPlatform.platformService.triggerSMS();
    await _whatsappOptIn();
    if (await AppAuthProvider.isUserSignedUp) {
      await Get.bottomSheet(
          RefreeBottomSheet(
              referralCode:
                  DeepLinkService().fetchNestedDeepLinkValue('referral_code')),
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false);
    }
    if (await AppAuthProvider.isReferralSuccessful) {
      showWelcomeScreen = true;
    } else {
      Get.offAllNamed(Routes.HOME_SCREEN);
    }

    isLoading = false;
  }

  ///Trigger this because there is one more possibility that user give permission from system setting instead of privo app permission dialog.
  Future<void> onAllPermissionGranted() async {
    await AppPermissionRepository().onAppPermissions("Location");
    await AppPermissionRepository().onAppPermissions("Camera");
    await AppPermissionRepository().onAppPermissions("SMS");
  }

  _whatsappOptIn() async {
    WhatsappOptInModel whatsappOptInModel =
        await AppPermissionRepository().getWhatsappCredentials();
    switch (whatsappOptInModel.apiResponse.state) {
      case ResponseState.success:
        if (!whatsappOptInModel.status) {
          whatsappLogError(whatsappOptInModel);
        }
        break;
      default:
        whatsappLogError(whatsappOptInModel);
    }
  }

  _requestSettingsDialog(
      {required String label, Permission? permission}) async {
    await Get.dialog(
      RequestPermissionSettingsDialog(
        onRequestAgainClicked: () async {
          settingsDialogShown = true;
          Get.back();
          await AppSettings.openAppSettings();
        },
        label: label,
      ),
    );
  }

  _requestAgainDialog({required String label, Permission? permission}) async {
    await Get.dialog(
      RequestPermissionAgainDialog(
        onRequestAgainClicked: () {
          Get.back();
          _requestLocationPermission();
        },
        label: label,
      ),
    );
  }

  void onAfterFirstLayout() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.permissionPageLoaded);
  }

  whatsappLogError(WhatsappOptInModel whatsappOptInModel) {
    logError(
      statusCode: whatsappOptInModel.apiResponse.statusCode.toString(),
      responseBody: whatsappOptInModel.apiResponse.requestBody,
      requestBody: whatsappOptInModel.apiResponse.requestBody,
      exception: whatsappOptInModel.apiResponse.exception,
      url: whatsappOptInModel.apiResponse.url,
    );
  }
}
