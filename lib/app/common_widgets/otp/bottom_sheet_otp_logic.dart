import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:privo/app/common_widgets/smsRetriever_impl.dart';
import 'package:smart_auth/smart_auth.dart';
import 'bottom_sheet_otp_interface.dart';


enum OTPHeaderType {
  otp,
  maskedOtp,
}
class BottomSheetOTPLogic extends GetxController {
  late final SmsRetrieverImpl smsRetrieverImpl;
  final TextEditingController pinPutController = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();

  String errorText = '';
  bool showVerified = false;
  bool pinSet = false;

  @override
  void onInit() {
    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth.instance);
    super.onInit();
  }

  bool isButtonLoading() {
    if (pinPutController.text.length > 5 && errorText.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  clearOTPPage() {
    pinPutController.clear();
    errorText = "";
  }

  bool resendWidgetVisible() {
    return !showVerified && !isButtonLoading();
  }

  bool showRetry = false;
  onOTPChange(BottomSheetOTPHandler bottomSheetOTPHandler) {
    bottomSheetOTPHandler.onConfirmPinSubmitted(
        updateToLoading: () {
          update(['pinPut', 'otp_button', 'resend','edit_id']);
        },
        onError: (errorText) {
          this.errorText = errorText;
          if(errorText.isNotEmpty){
            showRetry=true;
          }
          update(['pinPut', 'error', 'otp_button', 'resend']);
        },
        otp: pinPutController.text,
        pinSet: (isPinSet) {
          pinSet = isPinSet;
          update(['pinPut', 'error', 'otp_button', 'resend']);
        },
        onShowVerified: () {
          showVerified = true;
          update(['otp_button', 'resend','edit_id']);
        });

    if (pinPutController.text.length > 5) {
      isButtonLoading();
      update(['otp_button']);
    }
  }
}
