import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin BankDetailsAnalytics on AppAnalyticsMixin{
  // Variables
  late String pennyDropLoaded = "Penny_Drop_Loaded";
  late String pennyDropVerifyClicked = "Penny_Drop_Verify_Clicked";

// Functions
  void logPennyDropLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: pennyDropLoaded,
    );
  }

  void logPennyDropVerifyClicked() {
    trackWebEngageEventWithAttribute(
      eventName: pennyDropVerifyClicked,
    );
  }


}