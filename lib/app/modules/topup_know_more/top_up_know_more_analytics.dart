import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin TopUpKnowMoreAnalytics on AppAnalyticsMixin {
  late final _topUpKnowMorePageLoaded = "Top_Up_Know_More_Page_Loaded";
  late final _topUpKnowMoreGetStarted = "Top_Up_Know_More_Get_Started";

  void logTopUpKnowMorePageLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: _topUpKnowMorePageLoaded,
    );
  }

  void logTopUpKnowMoreGetStarted() {
    trackWebEngageEventWithAttribute(
      eventName: _topUpKnowMoreGetStarted,
    );
  }
}
