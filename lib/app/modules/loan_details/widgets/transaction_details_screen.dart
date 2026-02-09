import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/widgets/loan_breakdown_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../payment/model/transaction_details_model.dart';
import '../../payment/widgets/payment_details_top_widget.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionDetailsModel transactionDetailsModel;
  const TransactionDetailsScreen(
      {Key? key, required this.transactionDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopNavigationBar(
                title: "",
                enableShadow: true,
              ),
              verticalSpacer(96.h),
              SvgPicture.asset(
                Res.successTransaction,
                height: 100.h,
                width: 100.w,
              ),
              verticalSpacer(8.h),
              Text(
                transactionDetailsModel.amount,
                style: AppTextStyles.headingXLSemiBold(color: navyBlueColor),
              ),
              verticalSpacer(4.h),
              Text(
                "Payment successful!",
                style: AppTextStyles.bodySMedium(color: secondaryDarkColor),
              ),
              verticalSpacer(48.h),
              //_bottomWidget(),
              loanIdWithPaymentTime()
            ],
          ),
        ),
      ),
    );
  }

  Widget loanIdWithPaymentTime() {
    return Padding(
      padding: EdgeInsets.only(left: 26.w, right: 22.w),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: primarySubtleColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: preRegistrationEnabledGradientColor2, width: 0.6)),
        child: Column(
          children: [_loanID(), verticalSpacer(8.h), _paymentTime()],
        ),
      ),
    );
  }

  Widget _loanID() {
    return Row(
      children: [
        Text("Loan ID",
            style: AppTextStyles.bodySRegular(color: primaryDarkColor)),
        const Spacer(),
        Text(
          transactionDetailsModel.refId,
          style: AppTextStyles.bodySRegular(color: primaryDarkColor),
        )
      ],
    );
  }

  Widget _paymentTime() {
    return Row(
      children: [
        Text("Payment time",
            style: AppTextStyles.bodySRegular(color: primaryDarkColor)),
        const Spacer(),
        Text(
          transactionDetailsModel.transactionDate,
          style: AppTextStyles.bodySRegular(color: primaryDarkColor),
        )
      ],
    );
  }
}
