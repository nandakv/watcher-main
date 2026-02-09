import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

class LoanDetailsBaseWidget extends StatelessWidget {
  LoanDetailsBaseWidget(
      {super.key,
      required this.loanDetailsModel,
      required this.index,
      required this.loanSpecificInfoWidget});

  LoanDetailsModel loanDetailsModel;
  int index;
  Widget loanSpecificInfoWidget;

  final logic = Get.find<PaymentLoansListLogic>();

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer(16.h),
            _loanAmountDetails(loanDetailsModel),
            // Assuming this is a common widget/method
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                color: AppBackgroundColors.neutralLightSubtle,
                height: 0.6.h,
              ),
            ),
            Row(
              children: [
                loanSpecificInfoWidget, // Use the passed widget here
                const Spacer(),
                Button(
                  buttonSize: ButtonSize.small,
                  buttonType: ButtonType.primary,
                  title: "Pay now",
                  onPressed: () {
                    logic.onPayNowClicked(loanDetailsModel, index);
                  },
                ),
              ],
            ),
            // Center(
            //   child: _knowMoreRichText(loanDetailsModel, index), // If this is also common, keep it, otherwise pass as param or handle differently
            // ),
          ],
        ),
      ),
    );
  }

  Widget _loanAmountDetails(LoanDetailsModel loanDetailsModel) {
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
}
