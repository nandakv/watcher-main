import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/re_payment_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/razorpay_order_model.dart';
import 'package:privo/app/modules/payment/model/payment_success_model.dart';
import 'package:privo/app/modules/payment/widgets/payment_retry_dialog.dart';
import 'package:privo/app/modules/re_payment_result/re_payment_result_model.dart';
import 'package:privo/app/modules/re_payment_type_selector/re_payment_type_selector_analytics.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../flavors.dart';
import '../../api/api_error_mixin.dart';
import '../../models/pending_loan_details.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_functions.dart';
import 'widgets/pay_partially_bottom_sheet.dart';

enum RePaymentType { fullPayment, partialPayment }

class RePaymentTypeSelectorLogic extends GetxController
    with ApiErrorMixin, RePaymentTypeSelectorAnalytics {
  late String PAYMENT_GATEWAY_SCREEN = "payment_gateway_screen";
  static const String INCORRECT_PIN = "incorrect_pin";
  static const String INSUFFICIENT_FUNDS = "insufficient_funds";
  static const String PAYMENT_FAILED = "payment_failed";

  String amountPayable = "";

  var arguments = Get.arguments;

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  late LoanDetailsModel loanDetailsModel;

  final String PAY_NOW_BUTTON = "pay-now-button";

  bool _isTileExpanded = false;

  bool get isTileExpanded => _isTileExpanded;

  set isTileExpanded(bool value) {
    _isTileExpanded = value;
    update(['expansion-tile']);
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([PAY_NOW_BUTTON]);
  }

  late Razorpay _razorpay;

  int razorPayTimeOutCode = 2;

  RePaymentRepository _rePaymentRepository = RePaymentRepository();

  void onInitial() {
    isPageLoading = true;
    loanDetailsModel = arguments['loanDetails'];

    amountPayable = loanDetailsModel.totalPendingAmount;
    update([PAY_NOW_BUTTON]);
    _initializeRazorPay();
    logPartialAmountScreenLoaded();
    isPageLoading = false;
  }

  void _initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logPaymentSuccessfulLoaded(
      overDueAmount: loanDetailsModel.totalPendingAmount,
      amountPaid: amountPayable,
    );
    _gotoPaymentSuccessScreen();
  }

  void _gotoPaymentSuccessScreen() {
    Get.offAndToNamed(
      Routes.PAYMENT_SUCCESS_SCREEN,
      arguments: PaymentSuccessModel(
        isWithdrawalBlocked: false,
        appRatingPromptEvent: "",
        refIdKey: "Loan ID",
        refIdValue: "#${loanDetailsModel.loanId}",
        amount: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
            num.parse(amountPayable.replaceAll(',', ''))),
        subtitleText:
            "Your request is being processed and will be completed shortly",
        onCloseClicked: () {},
        infoMessage: "",
        onGoToHomeClicked: () {},
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Get.log("razorpay error - ${response.message}");
    logPaymentFailureLoaded(response);
    _showRetryDialog(
        _computeErrorReason(response.error?['reason'] as String ?? ""));
  }

  _showRetryDialog(String errorDescription) {
    Get.bottomSheet(
        PaymentRetryDialog(
          onCancel: () {
            Get.back();
          },
          onRetry: () {
            Get.back();
            onPayNow();
          },
          errorDescription: errorDescription,
        ),
        isDismissible: false);
  }

  _computeErrorReason(String reason) {
    switch (reason) {
      case INCORRECT_PIN:
        return "You have entered an incorrect UPI PIN. Please retry or try a different payment method";
      case INSUFFICIENT_FUNDS:
        return "Your payment was declined due to low balance. Please try with a different account.";
      case PAYMENT_FAILED:
        return "Your payment was declined by the bank. Please try another method or contact your bank.";
      default:
        return "Your payment couldn’t be processed. Please try again or use a different method";
    }
  }

  onPayNow() async {
    logPayNowClicked(
      overDueAmount: loanDetailsModel.totalPendingAmount,
      selectedAmount: amountPayable,
    );
    await _getRazorPayOrderId();
  }

  _getRazorPayOrderId() async {
    isButtonLoading = true;
    Get.log("payable ${amountPayable}");
    Map<String, dynamic> body = {
      "amount": double.parse(amountPayable.replaceAll(',', '')),
      "appFormId": loanDetailsModel.appFormId,
      "loanId": loanDetailsModel.loanId,
      "repaymentType": "repaymentOverDue",
    };

    RazorPayOrderModel model = await _rePaymentRepository.getOrderId(body);

    switch (model.apiResponse.state) {
      case ResponseState.success:
        await _openRazorPaySDK(model);
        isButtonLoading = false;
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: PAYMENT_GATEWAY_SCREEN, retry: _getRazorPayOrderId);
        isButtonLoading = false;
    }
  }

  ///openRazorPaySDK
  _openRazorPaySDK(RazorPayOrderModel model) async {
    var options = {
      'key': F.envVariables.razorPayEMandateKeys.apiKey,
      "order_id": model.orderId,
      'prefill': {
        'contact': await AppAuthProvider.phoneNumber,
      },
      "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        "upi": true
      },
      "timeout": 300,
      "name": "Payment",
      "description": "Re Payment for Credit Saison India",
      "theme": {"color": "#004097"},
    };

    Get.log("razorpay options - $options");

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.log("Error opening sdk ${e.toString()}");
    }
  }

  @override
  void onClose() {
    logCloseScreen();
    _razorpay.clear();
    super.onClose();
  }

  void onPayPartialClicked() async {
    logPayPartialAmountClicked();
    if (!isButtonLoading) {
      var result = await Get.bottomSheet(
          PayPartiallyBottomSheet(
            totalPendingAmount: loanDetailsModel.totalPendingAmount,
          ),
          isScrollControlled: true,
          isDismissible: false);
      if (result != null && result.toString().isNotEmpty) {
        amountPayable = result;
        onPayNow();
      } else {
        amountPayable = loanDetailsModel.totalPendingAmount;
      }
    }
  }

  onFullRepayment() {
    amountPayable = loanDetailsModel.totalPendingAmount;
    onPayNow();
  }

  String computeOverdueBadge() {
    if (loanDetailsModel.isPendingPayment) return "Pending amount";
    return loanDetailsModel.overdueEmiDate.isNotEmpty
        ? computeDaysOverdue(loanDetailsModel.overdueEmiDate)
        : "Overdue";
  }

  String computeDaysOverdue(String dateString) {
    final dueDate = DateTime.parse(dateString); // parse the input
    final now = DateTime.now();

    // Remove the time portion for accurate day difference
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final daysDue = today.difference(due).inDays;
    return "${daysDue} day${daysDue > 1 ? 's' : ''} overdue";
  }
}
