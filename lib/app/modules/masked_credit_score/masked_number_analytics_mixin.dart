import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin MaskedNumberAnalyticsMixin on AppAnalyticsMixin {
  late final String creditScoreMaskedFlowLoaded =
      "Credit_Score_Maskedflow_Loaded";
  late final String creditScoreMaskedFlowScreenClosed =
      "Credit_Score_Maskedflow_ScreenClosed";
  late final String creditScoreMaskedFlow = "Credit_Score_Maskedflow_Reopened";
  late final String creditScoreMaskedFlowNumberNotFoundClicked =
      "Credit_Score_Maskedflow_NumberNotFound_Clicked";
  late final String creditScoreMaskedFlowNumberNotFoundRedirected =
      "Credit_Score_Maskedflow_NumberNotFound_Redirected";
  late final String creditScoreMaskedFlowNumberSelected =
      "Credit_Score_Maskedflow_NumberSelected";
  late final String creditScoreMaskedFlowNumberMismatch =
      "Credit_Score_Maskedflow_NumberMismatch";
  late final String creditScoreMaskedFlowOTPTriggered =
      "Credit_Score_Maskedflow_OTPTriggered";
  late final String creditScoreMaskedFlow400Error =
      "Credit_Score_Maskedflow_400Error";
  late final String creditScoreMaskedFlowOTPIncorrect =
      "Credit_Score_Maskedflow_400Error";
  late final String creditScoreMaskedFlowOTPVerifiedSuccess =
      "Credit_Score_Maskedflow_OTPVerified_Success";

  logCreditScoreMaskedFlowLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: creditScoreMaskedFlowLoaded,
    );
  }

  logCreditScoreMaskedFlowScreenClosed() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowScreenClosed);
  }

  logCreditScoreMaskedFlowReopened() {
    trackWebEngageEventWithAttribute(eventName: creditScoreMaskedFlow);
  }

  logCreditScoreMaskedFlowNumberNotFoundClicked() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowNumberNotFoundClicked);
  }

  logCreditScoreMaskedFlowNumberNotFoundRedirected() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowNumberNotFoundRedirected);
  }

  logCreditScoreMaskedFlowNumberSelected() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowNumberSelected);
  }

  logCreditScoreMaskedFlowNumberMismatch() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowNumberMismatch);
  }

  logCreditScoreMaskedFlowOTPTriggered() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowOTPTriggered);
  }

  void logCreditScoreMaskedFlow400Error({required String error}) {
    trackWebEngageEventWithAttribute(
      eventName: creditScoreMaskedFlow400Error,
      attributeName: {"error": error},
    );
  }

  logCreditScoreMaskedFlowOTPVerifiedSuccess() {
    trackWebEngageEventWithAttribute(
        eventName: creditScoreMaskedFlowOTPVerifiedSuccess);
  }
}
