import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_theme.dart';
import '../sign_in_screen_logic.dart';

class OTPTextField extends StatelessWidget {
  OTPTextField({Key? key}) : super(key: key);

  late final SmsRetrieverImpl smsRetrieverImpl;
  final logic = Get.find<SignInScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInScreenLogic>(
        id: logic.OTP_PINPUT,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width,
                height: 50,
                child: Pinput(
                  length: 6,

                  onChanged: (value) {
                    logic.onConfirmPinSubmitted();
                  },
                  defaultPinTheme: _otpTextFieldTheme(),
                  focusNode: logic.pinPutFocusNode,
                  controller: logic.pinPutController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  useNativeKeyboard: true,
                  autofocus: Platform.isIOS,
                  smsRetriever: logic.smsRetrieverImpl,
                ),
              ),
              if (logic.otpErrorText.isNotEmpty) ...[
                const SizedBox(
                  height: 4,
                ),
                Text(
                  logic.otpErrorText,
                  style: errorRichTextStyle,
                )
              ],
            ],
          );
        });
  }

  PinTheme _otpTextFieldTheme() {
    return PinTheme(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: logic.otpErrorText.isEmpty
                      ? secondaryDarkColor
                      : const Color(0xffE35959)),
          ),
      ),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(right: 20,bottom: 0),
      textStyle: const TextStyle(
        color: primaryDarkColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.data != null && res.data!.code != null) {
      return res.data!.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
