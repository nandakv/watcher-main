import 'package:flutter/material.dart';

abstract class BottomSheetOTPHandler {
  onEditClick();

  onConfirmPinSubmitted(
      {required Function updateToLoading,
      required Function(String errorText) onError,
      required String otp,
      required Function(bool onPinSet) pinSet,
      required Function onShowVerified});

  resetOtp({bool reSet = false});

  mobileNumber();

  resendLoading();

  FocusNode get getPinPutFocus;
}
