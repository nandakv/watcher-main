import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../common_widgets/forms/base_field_validator.dart';
import '../../data/provider/auth_provider.dart';
import '../../mixin/app_analytics_mixin.dart';
import '../../modules/authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../../modules/on_boarding/aa_stand_alone_journey/aa_bank_analytics_mixin.dart';

class MobileNumberBottomSheetLogic extends GetxController
    with
        SignInFieldValidator,
        BaseFieldValidators,
        AppAnalyticsMixin,
        AABankAnalyticsMixin {
  final mobileNumberController = TextEditingController();
  final String MOBILE_NUMBER_CTA = 'MOBILE_NUMBER_CTA';
  final String MOBILE_NUMBER_TEXT_FIELD = 'MOBILE_NUMBER_TEXT_FIELD';

  bool _isMobileNumberCTAEnabled = true;

  bool get isMobileNumberCTAEnabled => _isMobileNumberCTAEnabled;

  set mobileNumberCTAEnabledStatus(bool value) {
    _isMobileNumberCTAEnabled = value;
  }

  void onMobileNumberChanged() {
    mobileNumberCTAEnabledStatus =
        isFieldValid(validateMobileNumber(mobileNumberController.text));
    update([MOBILE_NUMBER_CTA,MOBILE_NUMBER_TEXT_FIELD]);
  }

  Future<void> onAfterLayout() async {
    mobileNumberController.text = await AppAuthProvider.phoneNumber;
    onMobileNumberChanged();
  }

  void isMobileNumberEditingEvents({required String flowType}) async {
    if (mobileNumberController.text == await AppAuthProvider.phoneNumber) {
      logMobileNumberContinueWithoutEditing(flowType: flowType);
    } else {
      logMobileNumberContinueAfterEditing(flowType: flowType);
    }
  }

  computeCloseButtonEvents({required String flowType}) {
    Get.back();
    return logMobileNumberCloseButtonClicked(flowType: flowType);
  }
}
