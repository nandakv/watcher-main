import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/otp/bottom_sheet_otp_logic.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import 'bottom_sheet_otp_interface.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_theme.dart';

class OTPTextFieldWidget extends StatelessWidget {
  final BottomSheetOTPHandler bottomSheetOTPHandler;
  OTPTextFieldWidget(
      {Key? key,
        required this.bottomSheetOTPHandler,
      })
      : super(key: key);

  final logic= Get.put(BottomSheetOTPLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width,
          height: 50.h,
          child: Pinput(
            length: 6,
            onChanged: (_) {
              logic.onOTPChange(bottomSheetOTPHandler);
            },
            defaultPinTheme: _otpTextFieldTheme(),
            focusNode: bottomSheetOTPHandler.getPinPutFocus,
            controller:logic.pinPutController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            useNativeKeyboard: true,
            autofocus: Platform.isIOS,
           // validator:(val)=>logic.errorText,
            smsRetriever: logic.smsRetrieverImpl,
          ),
        ),
        if (logic.errorText.isNotEmpty) ...[
           SizedBox(
            height: 4.h,
          ),
          GetBuilder<BottomSheetOTPLogic>(
              id: 'error',
              builder: (logic) {
                return Text(
                  logic.errorText,
                  style: errorRichTextStyle,
                );
              })
        ],
      ],
    );
  }

  PinTheme _otpTextFieldTheme() {
    return PinTheme(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1.w,
              color: logic.errorText.isEmpty
                  ? secondaryDarkColor
                  : const Color(0xffE35959)),
        ),
      ),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(right: 20.w),
        textStyle:AppTextStyles.headingMedium(color: primaryDarkColor),
    );
  }
}

