import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_logic.dart';
import 'package:privo/app/data/repository/emi_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/part_payment_info_model.dart';
import 'package:privo/app/models/withdrawal_block_check_model.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/payment_analytics_mixin.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/payment/widgets/payment_retry_dialog.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/components/button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_error_mixin.dart';
import 'package:get/get.dart';

import '../../api/response_model.dart';
import '../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../data/provider/auth_provider.dart';
import '../../data/repository/re_payment_repository.dart';
import '../../firebase/analytics.dart';
import '../../models/razorpay_order_model.dart';
import '../../routes/app_pages.dart';
import '../../services/payment_gateway_service/payment_gateway_service.dart';
import '../../utils/web_engage_constant.dart';
import '../loan_details/widgets/info_bottom_sheet.dart';
import 'model/payment_success_model.dart';
import 'model/payment_view_model.dart';

class PaymentLogic extends GetxController
    with ApiErrorMixin, ErrorLoggerMixin, PaymentAnalyticsMixin {
  final String PAY_BUTTON_KEY = "pay_button";
  final String REASON_TEXTFIELD = "reason_textfield";
  static const String INCORRECT_PIN = "incorrect_pin";
  static const String INSUFFICIENT_FUNDS = "insufficient_funds";
  static const String PAYMENT_FAILED = "payment_failed";

  late String PAYMENT_GATEWAY_SCREEN = "payment_gateway_screen";

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController otherReasonController = TextEditingController();

  final PaymentGateWayService _paymentGateWayService = PaymentGateWayService(
      paymentGatewayProvider: PAYMENT_GATEWAY_PROVIDER.razorPay);

  final RePaymentRepository _rePaymentRepository = RePaymentRepository();
  final _creditLimitRepository = CreditLimitRepository();

  late PartPaymentInfoModel partPaymentInfoModel;

  bool _isButtonLoading = false;
  bool _isButtonEnaled = false;

  String PRE_PAY_AMOUNT_TEXTFIELD_ID = "partPayAmountTextFieldId";

  TextEditingController partPayAmountTextController = TextEditingController();

  var PART_PAY_ERROR_TEXT = "PART_PAY_ERROR_TEXT";

  bool get isButtonLoading => _isButtonLoading;

  bool get isButtonEnabled => _isButtonEnaled;

  String _errorText = "";

  String get errorText => _errorText;

  set errorText(String value) {
    _errorText = value;
    update([PART_PAY_ERROR_TEXT]);
  }

  set isButtonLoading(bool val) {
    _isButtonLoading = val;
    update([PAY_BUTTON_KEY]);
  }

  set isButtonEnabled(bool val) {
    _isButtonEnaled = val;
    update([PAY_BUTTON_KEY]);
  }

  final String PAYMENT_PAGE_ID = 'payment_page_id';
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update([PAYMENT_PAGE_ID]);
  }

  PaymentViewArgumentModel paymentViewModel = Get.arguments;

  bool _isWithdrawalBlocked = false;

  onAfterLayout() async {
    if (paymentViewModel.paymentType == PaymentType.advanceEmi) {
      logPaymentDetailsLoaded(
        paymentViewModel.finalPayableAmount,
        paymentViewModel.loanId,
      );
    }
    if (paymentViewModel.paymentType == PaymentType.partPay) {
      await _getPartPaymentType();
    }
    _paymentGateWayService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentError,
    );
    _checkAndAddPartPayAmountToBreakDown();
    _checkIfWithdrawalBlocked();
    isPageLoading = false;
  }

  _getPartPaymentType() async {
    isPageLoading = true;
    PartPaymentInfoModel paymentInfoModel =
        await EmiRepository().getPartPaymentInfo(
      loanId: paymentViewModel.loanId,
    );
    switch (paymentInfoModel.apiResponse.state) {
      case ResponseState.success:
        partPaymentInfoModel = paymentInfoModel;
        partPayAmountTextController.text = AppFunctions().parseIntoCommaFormat(
            partPaymentInfoModel.minPartPayAmount.toString());
        isPageLoading = false;
        break;
      default:
        handleAPIError(
          paymentInfoModel.apiResponse,
          screenName: PAYMENT_GATEWAY_SCREEN,
          retry: _getPartPaymentType,
        );
    }
  }

  _checkAndAddPartPayAmountToBreakDown() {
    ///This is added since we have to keep updating part pay amount based on user input
    if (paymentViewModel.paymentType == PaymentType.partPay) {
      paymentViewModel.breakdownRowData = [];
      paymentViewModel.breakdownRowData.add(
        _getBreakdownRowData(
          "Part-Pay Amount",
          _fetchPartPayAmount(),
        ),
      );
    }
  }

  double _fetchPartPayAmount() {
    return double.parse(
      partPayAmountTextController.text.isEmpty
          ? '0'

          ///This will be the value shown to user initially when the user enters the screen
          : parseIntoDoubleFormat(partPayAmountTextController.text).toString(),
    );
  }

  double parseIntoDoubleFormat(String value) {
    Get.log("value for parsing - $value");
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      Get.log("can't parse money - $e");
      return 0;
    }
  }

  _checkIfWithdrawalBlocked() async {
    WithdrawalBlockCheckModel model =
        await _creditLimitRepository.checkWithdrawalBlocked();
    if (model.apiResponse.state == ResponseState.success) {
      _isWithdrawalBlocked = model.isWithdrawalBlocked;
    } else {
      logError(
        url: model.apiResponse.url,
        exception: model.apiResponse.exception,
        requestBody: model.apiResponse.requestBody,
        responseBody: model.apiResponse.apiResponse,
        statusCode: model.apiResponse.statusCode.toString(),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _gotoPaymentSuccessScreen();

    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.paymentSuccessfulLoaded,
      attributeName: {
        _computePaymentSuccessWebengageKey(): true,
      },
    );
  }

  String _computePaymentSuccessWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "payment_of_prepay_success";
      case PaymentType.advanceEmi:
        return "payment_of_upcoming_due_success";
      case PaymentType.partPay:
        return "part_payment";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey";
    }
  }

  String _computeSuccessScreenText() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "Done, done and done!\nYour request will be processed soon";
      case PaymentType.advanceEmi:
        return "The EMI payment will reflect in your Account Statement.";
      case PaymentType.loanCancellation:
      case PaymentType.overdue:
      case PaymentType.partPay:
        return "Your request is being processed and will be completed shortly";
      default:
        return "";
    }
  }

  String _computeRefIdKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.loanCancellation:
      case PaymentType.advanceEmi:
        return "Loan ID";
      default:
        return "Reference ID (withdrawal)";
    }
  }

  _getAmountPayable() {
    if (paymentViewModel.paymentType == PaymentType.partPay) {
      return "₹${AppFunctions().parseIntoCommaFormat(parseIntoDoubleFormat(partPayAmountTextController.text).toString())}";
    } else {
      return paymentViewModel.totalAmountValue;
    }
  }

  void _gotoPaymentSuccessScreen() {
    Get.offAndToNamed(
      Routes.PAYMENT_SUCCESS_SCREEN,
      arguments: PaymentSuccessModel(
        isWithdrawalBlocked: _isWithdrawalBlocked,
        appRatingPromptEvent: _computeAppRatingPromptEvent(),
        refIdKey: _computeRefIdKey(),
        refIdValue: "#${paymentViewModel.loanId}",
        amount: _getAmountPayable(),
        subtitleText: _computeSuccessScreenText(),
        onCloseClicked: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.closeScreen,
            attributeName: {
              _computeClosePaymentSuccessScreenWebengageKey(): true,
            },
          );
        },
        infoMessage: _getInfoMessage(),
        onGoToHomeClicked: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.goToHomepage,
            attributeName: {
              _computeGoToHomePaymentSuccessScreenWebengageKey(): true,
            },
          );
        },
      ),
    );
  }

  String _getInfoMessage() {
    if (LPCService.instance.activeCard?.loanProductCode != "FCL") {
      return "";
    }

    if (paymentViewModel.paymentType == PaymentType.overdue) {
      return "You can find the payment details in your statement of account under loan details page.";
    } else {
      return "Your payment has been processed successfully. The updated limit will be reflected in your account within 24 to 48 hours.";
    }
  }

  String _computeClosePaymentSuccessScreenWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "close_payment_of_foreclosure_success";
      case PaymentType.advanceEmi:
        return "close_payment_of_upcoming_due_success";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey_success";
    }
  }

  String _computeGoToHomePaymentSuccessScreenWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "homepage_from_payment_of_foreclosure_success";
      case PaymentType.advanceEmi:
        return "homepage_from_payment_of_upcoming_due_success";
      case PaymentType.partPay:
        return "part_payment";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey_success";
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Get.log("razorpay error - ${response.message}");
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.paymentFailureLoaded,
      attributeName: {
        computePaymentFailureWebengageKey(): true,
        "errorMessage": response.error?['reason'] ?? "",
        "errorCode": response.error?['code'] ?? "",
      },
    );
    if (LPCService.instance.activeCard?.loanProductCode == "FCL") {
      Get.toNamed(
        Routes.PAYMENT_FAILURE_SCREEN,
        arguments: {
          if (paymentViewModel.paymentType == PaymentType.overdue)
            'message':
                "It seems like a temporary technical issue is preventing overdue payment. Please try again.",
        },
      );
    } else {
      _showRetryDialog(
          _computeErrorReason(response.error?['reason'] as String ?? ""));
    }
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

  String computePaymentFailureWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "payment_failure_prepay";
      case PaymentType.advanceEmi:
        return "payment_failure_upcoming_dues";
      case PaymentType.partPay:
        return "part_payment";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey";
    }
  }

  _showRetryDialog(String errorDescription) {
    Get.bottomSheet(PaymentRetryDialog(
      onCancel: _onPaymentRetryDialogCancel,
      onRetry: _onPaymentRetryDialogRetry,
      errorDescription: errorDescription,
    ));
  }

  void _onPaymentRetryDialogCancel() {
    ///to close the dialog
    Get.back();

    ///to go back to the parent view
    Get.back();
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.paymentFailureCancelClicked,
      attributeName: {
        _computeFailureCancelWebengageKey(): true,
      },
    );
  }

  String _computeFailureCancelWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "payment_failure_cancel_prepay";
      case PaymentType.advanceEmi:
        return "payment_failure_cancel_upcoming_dues";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey";
    }
  }

  void _onPaymentRetryDialogRetry() {
    Get.back();
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.paymentFailureRetryClicked,
      attributeName: {
        _computeFailureRetryWebengageKey(): true,
      },
    );
    onPayCTA();
  }

  String _computeFailureRetryWebengageKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "payment_failure_retry_prepay";
      case PaymentType.advanceEmi:
        return "payment_failure_retry_upcoming_dues";
      case PaymentType.loanCancellation:
      default:
        return "cancellation_journey";
    }
  }

  String? reasonValidator(String? value) {
    if (value!.trim().isEmpty) return "Enter the reason";
    return null;
  }

  onPayCTA() async {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        _onForeclosurePayCTA();
        break;
      case PaymentType.advanceEmi:
        _onAdvanceEMIPayCTA();
        break;
      case PaymentType.loanCancellation:
        _onLoanCancellationPayCTA();
        break;
      case PaymentType.partPay:
        _onPartPayCta();
        break;
      case PaymentType.overdue:
        _getRazorPayOrderId();
        break;
      default:
    }
  }

  _onPartPayCta() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.reasonClicked,
        attributeName: {"reason": _getReason()});
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaPay,
        attributeName: {"part_pay": true});
    await _getRazorPayOrderId();
  }

  Future<void> _onLoanCancellationPayCTA() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.reasonClicked,
        attributeName: {"reason": _getReason()});
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaPay,
        attributeName: {"cancellation_journey": true});
    await _getRazorPayOrderId();
  }

  Future<void> _onAdvanceEMIPayCTA() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.ctaPayUpcomingDue,
      attributeName: {
        "upcoming_dues": true,
      },
    );

    await _getRazorPayOrderId();
  }

  Future<void> _onForeclosurePayCTA() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.ctaPayPrepay,
      attributeName: {
        "prepay": true,
      },
    );
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.prepayReason,
        attributeName: {"reason": _getReason()});

    await _getRazorPayOrderId();
  }

  String _getReason() {
    if (reasonController.text == "other") {
      return otherReasonController.text;
    }
    return reasonController.text;
  }

  String _computeRePaymentType() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "repaymentForeClose";
      case PaymentType.advanceEmi:
        return "repaymentAdvance";
      case PaymentType.loanCancellation:
        return "repaymentLoanCancellation";
      case PaymentType.partPay:
        return "repaymentPartialSettlement";
      case PaymentType.overdue:
        return "repaymentOverDue";
      default:
        return "";
    }
  }

  _getRazorPayOrderId() async {
    late num amountPayable;
    if (paymentViewModel.paymentType == PaymentType.partPay) {
      amountPayable = parseIntoDoubleFormat(partPayAmountTextController.text);
    } else {
      amountPayable = paymentViewModel.finalPayableAmount;
    }
    isButtonLoading = true;
    Get.log("payable $amountPayable");

    LoanDetailsModel loanDetailsModel =
        await EmiRepository().getLoanDetails(loanId: paymentViewModel.loanId);

    switch (loanDetailsModel.apiResponse.state) {
      case ResponseState.success:
        Map<String, dynamic> body = {
          "amount": amountPayable,
          "appFormId": loanDetailsModel.appFormId,
          "loanId": paymentViewModel.loanId,
          "repaymentType": _computeRePaymentType(),
        };

        RazorPayOrderModel model = await _rePaymentRepository.getOrderId(body);

        switch (model.apiResponse.state) {
          case ResponseState.success:
            _paymentGateWayService.start(model.orderId);
            isButtonLoading = false;
            break;
          default:
            handleAPIError(model.apiResponse,
                screenName: PAYMENT_GATEWAY_SCREEN, retry: _getRazorPayOrderId);
        }
        break;
      default:
        handleAPIError(loanDetailsModel.apiResponse,
            screenName: PAYMENT_GATEWAY_SCREEN, retry: _getRazorPayOrderId);
    }
  }

  void checkFieldsValidity() {
    if (paymentViewModel.paymentType == PaymentType.partPay) {
      if (_validateAmountLesserThan()) {
        errorText =
            "Entered amount must be at least ₹${AppFunctions().parseIntoCommaFormat(partPaymentInfoModel.minPartPayAmount.toString())} to proceed";
      } else if (_validateAmountGreaterThan()) {
        errorText = "Entered amount must be less than the utilised limit";
      } else {
        errorText = "";
      }
      isButtonEnabled = !_validateAmountGreaterThan() &&
          !_validateAmountLesserThan() &&
          reasonController.text.isNotEmpty;
    } else {
      isButtonEnabled = reasonController.text.isNotEmpty;
    }
    update([REASON_TEXTFIELD]);
  }

  bool _validateAmountLesserThan() {
    return parseIntoDoubleFormat(partPayAmountTextController.text) <
        partPaymentInfoModel.minPartPayAmount;
  }

  bool _validateAmountGreaterThan() {
    return parseIntoDoubleFormat(partPayAmountTextController.text) >
        partPaymentInfoModel.maxPartPayAmount;
  }

  String getAppbarTitle() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.advanceEmi:
        return "Upcoming EMI #${paymentViewModel.loanId}";
      case PaymentType.foreclosure:
        return "Foreclose #${paymentViewModel.loanId}";
      case PaymentType.loanCancellation:
        return "Cancellation #${paymentViewModel.loanId}";
      case PaymentType.partPay:
        return "Part-pay #${paymentViewModel.loanId}";
      case PaymentType.overdue:
        return "Overdue #${paymentViewModel.loanId}";
      default:
        return "";
    }
  }

  Future<bool> onBack() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.closeScreen,
      attributeName: {
        paymentViewModel.paymentType == PaymentType.foreclosure
            ? "close_prepay_payment"
            : "close_upcoming_due_payment": true,
      },
    );
    return true;
  }

  final List<String> _foreclosureReasons = [
    "ROI is too high",
    "I have funds to close",
    "Got better offer somewhere else",
    "Too many loans, want to close this"
  ];

  final List<String> _cancellationReasons = [
    "Changed My Mind / No Longer Required",
    "Got Funds from Other Fintech/Bank",
    "Borrowed from Friends/Family",
    "High Interest Rates",
    "Longer Tenure",
    "Disbursal Issues",
    "Other",
  ];

  final List<String> _partPayReasons = [
    "Funds from Sale of Property",
    "Cash flow from Business activity",
    "Excess Funds",
    "Others"
  ];

  void onTapReason() async {
    var result = await Get.bottomSheet(
      isScrollControlled: true,
      BottomSheetRadioButtonWidget(
          title: _computeReasonTitle(),
          enableOtherTextField: true,
          radioValues: _computeReasons(),
          titleTextStyle:
              AppTextStyles.headingSMedium(color: AppTextColors.brandBlueTitle),
          initialValue: reasonController.text,
          isCloseIconEnabled: true,
          ctaButtonsBuilder: (BottomSheetRadioButtonLogic logic) => [
                Button(
                  buttonType: ButtonType.primary,
                  buttonSize: ButtonSize.large,
                  onPressed: () {
                    logic.onSubmitPressed(
                        onSubmitPressed: (value) async {
                          reasonController.text = value;
                        },
                        shouldShowSuccessWidget: false);
                    Get.back(result: reasonController.text);
                  },
                ),
              ]),
      enableDrag: false,
      isDismissible: false,
    );
    if (result != null) {
      Get.log("result - $result");
      reasonController.text = result;
      checkFieldsValidity();
    }
  }

  _computeReasonTitle() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return 'Reason for foreclosing';
      case PaymentType.loanCancellation:
        return 'Reason For Cancellation';
      case PaymentType.partPay:
        return 'Reasons';
    }
  }

  _computeReasons() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return _foreclosureReasons;
      case PaymentType.loanCancellation:
        return _cancellationReasons;
      case PaymentType.partPay:
        return _partPayReasons;
    }
  }

  void onTnCClick() {
    launchUrl(
        Uri.parse(
          "https://regulatory.creditsaison.in/terms-conditions",
        ),
        mode: LaunchMode.externalApplication);

    _sendTncWebEngageEvents();
  }

  _sendTncWebEngageEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.tncClicked,
      attributeName: {
        _computeTncWebengageEventKey(): true,
      },
    );
  }

  String _computeTncWebengageEventKey() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "tnc_payment_of_prepay";
      case PaymentType.loanCancellation:
        return "cancellation_journey";
      case PaymentType.partPay:
        return "tnc_part_payment";
      case PaymentType.advanceEmi:
      default:
        return "tnc_payment_of_upcoming_dues";
    }
  }

  bool showReason() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
      case PaymentType.loanCancellation:
        return true;
      default:
        return false;
    }
  }

  String computeReasonHintText() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "Reason for foreclosing";
      case PaymentType.loanCancellation:
        return "Reason for cancellation";
      case PaymentType.partPay:
        return "Reason for Part-payment";
      default:
        return "";
    }
  }

  String computeForeclosureCancellationConsentText() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.foreclosure:
        return "By proceeding to foreclose, you will agree on the ";
      case PaymentType.partPay:
        return "By proceeding to Part-pay, you will agree on the ";
      default:
        return "By proceeding to pay, you will agree on the ";
    }
  }

  String? computeInfoMessage() {
    if (paymentViewModel.paymentType == PaymentType.loanCancellation) {
      return "You will only need to repay the amount deposited into your bank account. Charges may apply, in case of any.";
    }
    return null;
  }

  void bpiBottomSheetEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.bpiHelpfulEventLoaded);
    Get.bottomSheet(InfoBottomSheet(
        title: "Broken period Interest (BPI)",
        text:
            'Amount collected as an interest from the borrower if the time between the actual date of disbursal and the 1st instalment is more than 30 days.',
        closedEvent: WebEngageConstants.bpiHelpfulEventClosed,
        yesEvent: WebEngageConstants.bpiHelpfulEventYes,
        noEvent: WebEngageConstants.bpiHelpfulEventNo));
  }

  void aprBottomSheetEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aprHelpfulEventLoaded);
    Get.bottomSheet(InfoBottomSheet(
        title: "Annual Percentage Rate (APR)",
        text:
            'Effective annualised rate charged to the borrower of a digital loan based on an all-inclusive cost and margin including the cost of funds.',
        closedEvent: WebEngageConstants.aprHelpfulEventClosed,
        yesEvent: WebEngageConstants.aprHelpfulEventYes,
        noEvent: WebEngageConstants.aprHelpfulEventNo));
  }

  _sendCloseWebengageEvent() {
    if (paymentViewModel.paymentType == PaymentType.loanCancellation) {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.closeScreen,
        attributeName: {
          "cancellation_journey": true,
        },
      );
    }
  }

  Future<bool> onWillPop() async {
    _sendCloseWebengageEvent();
    return true;
  }

  onClosePressed() {
    _sendCloseWebengageEvent();
    Get.back();
  }

  _computeAppRatingPromptEvent() {
    switch (paymentViewModel.paymentType) {
      case PaymentType.advanceEmi:
        return WebEngageConstants.playStorePromptedPOUD;
      case PaymentType.foreclosure:
        return WebEngageConstants.playStorePromptedFC;
      case PaymentType.overdue:
      case PaymentType.loanCancellation:
      case PaymentType.none:
      case PaymentType.partPay:
        return "";
    }
  }

  void onPartPayAmountChanged(String value) {
    checkFieldsValidity();
    _checkAndAddPartPayAmountToBreakDown();
    update([PAYMENT_PAGE_ID]);
  }

  LoanBreakdownRowData _getBreakdownRowData(String key, num value) {
    return LoanBreakdownRowData(
      key: key,
      value: _parseIntToString(value),
      valueTextStyle: _tableValueTextStyle,
    );
  }

  String _parseIntToString(num num) {
    return '₹ ${AppFunctions().parseIntoCommaFormat(num.toString())}';
  }

  TextStyle get _tableValueTextStyle {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: primaryDarkColor,
      fontWeight: FontWeight.w600,
    );
  }
}
