import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_validator/pan_validator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/data/repository/on_boarding_repository/two_factor_authentication_repository.dart';
import 'package:privo/app/models/pan_details_verify_model.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import '../../../api/api_error_mixin.dart';
import '../../../api/response_model.dart';
import '../../../data/provider/auth_provider.dart';
import '../../../firebase/analytics.dart';
import '../../../utils/web_engage_constant.dart';

class TwoFactorAuthenticationLogic extends GetxController
    with ApiErrorMixin, ErrorLoggerMixin {
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  String maskedPanValue = "";

  int _retryCount = 0;

  var arguments = Get.arguments;

  late String appFormId;

  late String twoFactorAuthenticationScreen = "two_factor_authentication";

  final String VERIFY_BUTTON_TEXT = "Verify";
  final String TRY_AGAIN_BUTTON_TEXT = "Try Again";

  final String VERIFY_BUTTON_KEY = "verify_button";
  final String ERROR_TEXT_KEY = "error_text";

  final String WRONG_PAN_FORMAT_MESSAGE = "Enter valid PAN number..";
  final String INCORRECT_PAN_MESSAGE =
      "Looks like the PAN card details entered are not found in our system. Please try again.";

  String _errorMessage = "";

  bool _isLoading = false;
  bool _isButtonEnabled = false;
  String _buttonText = "Verify";

  String get buttonText => _buttonText;

  bool get isLoading => _isLoading;
  bool get isButtonEnabled => _isButtonEnabled;
  String get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    update([VERIFY_BUTTON_KEY]);
  }

  set buttonText(String text) {
    _buttonText = text;
    update([VERIFY_BUTTON_KEY]);
  }

  set isButtonEnabled(bool value) {
    _isButtonEnabled = value;
    update([VERIFY_BUTTON_KEY]);
  }

  set errorMessage(String value) {
    _errorMessage = value;
    update([ERROR_TEXT_KEY]);
  }

  void onPanInput() async {
    if (pinPutController.text.isNotEmpty) {
      if (pinPutController.value.text.length > 4) {
        pinPutFocusNode.unfocus();
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    }
  }

  void onAfterLayout() {
    maskedPanValue = arguments['masked_pan_value'];
    appFormId = arguments['app_form_id'];
    update();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.twoFactorAuthPanVerificationScreenLoaded);
  }

  void onVerifyPressed() async {
    final String panNumber = maskedPanValue + pinPutController.text;
    if (!PANValidator().isValid(panNumber.trim())) {
      errorMessage = WRONG_PAN_FORMAT_MESSAGE;
      return;
    } else {
      errorMessage = "";
    }

    isLoading = true;
    _retryCount += 1;
    _sendEventsOnCTA();

    Map body = {
      "panCard": panNumber,
      "appFormId": appFormId,
    };

    _sendPostRequest(body);
  }

  void _sendEventsOnCTA() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.twoFactorAuthPanVerificationInput);
    if (_retryCount <= 1) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.twoFactorAuthPanVerificationCTA);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName:
              WebEngageConstants.twoFactorAuthPanVerificationTryAgainCTA);
    }
  }

  Future<void> _sendPostRequest(Map body) async {
    PanDetailsVerifyModel panDetailsVerifyModel =
        await TwoFactorAuthenticationRepository().verifyPanDetails(body: body);

    switch (panDetailsVerifyModel.apiResponse.state) {
      case ResponseState.success:
        await _onPanDetailsSuccess(panDetailsVerifyModel);
        break;
      default:
        handleAPIError(panDetailsVerifyModel.apiResponse,
            screenName: twoFactorAuthenticationScreen, retry: onVerifyPressed);
        buttonText = TRY_AGAIN_BUTTON_TEXT;
        isLoading = false;
    }
  }

  Future<void> _onPanDetailsSuccess(
      PanDetailsVerifyModel panDetailsVerifyModel) async {
    try {
      if (panDetailsVerifyModel.isPanValid) {
        AppAuthProvider.twoFactorAuthenticationComplete();
        Get.offNamed(Routes.TWO_FA_SUCCESS_SCREEN);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.twoFactorAuthSuccessScreenLoaded);
        await Future.delayed(const Duration(seconds: 3));
        _checkForPermissions();
      } else {
        pinPutController.clear();
        errorMessage = INCORRECT_PAN_MESSAGE;
        buttonText = TRY_AGAIN_BUTTON_TEXT;
        isButtonEnabled = false;
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.twoFactorAuthPanVerificationFailed);
      }
      isLoading = false;
    } catch (e, stackTrace) {
      isLoading = false;
      logError(
        url: "",
        exception: "Error - $e \n Stack trace $stackTrace",
        requestBody:
            "Exception occurred while Fetching Customer Device Details",
        responseBody: "",
        statusCode: "",
      );
    }
  }

  Future<bool> get isAllRequiredPermissionGranted async {
    return await Permission.location.isGranted &&
        await Permission.camera.isGranted &&
        await Permission.sms.isGranted;
  }

  Future<bool> get isPermissionPageToBeShown async {
    return !(await AppAuthProvider.isPermissionPageShown ||
        await isAllRequiredPermissionGranted);
  }

  void _checkForPermissions() async {
    if (await isPermissionPageToBeShown) {
      Get.offNamed(Routes.APP_PERMISSIONS);
    } else {
      Get.offAllNamed(Routes.HOME_SCREEN);
    }
  }

  Future<bool> onBackPress() async {
    if (isLoading) {
      Fluttertoast.showToast(msg: "Please Wait");
      return false;
    }
    return true;
  }
}
