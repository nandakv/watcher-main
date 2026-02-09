import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

mixin RePaymentTypeSelectorAnalytics {
  final _analyticsMixin = AppAnalyticsMixin();

  logPartialAmountScreenLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.partialAmountScreenLoaded,
        attributeName: {
          "overdue_payment": true,
        });
  }

  logPayPartialAmountClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.payPartialAmountClicked,
        attributeName: {
          "overdue_payment": true,
        });
  }

  logCloseScreen() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.closeScreen,
        attributeName: {
          "overdue_payment": true,
        });
  }

  logPayNowClicked({
    required String overDueAmount,
    required String selectedAmount,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.payNowClicked,
        attributeName: {
          "overdue_payment": true,
          "overdue_amount": overDueAmount,
          "selected_amount": selectedAmount,
        });
  }

  logPaymentSuccessfulLoaded({
    required String overDueAmount,
    required String amountPaid,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentSuccessfulLoaded,
        attributeName: {
          "overdue_payment": true,
          "overdue_amount": overDueAmount,
          "amount_paid": amountPaid,
        });
  }

  logPaymentFailureLoaded(PaymentFailureResponse response) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentFailureLoaded,
        attributeName: {
          "overdue_payment": true,
          "errorMessage": response.error?['reason'] ?? "",
          "errorCode": response.error?['code'] ?? "",
        });
  }

  logPaymentFailureCancelClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentFailureCancelClicked,
        attributeName: {
          "overdue_payment": true,
        });
  }

  logPaymentFailureRetryClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentFailureRetryClicked,
        attributeName: {
          "overdue_payment": true,
        });
  }
}
