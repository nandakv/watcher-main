import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin FaqAnalytics {
  final _appAnalytics = AppAnalyticsMixin();

  final _Close_Screen = "Close_Screen";
  final _FAQ_Click = "FAQ_Click";

  logCloseClick(String attribute) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: _Close_Screen,
      attributeName: {
        "close_faq_$attribute": true,
      },
    );
  }

  logFAQTileClick(int index, String attribute) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: _FAQ_Click,
      attributeName: {
        "${attribute}_faq": true,
        "faq_n": index,
      },
    );
  }
}
