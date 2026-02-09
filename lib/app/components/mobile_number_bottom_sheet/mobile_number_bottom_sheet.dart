import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/mobile_number_bottom_sheet/mobile_number_bottom_sheet_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

class MobileNumberBottomSheet extends StatefulWidget {
  String flowType;
  MobileNumberBottomSheet({
    required this.flowType,
    Key? key,
  }) : super(key: key);

  @override
  State<MobileNumberBottomSheet> createState() => _MobileNumberBottomSheetState();
}

class _MobileNumberBottomSheetState extends State<MobileNumberBottomSheet> with AfterLayoutMixin {
  final logic = Get.put(MobileNumberBottomSheetLogic());

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
        onCloseClicked: () {
          logic.computeCloseButtonEvents(flowType: widget.flowType);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer(16.h),
          Text(
            "Mobile Number",
            style: AppTextStyles.headingSMedium(
              color: AppTextColors.primaryNavyBlueHeader,
            ),
          ),
          VerticalSpacer(4.h),
          Text(
            "Ensure this number is linked to your bank account for verification",
            style: AppTextStyles.bodySMedium(
              color: AppTextColors.neutralBody,
            ),
          ),
          VerticalSpacer(24.h),
          PrivoTextFormField(
            controller: logic.mobileNumberController,
            style: AppTextStyles.bodyMMedium(
              color: AppTextColors.neutralDarkBody,
            ),
            decoration: InputDecoration(
              prefix: Text(
                "+91 ",
                style: AppTextStyles.bodyMMedium(
                  color: AppTextColors.neutralDarkBody,
                ),
              ),
              counter: const SizedBox.shrink(),
            ),
            onChanged: (_) => logic.onMobileNumberChanged(),
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: logic.validateMobileNumber,
            id: 'PRIVO_MOBILE_FIELD_ID',
          ),
          VerticalSpacer(40.h),
          Center(
            child: GetBuilder<MobileNumberBottomSheetLogic>(id: logic.MOBILE_NUMBER_CTA,
              builder: (logic) {
                return Button(
                  enabled: logic.isMobileNumberCTAEnabled,
                  buttonSize: ButtonSize.medium,
                  buttonType: ButtonType.primary,
                  onPressed: () {
                    Get.back(result: logic.mobileNumberController.text);
                    logic.isMobileNumberEditingEvents(flowType:widget.flowType );
                  },
                  title: "Continue",
                );
              },
            ),
          ),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    return logic.onAfterLayout();
  }
}
