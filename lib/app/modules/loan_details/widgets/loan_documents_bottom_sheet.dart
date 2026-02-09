import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/pill_button.dart';
import 'package:privo/app/modules/loan_details/loan_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class LoanDocumentsBottomSheet extends StatelessWidget {
  LoanDocumentsBottomSheet({super.key});

  final logic = Get.find<LoanDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      childPadding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Loan documents",
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueBodyFocus),
          ),
          VerticalSpacer(16.h),
          Row(
            children: [
              PillButton(
                text: "Sanction letter",
                onTap: logic.onSanctionLetterTapped,
                leading: Res.download,
                isSelected: false,
              ),
              HorizontalSpacer(16.w),
              PillButton(
                text: "Agreement letter",
                onTap: logic.onAgreementLetter,
                isSelected: false,
                leading: Res.download,
              ),
            ],
          ),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }
}
