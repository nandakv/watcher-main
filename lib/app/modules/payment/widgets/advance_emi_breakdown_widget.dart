import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';

class AdvanceEmiBreakdownWidget extends StatelessWidget {
  LoanDetailsModel loanDetailsModel;
  LoanBreakdownModel breakdownModel;

  AdvanceEmiBreakdownWidget(
      {super.key,
      required this.loanDetailsModel,
      required this.breakdownModel});

  @override
  Widget build(BuildContext context) {
    return NudgeBadgeWidget(
      csBadge: CSBadge(
        text: computeNudgeText(),
        bgColor: blue1200,
        showLeadingIcon: false,
        textColor: Colors.white,
      ),
      offset: const Offset(5, -3.5),
      child: GradientBorderContainer(
        borderRadiusGeometry: BorderRadius.circular(8.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    VerticalSpacer(10.h),
                    _loanAmountDetails(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Divider(
                        height: 1.h,
                        thickness: 1.h,
                        color: AppBackgroundColors.neutralLightSubtle,
                      ),
                    ),
                    ...breakdownModel.breakdownRowData
                        .map((e) => _breakdownTile(rowData: e))
                        .toList(),
                  ],
                ),
              ),
              if (breakdownModel.bottomWidget != null)
                Container(
                  padding: EdgeInsets.only(top: 0.6.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff8FD1EC),
                        Color(0xff229ACE),
                      ],
                    ),
                  ),
                  child: Container(
                    color: AppBackgroundColors.primarySubtle,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: breakdownModel.bottomWidget!,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loanAmountDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextWidget(infoList: [
          RichTextModel(
              text:
                  "₹${AppFunctions().parseIntoCommaFormat(loanDetailsModel.loanAmount)}",
              textStyle: AppTextStyles.bodyLMedium(
                  color: AppTextColors.primaryNavyBlueHeader)),
          RichTextModel(
              text:
                  "\nWithdrawn on ${formatDateFromString(loanDetailsModel.loanStartDate)}",
              textStyle: AppTextStyles.bodyXSRegular(
                  color: AppTextColors.neutralBody)),
        ]),
        const Spacer(),
        Text(
          "Loan ID: #${loanDetailsModel.loanId}",
          style: AppTextStyles.bodyXSMedium(
              color: AppTextColors.neutralBody),
        )
      ],
    );
  }

  String formatDateFromString(String dateString) {
    final parsedDate = DateTime.parse(dateString); // assumes 'yyyy-MM-dd'
    final day = DateFormat('d').format(parsedDate); // e.g. 10
    final month = DateFormat('MMM').format(parsedDate); // e.g. Mar
    final year = DateFormat("yy").format(parsedDate); // e.g. 24
    return "$day $month ‘$year";
  }

  computeNudgeText() {
    DateTime parsedDate = DateTime.parse(loanDetailsModel.nextDueDate);
    String formattedDate = DateFormat("d MMM ''yy").format(parsedDate);
    return "Due Date: $formattedDate";
  }

  Widget _breakdownTile({required LoanBreakdownRowData rowData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              rowData.key,
              style:
                  AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              rowData.value,
              style: AppTextStyles.bodySMedium(
                  color: AppTextColors.neutralDarkBody),
              textAlign: TextAlign.right,
            ),
          ),
          if (rowData.suffixWidget != null)
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: rowData.suffixWidget!,
            ),
        ],
      ),
    );
  }
}
