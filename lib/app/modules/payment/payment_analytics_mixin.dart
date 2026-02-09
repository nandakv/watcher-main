import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin PaymentAnalyticsMixin {
  final _analyticsMixin = AppAnalyticsMixin();

  late final String paymentDetailsLoaded = "Payment_Details_Loaded";

  void logPaymentDetailsLoaded(num finalPayableAmount, String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: paymentDetailsLoaded,
      attributeName: {
        'emi_amount': "$finalPayableAmount",
        "LAN": loanId,
      },
    );
  }
}
