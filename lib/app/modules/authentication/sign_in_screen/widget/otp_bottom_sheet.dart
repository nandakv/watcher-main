import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/otp_resend_widget/otp_resend_widget_view.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/otp_text_field.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class OtpBottomSheet extends StatelessWidget {
  final logic = Get.find<SignInScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "One Time Password (OTP)",
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkBlueColor),
          ),
          verticalSpacer(8),
          _verifyOtp(),
          verticalSpacer(16),
          OTPTextField(),
          verticalSpacer(8),
          Visibility(
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            visible: !logic.showVerfied && !logic.isButtonLoading,
            child: Align(
                alignment: Alignment.centerLeft,
                child: _resendButtonWidget()),
          ),
          Align(
            alignment: Alignment.center,
            child: GetBuilder<SignInScreenLogic>(
                id: logic.OTP_BUTTON,
                builder: (logic) {
                  return logic.showVerfied ? _verfied() : _verifyCta(logic);
                }),
          ),
        ],
      ),
    );
  }

  Center _verifyCta(SignInScreenLogic logic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 102),
        child: GradientButton(
          onPressed: () {},
          buttonTheme: AppButtonTheme.dark,
          title: "Verify",
          isLoading: logic.isButtonLoading,
          enabled: logic.isPinSet,
        ),
      ),
    );
  }

  Padding _verfied() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 102),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Res.checkCircle),
          const SizedBox(
            width: 4,
          ),
          const Text(
            "Verified",
            style: TextStyle(
                color: greenColor, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Row _verifyOtp() {
    return Row(
      children: [
        Text(
          "Verify with OTP sent to +91 ${logic.mobileNoController.text} ",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: secondaryDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        InkWell(
          onTap: logic.onEditPhoneNo,
          child: const Text(" edit",
              style: TextStyle(
                  color: Color(0xff5BC4F0),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: 0.12)),
        )
      ],
    );
  }

  Widget _resendButtonWidget() {
    return GetBuilder<SignInScreenLogic>(
      id: 'resend',
      builder: (logic) {
        return OtpResendWidget(
          isResendLoading: logic.isResendLoading,
          color: const Color(0xff5BC4F0),
          alignment: Alignment.centerLeft,
          buttonTheme: AppButtonTheme.dark,
          buttonPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
          onResendPressed: logic.resendOTP,
        );
      },
    );
  }

  Widget _mobileNoEditTextWidget() {
    return Row(
      children: [
        Text(
          "OTP sent to +91 ${logic.mobileNoController.text}",
          style: const TextStyle(
            fontSize: 12,
            color: secondaryDarkColor,
            letterSpacing: 0.14,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
