import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

import '../../../../res.dart';
import '../../../common_widgets/radio_selection_widget.dart';

class CreditScoreFeedbackBottomSheet extends StatelessWidget {
  CreditScoreFeedbackBottomSheet({super.key});

  CreditReportLogic logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditReportLogic>(
        id: logic.CREDIT_REPORT_FEEDBACK_ID,
        builder: (context) {
          return SingleChildScrollView(
            child: BottomSheetWidget(
              childPadding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 32.h,
              ),
              backgroundImage: logic.creditReportFeedbackState ==
                      CreditReportFeedbackState.thankYou
                  ? Res.creditScoreConfetti
                  : null,
              child: _computeWidget(),
            ),
          );
        });
  }

  Widget _computeWidget() {
    switch (logic.creditReportFeedbackState) {
      case CreditReportFeedbackState.feedback:
        return _feedbackWidget();
      case CreditReportFeedbackState.thankYou:
        return _thankYouWidget();
    }
  }

  Widget _feedbackWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget("It looks like you've chosen not to proceed right now"),
        VerticalSpacer(24.h),
        Text(
          "Please tell us what went wrong",
          style: AppTextStyles.bodyMMedium(color: AppTextColors.brandBlueTitle),
        ),
        VerticalSpacer(16.h),
        _feedbackSection(),
        VerticalSpacer(32.h),
        _button(),
      ],
    );
  }

  Widget _feedbackSection() {
    return GetBuilder<CreditReportLogic>(
        id: logic.FEEDBACK_OPTIONS_ID,
        builder: (logic) {
          return Column(
            children: [
              _feedbackOptionsWidget(),
              if (logic.selectedFeedbackOption == logic.FEEDBACK_OTHERS) ...[
                VerticalSpacer(16.h),
                _otherFeedbackTextField()
              ],
            ],
          );
        });
  }

  Widget _otherFeedbackTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 2,
      minLines: 2,
      maxLength: 100,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryDarkColor,
      ),
      onChanged: (_) => logic.validateFeedback(),
      validator: logic.validateReason,
      controller: logic.feedbackController,
      decoration: _reasonDescriptionDecoration(),
    );
  }

  InputDecoration _reasonDescriptionDecoration() {
    return InputDecoration(
        hintText: "Type here",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        hintStyle: const TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w400));
  }

  Widget _feedbackOptionsWidget() {
    return RadioSelectionWidget(
      radioList: logic.feedbackOptions,
      selectedValue: logic.selectedFeedbackOption,
      onChanged: logic.onFeedbackSelectionChanged,
    );
  }

  Widget _button() {
    return GetBuilder<CreditReportLogic>(
        id: logic.FEEDBACK_SUBMIT_BUTTON_ID,
        builder: (logic) {
          return Center(
            child: Button(
              buttonSize: ButtonSize.large,
              buttonType: ButtonType.primary,
              title: "Submit",
              enabled: logic.isFeedbackSubmitButtonEnabled,
              onPressed: logic.onFeedbackSubmitClicked,
            ),
          );
        });
  }

  Widget _titleWidget(String text) {
    return Text(text,
        style: AppTextStyles.headingSMedium(color: AppBorderColors.brandBlue));
  }

  Widget _messageWidget(String message) {
    return Text(
      message,
      style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
      textAlign: TextAlign.center,
    );
  }

  Widget _thankYouWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Res.checkCircle,
            colorFilter: const ColorFilter.mode(green500, BlendMode.srcIn),
            height: 80.h,
            width: 80.h,
          ),
          VerticalSpacer(12.h),
          _titleWidget("Thank you for your feedback"),
          VerticalSpacer(8.h),
          _messageWidget(
              "We appreciate your input! Every suggestion helps us create a better experience for you")
        ],
      ),
    );
  }
}
