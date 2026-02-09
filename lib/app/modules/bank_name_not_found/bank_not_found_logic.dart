import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../firebase/analytics.dart';

enum BankNotFoundScreenStates { notFound, success }

class BankNotFoundLogic extends GetxController {
  BankNotFoundScreenStates _screenState = BankNotFoundScreenStates.notFound;

  BankNotFoundScreenStates get screenState => _screenState;

  set screenState(BankNotFoundScreenStates value) {
    _screenState = value;
    update();
  }

  TextEditingController addBankNameController = TextEditingController();

  late final String SUBMIT_BUTTON_ID = "submit_button";

  bool _isSubmitButtonEnabled = false;

  bool get isSubmitButtonEnabled => _isSubmitButtonEnabled;

  set isSubmitButtonEnabled(bool value) {
    _isSubmitButtonEnabled = value;
    update([SUBMIT_BUTTON_ID]);
  }

  @override
  void onInit() {
    addBankNameController.text = "";
    super.onInit();
  }

  onCloseIconClicked() {
    screenState = BankNotFoundScreenStates.notFound;
    Get.back();
  }

  bankNameNotFoundSubmitted() {
    if (addBankNameController.text.isNotEmpty) {
      screenState = BankNotFoundScreenStates.success;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: "Bank Not Found Submit CTA",
          attributeName: {'bank name': addBankNameController.text});
      addBankNameController.clear();
    }
  }

  onTryAnotherBank() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: "Try With Another Bank CTA",
    );
    screenState = BankNotFoundScreenStates.notFound;
    Get.back();
  }

  ///this is to track webengage event only when the
  ///user starts to type. event should trigger only one time
  bool _isEnterBankNameValueChanged = false;

  void onTextFieldValueChanged(String value) {
    if (!_isEnterBankNameValueChanged) {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "Enter Bank Name",
      );
      _isEnterBankNameValueChanged = true;
    }
    if (addBankNameController.text.isNotEmpty) {
      isSubmitButtonEnabled = true;
    } else {
      isSubmitButtonEnabled = false;
    }
  }
}
