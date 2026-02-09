import 'dart:io';
import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/two_factor_authentication_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/pan_details_model.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';
import 'package:privo/app/models/security_check/security_type_result_model.dart';
import 'package:privo/app/modules/security_check/security_issue_screen.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_dialogs.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/native_channels.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../services/sfmc_analytics.dart';
import '../../utils/web_engage_constant.dart';
import 'splash_screen_analytics_mixin.dart';

class SplashScreenController extends GetxController
    with
        ErrorLoggerMixin,
        ApiErrorMixin,
        AppAnalyticsMixin,
        SplashScreenAnalyticsMixin {
  late String SPLASH_SCREEN = "splash";

  bool _animateLogo = false;

  bool get animateLogo => _animateLogo;

  set animateLogo(bool value) {
    _animateLogo = value;
    update();
  }

  Offset _backgroundOffset = Offset.zero;

  Offset get backgroundOffset => _backgroundOffset;

  set backgroundOffset(Offset value) {
    _backgroundOffset = value;
    update();
  }

  bool _animateText = false;

  bool get animateText => _animateText;

  late AppParameterModel appParameterModel;

  set animateText(bool value) {
    _animateText = value;
    update();
  }

  void onLottieLoaded(composition, BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    final bounds = composition.bounds;
    final scale = max(
      screenWidth / bounds.width,
      screenHeight / bounds.height,
    );
    final resultHeight = bounds.height * scale;
    final resultWidth = bounds.width * scale;

    backgroundOffset = Offset(
      (screenWidth - resultWidth) / 2,
      (screenHeight - resultHeight) / 2,
    );
  }

  void initialCheck(BuildContext context) async {
    if (!(await Permission.notification.isGranted)) {
      Permission.notification.request();
    }

    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.splashScreenLoaded,
    );
    animateLogo = true;
    await Future.delayed(const Duration(seconds: 2));
    animateText = true;
    // retrieveReferralCode();
    await AppAnalytics.logAppOpen();

    bool isRooted = await PrivoPlatform.platformService.isRooted();
    if (isRooted) {
      _goToSecurityIssueScreen(SecurityIssueType.rooted);
    } else {
      _getAppParameters();
    }
  }

  _goToSecurityIssueScreen(SecurityIssueType type) {
    Get.offAll(
      () => SecurityIssuesScreen(
        issueType: type,
      ),
    );
  }

  ///checks for the mandatory permission
  void _checkForSecurityAndContinue() async {
    SecurityIssueType securityIssueType =
        await _computeSecurityIssueType(appParameterModel);
    if (securityIssueType == SecurityIssueType.none) {
      await _checkForPermissionAndContinue();
    } else {
      _goToSecurityIssueScreen(securityIssueType);
    }
    // if (F.appFlavor != Flavor.prod) {
    //   _showSecurityKillSwitchStatus(appParameterModel);
    // }
  }

  _checkForPermissionAndContinue() async {
    if (await AppAuthProvider.isPermissionPageShown) {
      _goToHomeScreen();
    } else if (await PrivoPlatform.platformService
        .checkAllPermissionsOnSplashScreen()) {
      _goToHomeScreen();
    } else {
      Get.offNamed(Routes.APP_PERMISSIONS);
    }
  }

  void _checkForTwoFA() async {
    if (await AppAuthProvider.shouldShowTwoFactorAuthentication) {
      _checkAndGoToTwoFactorAuthentication();
    } else {
      _checkForSecurityAndContinue();
    }
  }

  _checkAndGoToTwoFactorAuthentication() async {
    PanDetailsModel panDetails =
        await TwoFactorAuthenticationRepository().getPanDetails();
    switch (panDetails.apiResponse.state) {
      case ResponseState.success:
        _onPanDetailsGetSuccess(panDetails);
        break;
      default:
        handleAPIError(
          panDetails.apiResponse,
          screenName: SPLASH_SCREEN,
        );
    }
  }

  _onPanDetailsGetSuccess(PanDetailsModel panDetails) async {
    if (panDetails.isPanTwoFA) {
      Get.offAllNamed(
        Routes.TWO_FA_SCREEN,
        arguments: {
          "masked_pan_value": panDetails.maskedPanValue,
          "app_form_id": panDetails.appFormId
        },
      );
    } else {
      AppAuthProvider.twoFactorAuthenticationComplete();
      _checkForSecurityAndContinue();
    }
  }

  // checkUserLoginStatus() async {
  //   if (await AmplifyAuth.isUserLoggedIn()) {
  //     await SFMCAnalytics().setContactKey();
  //     _getAppParameters();
  //   } else {
  //     _checkForWelcomeScreen();
  //   }
  // }
  //
  // _checkForWelcomeScreen() async {
  //   await Future.delayed(const Duration(milliseconds: 2500));
  //   Get.offAllNamed(Routes.SIGN_IN_SCREEN);
  // }

  _goToHomeScreen() async {
    Get.offAllNamed(Routes.HOME_SCREEN);
  }

  _getAppParameters() async {
    AppParameterModel appParameterModel =
        await AppParameterRepository().getAppParameters();

    switch (appParameterModel.apiResponse.state) {
      case ResponseState.success:
        await SFMCAnalytics().setContactKey();
        this.appParameterModel = appParameterModel;
        _checkScreenProtection(appParameterModel);
        _computeForceUpdate(appParameterModel);
        _checkReportIssueKillSwitch(appParameterModel);
        _checkDeviceIpAddress(appParameterModel);
        _setDigioMockData(appParameterModel);
        break;
      default:
        handleAPIError(
          appParameterModel.apiResponse,
          screenName: SPLASH_SCREEN,
        );
    }
  }

  _showSecurityKillSwitchStatus(AppParameterModel appParameterModel) {
    if (Get.context == null) return;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: (BuildContext context) {
          return BottomSheetWidget(
            child: Column(
              children: [
                Text("Kill Switch Status"),
                const VerticalSpacer(16),
                _statusRow(
                    "Emulator Check", appParameterModel.isEmulatorCheckEnabled),
                _statusRow(
                    "Debug Check", appParameterModel.isDebugCheckEnabled),
                _statusRow(
                    "Magisk Check", appParameterModel.isMagiskCheckEnabled),
                _statusRow(
                    "Frida Check", appParameterModel.isFridaCheckEnabled),
                const VerticalSpacer(16),
              ],
            ),
          );
        });
  }

  Widget _statusRow(String title, bool value) {
    return Row(
      children: [
        Text(title),
        const HorizontalSpacer(8),
        value
            ? Icon(
                Icons.check,
                color: greenColor,
              )
            : Icon(
                Icons.close,
                color: red,
              )
      ],
    );
  }

  Future<SecurityIssueType> _computeSecurityIssueType(
      AppParameterModel model) async {
    try {
      bool isReleaseMode = kReleaseMode;
      Map<String, bool> securityChecklistMap = {
        SecurityIssueType.emulator.methodName:
            model.isEmulatorCheckEnabled && isReleaseMode,
        SecurityIssueType.magisk.methodName: model.isMagiskCheckEnabled,
        SecurityIssueType.frida.methodName: model.isFridaCheckEnabled,
        SecurityIssueType.debugging.methodName:
            model.isDebugCheckEnabled && isReleaseMode
      };

      SecurityCheckModel? securityResult = await PrivoPlatform.platformService
          .checkSecurityIssues(securityChecklistMap);

      securityResult?.securityResult.forEach((key, value) {
        logSecurityCheck(value, key.eventName);
        _checkForError(value, key.name);
      });

      return securityResult?.displayIssueType ?? SecurityIssueType.none;
    } catch (e) {
      logError(
        url: "",
        exception: e.toString(),
        requestBody: "Security check failed",
        responseBody: "",
      );

      return SecurityIssueType.none;
    }
  }

  _checkForError(SecurityTypeResultModel result, String checkName) {
    if (result.isError) {
      logError(
        url: "",
        exception: result.errorMessage,
        requestBody: "$checkName check failed",
        responseBody: "",
      );
    }
  }

  void _checkReportIssueKillSwitch(AppParameterModel model) async {
    await AppAuthProvider.setReportIssueEnabled(model.isReportIssueEnabled);
  }

  void _checkDeviceIpAddress(AppParameterModel model) async {
    await AppAuthProvider.setIdAddress(model.deviceIpAddress);
  }

  void _setDigioMockData(AppParameterModel appParameterModel) async {
    await AppAuthProvider.setDigioMockData(
        appParameterModel.isLowEnvDigioMockEnabled);
  }

  void _checkScreenProtection(AppParameterModel model) async {
    if (Platform.isAndroid) {
      await NativeFunctions().enableScreenProtection(
        enable: model.screenProtectionEnabled,
      );
    }
  }

  void _computeForceUpdate(AppParameterModel model) async {
    if (await _isForceUpdate(model.minimumVersion)) {
      _showForceUpdateDialog();
    } else {
      _checkForTwoFA();
    }
  }

  Future<bool> _isForceUpdate(String version) async {
    if (version.isNotEmpty) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      try {
        int appVersion = int.parse(packageInfo.buildNumber);
        int minimumVersion = int.parse(version.split("+").last);
        return appVersion < minimumVersion;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  _showForceUpdateDialog() async {
    final store = Platform.isIOS ? "Apple App Store" : "playstore";
    await AppDialogs.appDefaultDialog(
      title: "New Version Available",
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      content:
          "We have new features on Credit Saison India! Please update the application from $store to proceed",
      actions: [
        Expanded(
          child: BlueButton(
              onPressed: () async {
                launchUrlString(
                  PrivoPlatform.platformService.getAppStoreLink(),
                  mode: LaunchMode.externalApplication,
                );
                SystemNavigator.pop();
              },
              title: "Update",
              buttonColor: activeButtonColor),
        )
      ],
    );
  }

  _sendWebengageEventOnError() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.somethingWentWrongPopup,
        attributeName: {"screen_name": SPLASH_SCREEN});
  }

  _onTryAgainLater() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.somethingWentWrongTryagainLaterClicked,
        attributeName: {"screen_name": SPLASH_SCREEN});
    SystemNavigator.pop();
  }

  _showSomethingWentWrongDialog() async {
    _sendWebengageEventOnError();
    await AppDialogs.appDefaultDialog(
      title: "Oops",
      onWillPop: () async {
        _onTryAgainLater();
        return true;
      },
      content: "Something went wrong. Try again Later",
      actions: [
        Expanded(
          child: BlueButton(
              onPressed: _onTryAgainLater,
              title: "OKAY",
              buttonColor: activeButtonColor),
        )
      ],
    );
  }

  void retrieveReferralCode() async {
    Get.log("Referral code : ${await AppAuthProvider.getReferralCode}");
    if ((await AppAuthProvider.getReferralCode).isEmpty) {
      Get.log("started referral code");
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        final Uri deepLink = initialLink.link;
        Get.log(deepLink.path);
        // Fluttertoast.showToast(msg: deepLink.path);
        await AppAuthProvider.setReferralCode(deepLink.path.split('/').last);
        AppAnalytics.logReferralLink(deepLink: deepLink.path.split('/').last);
      } else {
        await AppAuthProvider.setReferralCode('playstore');
        // Fluttertoast.showToast(msg: "Could not retrieve the referral code");
        AppAnalytics.logWithoutReferral();
        Get.log("Could not retrieve the referral code");
      }
    }
  }
}
