import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/refree_widget/refree_bottom_sheet_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class RefreeBottomSheet extends StatefulWidget {
  final String referralCode;

  RefreeBottomSheet({super.key, required this.referralCode});

  @override
  State<RefreeBottomSheet> createState() => _RefreeBottomSheetState();
}

class _RefreeBottomSheetState extends State<RefreeBottomSheet>
    with AfterLayoutMixin {
  final logic = Get.put(RefreeBottomSheetLogic());

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: false,
      child: SingleChildScrollView(
        child: GetBuilder<RefreeBottomSheetLogic>(builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSpacer(24.h),
              ...widget.referralCode.isEmpty
                  ? _onReferralCodeNotExists()
                  : _onReferralCodeExists(),
              VerticalSpacer(24.h),
              _pinPut(),
              if (logic.otpErrorText.isNotEmpty) ...[
                VerticalSpacer(8.h),
                Text(
                  logic.otpErrorText,
                  style: errorRichTextStyle,
                )
              ],
              VerticalSpacer(48.h),
              _button(),
              VerticalSpacer(31.h),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _onReferralCodeExists() {
    return [
      SvgPicture.asset(Res.referralCode),
      VerticalSpacer(16.h),
      Text(
        "You're almost in!",
        style: AppTextStyles.bodyLMedium(color: AppTextColors.brandBlueTitle),
      ),
      VerticalSpacer(16.h),
      Text(
        "We've applied the referral code from your invite link",
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
      ),
    ];
  }

  List<Widget> _onReferralCodeNotExists() {
    return [
      SvgPicture.asset(Res.referralCode),
      VerticalSpacer(16.h),
      Text(
        "Got a referral code?",
        style:
        AppTextStyles.headingSMedium(color: AppTextColors.brandBlueTitle),
      ),
      Text(
        "Adding one gives you access to exclusive features",
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
      ),
    ];
  }

  Row _button() {
    return Row(
      mainAxisAlignment: widget.referralCode.isNotEmpty
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (widget.referralCode.isEmpty)
          Button(
            buttonSize: ButtonSize.modifiedMedium,
            buttonType: ButtonType.secondary,
            title: "Skip",
            height: 40.h,
            onPressed: logic.onSkipPressed,
          ),
        GetBuilder<RefreeBottomSheetLogic>(
            builder: (logic) {
              return Button(
                buttonSize: ButtonSize.modifiedMedium,
                buttonType: ButtonType.primary,
                isLoading: logic.isButtonLoading,
                enabled: logic.isPinSet,
                title: widget.referralCode.isNotEmpty ? "Continue" : "Submit",
                height: 40.h,
                onPressed: logic.onContinuePressed,
              );
            }),
      ],
    );
  }

  Widget _pinPut() {
    return SizedBox(
      width: Get.width,
      height: 50,
      child: IgnorePointer(
        ignoring: logic.isButtonLoading,
        child: Pinput(
          length: 5,
          onChanged: (value) {
            logic.onConfirmPinSubmitted(value);
          },
          defaultPinTheme: _otpTextFieldTheme(),
          focusNode: logic.pinPutFocusNode,
          textCapitalization: TextCapitalization.characters,
          enabled: !widget.referralCode.isNotEmpty,
          controller: logic.pinPutController,
          keyboardType: TextInputType.text,
          useNativeKeyboard: true,
          autofocus: Platform.isIOS,
        ),
      ),
    );
  }

  PinTheme _otpTextFieldTheme() {
    return PinTheme(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1,
              color: logic.otpErrorText.isEmpty
                  ? AppBorderColors.neutral
                  : const Color(0xffE35959)),
        ),
      ),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(right: 20.w, bottom: 0),
      textStyle: const TextStyle(
        color: primaryDarkColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(widget.referralCode);
  }
}
