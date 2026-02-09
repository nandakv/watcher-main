import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/snack_bar.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
// import 'package:webengage_flutter/webengage_flutter.dart';
import '../../../services/platform_services/platform_services.dart';
import '../../../utils/web_engage_constant.dart';

import '../../../utils/firebase_constants.dart';

///Controller class to handle all the backend logics of the otp screen
class VerifyOTPLogic extends GetxController with ApiErrorMixin {
  final String MOBILE_NUMBER_KEY = 'mobile_number';
  final String PIN_SET_KEY = 'is_pin_set';

  int _otpRetryCount = 0;

  bool _isPinSet = false;

  bool get isPinSet => _isPinSet;

  set isPinSet(bool value) {
    _isPinSet = value;
    update([PIN_SET_KEY]);
  }

  var arguments = Get.arguments;

  String errorText = "";

  ///loading variable to change the state of the button
  bool _isLoading = false;

  set isLoading(value) {
    _isLoading = value;
    update([PIN_SET_KEY]);
  }

  bool get isLoading => _isLoading;

  ///loading variable to change the state of the button
  bool _isResendLoading = false;

  set isResendLoading(value) {
    _isResendLoading = value;
    update(['resend']);
  }

  get isResendLoading => _isResendLoading;

  ///Sets the value to true if pin is entered
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  BoxDecoration selectedFieldDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  ///Box Decoration for the pin input of OTP
  BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  BoxDecoration errorPinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: Colors.grey.withOpacity(0.5),
    border: Border.all(color: const Color(0xffE35959), width: 2),
  );

  ///Function to handle when the pin is submitted. Checks if the pin is matching with confirm pin
  ///and sets the label and button color
  void onConfirmPinSubmitted() async {
    if (pinPutController.text.isNotEmpty) {
      errorText = "";
      selectedFieldDecoration = pinPutDecoration;
      update(['pinput']);
      if (pinPutController.value.text.length > 5) {
        pinPutFocusNode.unfocus();
        isPinSet = true;
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.OTPInput);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.verifyOTPInput);
        pushToNextScreen(pinPutController.text);
      } else {
        isPinSet = false;
      }
    } else {
      errorText = "Enter OTP";
      selectedFieldDecoration = errorPinPutDecoration;
      update(['pinput']);
    }
  }

  ///to reset the timer of resend button
  Future reset() async {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
    isResendLoading = true;

    await AmplifyAuth().signIn(phoneNumber: arguments[MOBILE_NUMBER_KEY]);

    await AppSnackBar.successBar(
        title: "An OTP has been sent to your Mobile Number",
        message: arguments[MOBILE_NUMBER_KEY]);

    isResendLoading = false;
  }

  ///Push to next [Routes.MOBILE_SCREEN] if it is coming from email screen
  /// and [Routes.ON_BOARDING_SCREEN] if it is coming from  mobile screen
  void pushToNextScreen(String value) async {
    isLoading = true;
    AppAnalytics.logButtonClicks(
        buttonName: 'otp_continue',
        screenName: Routes.OTP_SCREEN,
        value: value);

    _otpRetryCount++;

    switch (await AmplifyAuth().verifyOTP(otp: pinPutController.text)) {
      case VerifyOTPState.success:
        AuthUser user = await Amplify.Auth.getCurrentUser();
        String subId = user.userId;
        WebEngagePlugin.userLogin(subId);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.userLoggedIn);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.OTPVerify,
            attributeName: {'Status': true});
        await _onVerifyOTPSuccess();
        break;
      case VerifyOTPState.error:
        isLoading = false;
        errorText = "Try Again Later";
        pinPutDecoration = errorPinPutDecoration;
        update(['pinput']);
        break;
      case VerifyOTPState.invalidOTP:
        isLoading = false;
        errorText = "Enter the correct OTP";
        pinPutDecoration = errorPinPutDecoration;
        update(['pinput']);
        break;
      case VerifyOTPState.notAuthorized:
        Fluttertoast.showToast(
            msg: _computeToastMessageForNotAuthorizedException());
        Get.back();
        break;
    }
  }

  String _computeToastMessageForNotAuthorizedException() {
    return _otpRetryCount < 3
        ? "Session Expired"
        : "Too many Attempts with Incorrect OTP\nTry Again";
  }

  Future<void> _onVerifyOTPSuccess() async {
    AppAnalytics.logFirebaseEvents(eventName: FirebaseConstants.signUp);
    await AppAuthProvider.setPhoneNumber(arguments[MOBILE_NUMBER_KEY]);
    if (await AppAuthProvider.isUserSignedUp) {
      AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.signUp,
      );
      PrivoPlatform.platformService.fetchAndPostDeviceDetails();
    }

    await AppAuthProvider.restartApp();
  }

  @override
  void onClose() {
    pinPutController.text = "";
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void codeUpdated() {
    onConfirmPinSubmitted();
  }

  String getNumberString(String mobileNumber) {
    // String last4Digits = mobileNumber.substring(mobileNumber.length - 4);
    return mobileNumber;
  }

  Future<bool> onBackPress() async {
    if (isLoading || isResendLoading) {
      Fluttertoast.showToast(msg: "Please Wait");
      return false;
    }
    return true;
  }
}
