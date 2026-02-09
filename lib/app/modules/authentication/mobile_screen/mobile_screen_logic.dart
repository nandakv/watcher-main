import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../api/api_error_mixin.dart';

///Controller class to handle all the backend logics of the mobile screen
class MobileScreenLogic extends GetxController with ApiErrorMixin {
  TextEditingController mobileNoController = TextEditingController();
  FocusNode? focusNode = FocusNode();

  final String TEXTFIELD_KEY = 'number-field';
  final String HELPER_TEXT_KEY = 'helper-text';
  final String BUTTON_KEY = 'button_key';
  final String PAGE_KEY = 'page_key';
  final String PAN_CHECK_BOX_KEY = 'check_box_one_key';

  @override
  void onInit() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.registrationScreenLoading);
    super.onInit();
  }

  String? _errorText;

  String? get errorText => _errorText;

  set errorText(String? errorText) {
    _errorText = errorText;
    update([TEXTFIELD_KEY]);
  }

  final formKey = GlobalKey<FormState>();

  var arguments = Get.arguments;

  bool showHelperText = false;

  ///loading variable to change the state of the button
  bool _isPageLoading = false;

  get isPageLoading => _isPageLoading;

  set isPageLoading(value) {
    _isPageLoading = value;
    update([PAGE_KEY]);
  }

  ///loading variable to change the state of the button
  bool _isLoading = false;

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    update([BUTTON_KEY]);
  }

  set setNumber(String value) {
    errorText = null;
    if (!showHelperText) {
      showHelperText = true;
      update([HELPER_TEXT_KEY]);
    }
    isNumber = value.length == 10;
  }

  ///This variable is set to true when the text entered by user is a valid number
  ///and to enable the continue button
  bool _isNumber = false;

  bool get isNumber => _isNumber;

  set isNumber(bool value) {
    _isNumber = value;
    update([BUTTON_KEY]);
    _checkButtonEnable();
  }

  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  set isButtonEnabled(bool value) {
    _isButtonEnabled = value;
    update([BUTTON_KEY]);
  }

  bool _panConsentCheckBoxValue = false;

  bool get panConsentCheckBoxValue => _panConsentCheckBoxValue;

  set panConsentCheckBoxValue(bool value) {
    _panConsentCheckBoxValue = value;
    update([PAN_CHECK_BOX_KEY, BUTTON_KEY]);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: _panConsentCheckBoxValue
            ? WebEngageConstants.panCIBILConsentCheck
            : WebEngageConstants.panCIBILConsentUnCheck);
    _checkButtonEnable();
  }

  _checkButtonEnable() {
    isButtonEnabled = isNumber && panConsentCheckBoxValue;
  }

  void onContinueTapped() async {
    AppAnalytics.logButtonClicks(
        buttonName: 'mobile_continue',
        screenName: Routes.MOBILE_SCREEN,
        value: mobileNoController.text);

    if (mobileNoController.text.isEmpty) {
      errorText = "Please enter your mobile number";
    } else if (mobileNoController.text.length != 10) {
      errorText = "Please check your mobile number";
    } else if (panConsentCheckBoxValue) {
      Get.focusScope!.unfocus();

      isLoading = true;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.mobileNumberInput,
          attributeName: {'Status': true});
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.registrationFlowContinueCTA);
      switch (await AmplifyAuth().signIn(
        phoneNumber: mobileNoController.text,
      )) {
        case SignInState.success:
          _onSendOTPSuccess();
          break;
        case SignInState.error:
          isLoading = false;
          errorText = "Try Again Later";
          break;
        case SignInState.phoneNumberNotValid:
          isLoading = false;
          errorText = "Invalid Phone Number";
          break;
      }
    } else {
      Fluttertoast.showToast(msg: "Please Accept the Consent");
    }
  }

  void _onSendOTPSuccess() {
    isLoading = false;
    Get.toNamed(
      Routes.MOBILE_OTP_SCREEN,
      arguments: {
        'mobile_number': mobileNoController.text,
      },
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) return "Enter mobile number";
    if (value.length != 10) return "Please Check mobile Number";
    return null;
  }
}
