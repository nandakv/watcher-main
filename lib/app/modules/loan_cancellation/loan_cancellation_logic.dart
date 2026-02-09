import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/loan_cancellation/widget/loan_cancellation_confirmation_widget.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../api/api_error_mixin.dart';
import '../../api/response_model.dart';
import '../../data/repository/loan_cancellation_repository.dart';
import '../../firebase/analytics.dart';
import '../../models/loan_cancellation_details_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_functions.dart';
import '../../utils/web_engage_constant.dart';
import '../payment/model/loan_breakdown_model.dart';
import '../payment/model/payment_view_model.dart';
import '../payment/payment_view.dart';

enum LoanCancellationStage { loading, info }

class LoanCancellationLogic extends GetxController with ApiErrorMixin {
  LoanCancellationStage _loanCancellationStage = LoanCancellationStage.info;

  LoanCancellationStage get loanCancellationStage => _loanCancellationStage;

  set loanCancellationStage(LoanCancellationStage value) {
    _loanCancellationStage = value;
    update();
  }

  late String LOAN_CANCELLATION_SCREEN = "loan_cancellation";

  final LoanCancellationRepository _loanCancellationRepository =
      LoanCancellationRepository();

  late String loanId;
  late String appFormId;
  var arguments = Get.arguments;
  @override
  void onInit() {
    loanId = arguments['loanId'];
    appFormId = arguments['appFormId'];
    super.onInit();
    _webengageEventonOpen();
  }

  _webengageEventonOpen() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.cancellationPageLoaded,
    );
  }

  _onContinue() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.reconfirmCancellationContinue,
    );
    Get.back();
    _goToCancellationOverview();
  }

  _onGoBack() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.reconfirmCancellationGoBack,
    );
    Get.back();
  }

  _goToCancellationOverview() async {
    loanCancellationStage = LoanCancellationStage.loading;
    LoanCancellationDetailsModel loanDetails = await _loanCancellationRepository
        .getLoanCancellationDetails(loanId: loanId);

    switch (loanDetails.apiResponse.state) {
      case ResponseState.success:
        await onLoanCancellationDetailsFetchSuccess(loanDetails);
        break;
      default:
        handleAPIError(
          loanDetails.apiResponse,
          screenName: LOAN_CANCELLATION_SCREEN,
          retry: _goToCancellationOverview,
        );
        break;
    }
    loanCancellationStage = LoanCancellationStage.info;
  }

  Future<void> onLoanCancellationDetailsFetchSuccess(
      LoanCancellationDetailsModel loanDetails) async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.cancellationDetailsLoaded,
        attributeName: {
          "disbursed_amount": loanDetails.disbursalAmount,
          "interest_accrued": loanDetails.currentInterestAmount,
          "total_payable_amount": loanDetails.totalPayableAmount,
        });
    await PaymentNavigationService().navigate(
      routeArguments: _getLoanCancellationPaymentArgument(loanDetails),
    );
  }

  LoanBreakdownRowData _getBreakdownRowData(String key, num value) {
    return LoanBreakdownRowData(
      key: key,
      value: _parseIntToString(value),
      valueTextStyle: _breakdownValueTextStyle(),
    );
  }

  TextStyle _breakdownValueTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryDarkColor,
    );
  }

  String _parseIntToString(num num) {
    return '₹ ${AppFunctions().parseIntoCommaFormat(num.toString())}';
  }

  _getLoanCancellationPaymentArgument(
      LoanCancellationDetailsModel loanDetails) {
    return PaymentViewArgumentModel(
      loanId: loanId,
      appFormID: appFormId,
      paymentType: PaymentType.loanCancellation,
      breakdownRowData: [
        _getBreakdownRowData(
            "Net Disbursed Amount", loanDetails.disbursalAmount),
        _getBreakdownRowData(
            "Interest Accrued", loanDetails.currentInterestAmount),
      ],
      totalAmoutKey: "Total Payable Amount",
      totalAmountValue: _parseIntToString(loanDetails.totalPayableAmount),
      finalPayableAmount: loanDetails.totalPayableAmount,
      loanCancellationDetails: loanDetails,
    );
  }

  onProceedToCancellationCTA() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.proceedCancellationClicked,
    );
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.reconfirmCancellationLoaded,
    );
    // dialog box for confirmation
    await Get.bottomSheet(LoanCancellationConfirmationWidget(
      onContinue: _onContinue,
      onGoBack: _onGoBack,
    ));
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.reconfirmCancellationClosed,
    );
  }
}
