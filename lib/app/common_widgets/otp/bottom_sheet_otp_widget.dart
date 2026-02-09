import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/otp/bottom_sheet_otp_logic.dart';
import 'package:privo/app/common_widgets/otp/bottom_sheet_otp_interface.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import '../../../components/button.dart';
import '../gradient_button.dart';
import '../otp_resend_widget/otp_resend_widget_view.dart';
import 'otp_text_field_widget.dart';

class BottomSheetOTPWidget extends StatefulWidget {
  final BottomSheetOTPHandler bottomSheetOTPHandler;
  final OTPHeaderType headerType ;

  BottomSheetOTPWidget({
    super.key,
    required this.bottomSheetOTPHandler,
    required this.headerType,
  });

  @override
  State<BottomSheetOTPWidget> createState() => _BottomSheetOTPWidgetState();
}

class _BottomSheetOTPWidgetState extends State<BottomSheetOTPWidget> {
  final logic = Get.put(BottomSheetOTPLogic());

  @override
  void dispose() {
    super.dispose();
    Get.delete<BottomSheetOTPLogic>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0.w),
      child: Wrap(
        children: [
          _computeOTPHeader(),
          GetBuilder<BottomSheetOTPLogic>(id:'pinPut',
            builder: (logic) {
              return OTPTextFieldWidget(
                  bottomSheetOTPHandler: widget.bottomSheetOTPHandler);
            }
          ),
          verticalSpacer(8),
          GetBuilder<BottomSheetOTPLogic>(id:'resend',
            builder: (logic){
              return Visibility(
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                visible: logic.resendWidgetVisible(),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: _resendButtonWidget()),
              );

            }
            ,
          ),
          GetBuilder<BottomSheetOTPLogic>(id:"otp_button",
            builder: (logic) {
              return Align(
                alignment: Alignment.center,
                child:logic.showVerified?_verified():_verifyCta(),
              );
            }
          ),
        ],
      ),
    );
  }

  //refactor the OTP screen UI based on a design that might be updated later in Figma,
  Column otpHeaderWidget() {
    return Column(
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
        _verifyOtp(
            text:
                "Verify with OTP sent to +91 ${widget.bottomSheetOTPHandler.mobileNumber()} ",
            editText: " edit"),
        verticalSpacer(16),
          ],
        );
  }

  Column maskedOtpHeaderWidget() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Verify your mobile number",
                  style: AppTextStyles.headingSMedium(color: darkBlueColor),
                ),
            verticalSpacer(8.h),
                Text(
                  "We found multiple numbers linked to your credit report. Select one and verify with OTP",
                 textAlign: TextAlign.center,
                  style: AppTextStyles.bodySRegular(color: primaryDarkColor),
                ),
                verticalSpacer(24.h),
              ],
            ),
        _verifyOtp(
            text:
                "OTP sent to +91 ${widget.bottomSheetOTPHandler.mobileNumber()} ",
            editText: logic.showVerified ? "" : " change"),
      ],
    );
  }

  Widget _computeOTPHeader() {
    if (widget.headerType == OTPHeaderType.maskedOtp) {
      return GetBuilder<BottomSheetOTPLogic>(
        id: 'edit_id',
        builder: (context) {
          return maskedOtpHeaderWidget();
        },
      );
    }
    return otpHeaderWidget();
  }

  GetBuilder _verifyCta() {
    return GetBuilder<BottomSheetOTPLogic>(
        id: "otp_button",
        builder: (logic) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Button(
                buttonSize: ButtonSize.large,
                buttonType: ButtonType.primary,
                title: logic.showRetry ? "Retry" : "Verify",
                onPressed: () {
                  if (logic.showRetry &&
                      widget.headerType == OTPHeaderType.maskedOtp) {
                    widget.bottomSheetOTPHandler.onEditClick();
                    logic.clearOTPPage();
                    logic.pinSet=false;
                  }
                },
                isLoading: logic.isButtonLoading(),
                enabled: logic.pinSet,
              ),
            ),
          );
        });
  }

  Padding _verified() {
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

  Row _verifyOtp({required String text,required String editText}) {
    return Row(
      children: [
        Text(
         text,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
        ),
        InkWell(
          onTap: () {
            widget.bottomSheetOTPHandler.onEditClick();
            logic.clearOTPPage();
            logic.pinSet=false;
          },
          child:  Text( editText,
              style: AppTextStyles.bodySRegular(color: skyBlueColor)),
        )
      ],
    );
  }

  Widget _resendButtonWidget() {
    return OtpResendWidget(
      isResendLoading: widget.bottomSheetOTPHandler.resendLoading(),
      color: const Color(0xff5BC4F0),
      alignment: Alignment.centerLeft,
      buttonTheme: AppButtonTheme.dark,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      onResendPressed: widget.bottomSheetOTPHandler.resetOtp,
    );
  }
}
