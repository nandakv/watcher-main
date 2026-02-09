import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/closed_bar.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';

import '../../../res.dart';
import '../../common_widgets/golden_badge.dart';
import '../../firebase/analytics.dart';
import '../../models/loans_model.dart';
import '../../utils/app_functions.dart';
import 'servicing_home_screen_logic.dart';

class ActiveClosedLoans extends StatelessWidget {
  final Loans loans;
  final int index;

  ActiveClosedLoans({Key? key, required this.loans, required this.index})
      : super(key: key);

  final logic = Get.find<ServicingHomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: InkWell(
        onTap: () async {
          _typeOfLoanClicked();
          logic.onClickedArrow(loans: loans);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '₹${AppFunctions().parseIntoCommaFormat(loans.loanAmount)}',
                  style: AppTextStyles.bodyLMedium(
                    color: AppTextColors.primaryNavyBlueHeader,
                  ),
                ),
                HorizontalSpacer(8.w),
                Text(
                  "withdrawn",
                  style: AppTextStyles.bodyXSRegular(
                    color: AppTextColors.neutralBody,
                  ),
                ),
                const Spacer(),
                const SVGIcon(
                  size: SVGIconSize.medium,
                  icon: Res.accordingRight,
                ),
              ],
            ),
            VerticalSpacer(12.h),
            Row(
              children: [
                Text(
                  _computeTimePeriod(),
                  style: AppTextStyles.bodyXSRegular(
                    color: AppTextColors.neutralBody,
                  ),
                ),
                const Spacer(),
                Text(
                  "Loan ID: #${loans.loanId}",
                  style: AppTextStyles.bodyXSMedium(
                    color: AppTextColors.neutralLightDisabled,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _typeOfLoanClicked() {
    loans.active
        ? loanTypeEvents("Active_Withdrawal_Clicked")
        : loanTypeEvents("Closed_Withdrawal_Clicked");
  }

  loanTypeEvents(String eventName) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: eventName,
        attributeName: {
          'active_loan_n': index,
          'loan_amount': loans.loanAmount,
          'reference_id': loans.loanId
        });
  }

  String _computeTimePeriod() {
    return loans.active
        ? 'Next EMI date: ${loans.nextRepayDate}'
        : '${logic.computeMonthsOrDayAgoLoanTaken(loans.loanEndDate, loans.loanTenure)}';
  }
}
