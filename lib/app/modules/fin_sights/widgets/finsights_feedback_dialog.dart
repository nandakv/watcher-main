import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/common_feedback_selector.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/components/button.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/theme/app_colors.dart';

class FinsightsExitBottomSheet extends StatelessWidget {

  final String title;
  final List<String> selectionFeedbackOptions;
  const FinsightsExitBottomSheet({super.key,required this.title, required this.selectionFeedbackOptions});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinSightsLogic>(
      builder: (controller) {
        return BottomSheetWidget(
          onCloseClicked: () => Get.back(),
          childPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSpacer(16.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingSMedium(
                    color: AppTextColors.brandBlueTitle),
              ),
              VerticalSpacer(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please tell us what went wrong",
                    style: AppTextStyles.bodyMMedium(color: AppTextColors.brandBlueTitle),
                  ),
                ),
              ),
              VerticalSpacer(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CommonFeedbackSelector(
                  feedbackOptions: selectionFeedbackOptions,
                  selectedOptionIndex: controller.selectedOptionIndex,
                  onOptionSelected: controller.onOptionSelected,
                  showTextField: controller.showTextField,
                  textEditingController: controller.otherFeedbackController,
                ),
              ),
              VerticalSpacer(16.h),
              Button(
                title: "Submit",
                buttonSize: ButtonSize.large,
                buttonType: ButtonType.primary,
                enabled: controller.isSubmitEnabled,
                onPressed: controller.submitFeedback,
              ),
              VerticalSpacer(32.h),
            ],
          ),
        );
      },
    );
  }
}
