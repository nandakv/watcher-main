import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/referral_repository.dart';
import 'package:privo/app/models/referral_submission_response_model.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';

class RefreeBottomSheetLogic extends GetxController with ApiErrorMixin{
  bool _isPinSet = false;

  bool get isPinSet => _isPinSet;

  set isPinSet(bool value) {
    _isPinSet = value;
    update();
  }


  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update();
  }

  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  String otpErrorText = "";
  late final String REFERRAL_BOTTOM_SHEET = "REFERRAL_BOTTOM_SHEET";

  onContinuePressed() async {
    isButtonLoading = true;
    otpErrorText = "";
    update();
    ReferralSubmissionResponseModel responseModel = await ReferralRepository()
        .submitReferralData({"referralCode": pinPutController.text});
    switch(responseModel.apiResponse.state){
      case ResponseState.success:
        if(responseModel.message == null){
          isButtonLoading = false;
          DeepLinkService.clearDeepLink();
          AppAuthProvider.setIsReferralSuccessful();
          Get.back();
        }

        else{
          otpErrorText = "Enter the correct code";
          update();
          isButtonLoading = false;
        }

        break;
      default:
        handleAPIError(responseModel.apiResponse, screenName: REFERRAL_BOTTOM_SHEET);
    }
  }

  onSkipPressed() {
    Get.back();
  }

  void onConfirmPinSubmitted(String value) {
    if (value.isNotEmpty && value.length == 5) {
      isPinSet = true;
    }
    else{
      isPinSet = false;
    }
  }

  void onAfterLayout(String referralCode) {
    pinPutController.text = referralCode;
    if (referralCode.isNotEmpty) {
      isPinSet = true;
    }
  }
}
