import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/otp_resend_widget/otp_resend_widget_view.dart';
import 'package:privo/app/theme/app_text_theme.dart';

import '../../../firebase/analytics.dart';
import '../../../utils/web_engage_constant.dart';
import 'verify_otp_logic.dart';

class VerifyOTPPage extends StatefulWidget {
  final String? title;

  const VerifyOTPPage({Key? key, this.title}) : super(key: key);

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final logic = Get.find<VerifyOTPLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPress,
      child: Scaffold(
        body: BlueBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    "Enter your OTP",
                    style: signUpHeadingTextStyle,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  _MobileNumberText(),
                  const SizedBox(
                    height: 20,
                  ),
                  const _OTPTextField(),
                  const SizedBox(
                    height: 50,
                  ),
                  GetBuilder<VerifyOTPLogic>(
                    id: logic.PIN_SET_KEY,
                    builder: (logic) {
                      return GradientButton(
                        onPressed: logic.onConfirmPinSubmitted,
                        isLoading: logic.isLoading,
                        buttonTheme: AppButtonTheme.light,
                        title: "Verify OTP",
                        enabled: logic.isPinSet,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const _ResendButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNumberText extends StatelessWidget {
  _MobileNumberText({Key? key}) : super(key: key);

  final logic = Get.find<VerifyOTPLogic>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "Sent to ${logic.arguments[logic.MOBILE_NUMBER_KEY]}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.white,
              letterSpacing: 0.14,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () async {
            if (await logic.onBackPress()) Get.back();
            await AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: WebEngageConstants.editNumberCTA);
          },
          child: const Text(" (Edit)",
              style: TextStyle(
                  color: Color(0xff8AD2EE),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  letterSpacing: 0.12)),
        ),
      ],
    );
  }
}

class _OTPTextField extends StatelessWidget {
  const _OTPTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyOTPLogic>(
        id: 'pinput',
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
                  // androidSmsAutofillMethod:
                  //     AndroidSmsAutofillMethod.smsUserConsentApi,
                ),
              ),
              if (logic.errorText.isNotEmpty) ...[
                const SizedBox(
                  height: 8,
                ),
                Text(
                  logic.errorText,
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
        color: const Color(0xff385789).withOpacity(0.31),
      ),
      textStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyOTPLogic>(
      id: 'resend',
      builder: (controller) {
        return OtpResendWidget(
          isResendLoading: controller.isResendLoading,
          color: Colors.white,
          onResendPressed: () async {
            await controller.reset();
            AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: WebEngageConstants.resendOTP);
          },
        );
      },
    );
  }
}
