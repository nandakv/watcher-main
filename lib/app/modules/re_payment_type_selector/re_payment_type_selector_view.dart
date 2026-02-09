import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/button.dart';

import '../../../res.dart';
import '../../utils/no_leading_space_formatter.dart';
import 're_payment_type_selector_logic.dart';

class RePaymentTypeSelectorPage extends StatefulWidget {
  RePaymentTypeSelectorPage({Key? key}) : super(key: key);

  @override
  State<RePaymentTypeSelectorPage> createState() =>
      _RePaymentTypeSelectorPageState();
}

class _RePaymentTypeSelectorPageState extends State<RePaymentTypeSelectorPage>
    with AfterLayoutMixin {
  final logic = Get.find<RePaymentTypeSelectorLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<RePaymentTypeSelectorLogic>(builder: (logic) {
            return logic.isPageLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _titleBar(),
                      Divider(
                        color: grey300,
                        height: 0.6.h,
                      ),
                      VerticalSpacer(42.h),
                      _bodyWidget(),
                      const Spacer(),
                      _bottomWidget(),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        _loanBreakDown(),
        _totalDueAmount(),
      ],
    );
  }

  Padding _totalDueAmount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GradientBorderContainer(
        borderRadiusGeometry: _totalDueAmountBorderRadius(),
        color: primarySubtleColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Row(
            children: [
              Text(
                "Total due amount",
                style: AppTextStyles.bodyMMedium(
                    color: AppTextColors.neutralDarkSubtitle),
              ),
              const Spacer(),
              Text(
                AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                    num.parse(logic.loanDetailsModel.totalPendingAmount)),
                style: AppTextStyles.bodyMMedium(
                    color: AppTextColors.neutralDarkSubtitle),
              )
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius _totalDueAmountBorderRadius() {
    return BorderRadius.only(
        bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r));
  }

  Padding _loanBreakDown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: NudgeBadgeWidget(
        csBadge: _overDueBadge(),
        offset: const Offset(5, -3.5),
        child: GradientBorderContainer(
          color: Colors.white,
          borderRadiusGeometry: _loanBreakDownBorderRadius(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalSpacer(8.h),
                _headerWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(
                    color: AppBackgroundColors.neutralLightSubtle,
                    height: 1.h,
                  ),
                ),
                _breakDownDetail("Overdue principal amount",
                    logic.loanDetailsModel.overduePrincipal),
                _breakDownDetail("Overdue interest amount",
                    logic.loanDetailsModel.overdueInterest),
                _breakDownDetail(
                    "Bounce charges", logic.loanDetailsModel.bounceCharges),
                _breakDownDetail(
                    "Late pay penalty charges",
                    (num.parse(logic
                                .loanDetailsModel.latePaymentPenaltyInterest))
                        .toString()),
                if (logic.loanDetailsModel.unappliedAmount.isNotEmpty)
                  _breakDownDetail("Excess amount with us",
                      logic.loanDetailsModel.unappliedAmount,
                      isDeductible: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _loanBreakDownBorderRadius() {
    return BorderRadius.only(
        topRight: Radius.circular(8.r), topLeft: Radius.circular(8.r));
  }

  CSBadge _overDueBadge() {
    return CSBadge(
      text: logic.computeOverdueBadge(),
      showLeadingIcon: false,
      bgColor: red700,
    );
  }

  Widget _breakDownDetail(String title, String value,
      {bool isDeductible = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          const Spacer(),
          Text(
            // Single line change: Conditionally add '-' prefix inside the Text widget
            '${isDeductible ? '- ' : ''}${AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(num.parse(value))}',
            style:
                AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
          )
        ],
      ),
    );
  }

  Row _headerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loanAmountHeader(),
        const Spacer(),
        Text(
          "Loan ID: #${logic.loanDetailsModel.loanId}",
          style: AppTextStyles.bodyXSMedium(
              color: AppTextColors.neutralBody),
        )
      ],
    );
  }

  Column _loanAmountHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
              num.parse(logic.loanDetailsModel.loanAmount)),
          style: AppTextStyles.bodyLMedium(
              color: AppTextColors.primaryNavyBlueHeader),
        ),
        Text(
          "Withdrawn on ${formatDateFromString(logic.loanDetailsModel.loanStartDate)}",
          style: AppTextStyles.bodyXSRegular(color: AppTextColors.neutralBody),
        ),
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

  Padding _bottomWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          _infoText(),
          VerticalSpacer(24.h),
          _payButton(),
          VerticalSpacer(23.h),
          InkWell(
            onTap: logic.onPayPartialClicked,
            child: Text(
              "Pay partially",
              style: AppTextStyles.bodyLSemiBold(color: blue1600),
            ),
          ),
          VerticalSpacer(30.h),
        ],
      ),
    );
  }

  Row _infoText() {
    return Row(
      children: [
        SvgPicture.asset(Res.overDueAlertBulb),
        HorizontalSpacer(12.w),
        Flexible(
          child: Text(
            "Pay now to stop accruing late fees and protect your credit profile",
            style: AppTextStyles.bodyXSMedium(
                color: AppTextColors.primaryNavyBlueHeader),
          ),
        )
      ],
    );
  }

  Widget _payButton() {
    return GetBuilder<RePaymentTypeSelectorLogic>(
      id: logic.PAY_NOW_BUTTON,
      builder: (logic) {
        return Button(
          buttonSize: ButtonSize.large,
          buttonType: ButtonType.primary,
          isLoading: logic.isButtonLoading,
          onPressed: logic.onFullRepayment,
          enabled: !logic.isButtonLoading,
          title:
              "Pay ${AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(num.parse(logic.loanDetailsModel.totalPendingAmount))}",
        );
      },
    );
  }

  SizedBox _titleBar() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
        child: Row(
          children: [
            InkWell(
              child: SvgPicture.asset(Res.arrowBack),
              onTap: () {
                Get.back();
              },
            ),
            HorizontalSpacer(16.w),
            Text(
              "Overdue",
              style: AppTextStyles.headingSMedium(color: blue1600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onInitial();
  }
}
