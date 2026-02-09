import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/overdue_details_bottom_sheet.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/loans_model.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/home_page_alert_widget_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';

class HomePageOverDueCard extends StatelessWidget {
  const HomePageOverDueCard({
    Key? key,
    required this.overDueLoans,
    required this.lpcCard,
  }) : super(key: key);

  final List<Loans> overDueLoans;
  final LpcCard lpcCard;

  HomePageWithdrawalAlertLogic get logic =>
      Get.find<HomePageWithdrawalAlertLogic>(
        tag: lpcCard.appFormId,
      );

  @override
  Widget build(BuildContext context) {
    return _onSuccess();
  }

  Container _onSuccess() {
    return Container(
      color: navyBlueColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_overdueAlertHeader(), _referenceId()],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 100, top: 10),
            child: Text(
              "Pay now to stop accruing late fees and protect your credit profile.",
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.1,
                color: const Color(0xFFFFF3EB),
              ),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GradientButton(
              onPressed: () {
                logic.onOverDuePayClicked();
              },
              buttonTheme: AppButtonTheme.light,
              title: _hasSingleOverDueLoan()
                  ? "Pay ₹ ${_getPayableAmount()}"
                  : "Pay now",
            ),
          ),
          _hasSingleOverDueLoan()
              ? _overDueLoanDetailsRichText()
              : const SizedBox()
        ],
      ),
    );
  }

  String _getPayableAmount() {
    return AppFunctions()
        .parseIntoCommaFormat(overDueLoanDetails.totalPendingAmount);
  }

  Column _referenceId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Reference ID: #${overDueLoans.first.loanId}",
          style: const TextStyle(
              color: lightGrayColor, fontSize: 8, fontWeight: FontWeight.w400),
        ),
        if (!_hasSingleOverDueLoan()) ...[
          Text(
            "+${logic.customerLoansModel.overdueLoans.length - 1} more",
            style: const TextStyle(
                color: lightGrayColor,
                fontSize: 8,
                fontWeight: FontWeight.w400),
          ),
        ]
      ],
    );
  }

  bool _hasSingleOverDueLoan() => overDueLoans.length <= 1;

  String _computeOtherCharges() {
    var value = double.parse(overDueLoanDetails.overdueInterest) +
        double.parse(overDueLoanDetails.bounceCharges) +
        double.parse(overDueLoanDetails.latePaymentPenaltyInterest);
    return AppFunctions().parseIntoCommaFormat(value.toString());
  }

  LoanDetailsModel get overDueLoanDetails => logic.overDueLoanDetailsModel;

  RichText _overDueLoanDetailsRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                "EMI: ₹${AppFunctions().parseIntoCommaFormat(overDueLoanDetails.overduePrincipal)} + Other charges: ₹${_computeOtherCharges()} ",
            style: const TextStyle(
              color: lightGrayColor,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: "know more",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.bottomSheet(
                  OverDueDetailsBottomSheet(
                    loanDetailsModel: overDueLoanDetails,
                    referenceId: overDueLoanDetails.loanId,
                  ),
                  isScrollControlled: true,
                );
              },
            style: const TextStyle(
                color: skyBlueColor,
                fontSize: 8,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline),
          )
        ],
      ),
    );
  }

  RichText _overdueAlertHeader() {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _exclamatoryIcon(),
          ),
          TextSpan(
            text: "Overdue alert",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: const Color(0xFFFFF0EB),
            ),
          ),
        ],
      ),
    );
  }

  Padding _exclamatoryIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFFF0EB),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Text(
          "!",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: const Color(0xFF1D478C),
          ),
        ),
      ),
    );
  }
}
