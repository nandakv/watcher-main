import 'package:privo/app/mixin/app_analytics_mixin.dart';

import '../../models/home_screen_model.dart';

mixin ServicingAnalyticsMixin {
  final _analytics = AppAnalyticsMixin();

  late String allLoansDashboardLoaded = "All_Loans_Dashboard_Loaded";

  logLoanDashboardLoadedEvent(List<LpcCard> lpcCards) {
    _analytics.trackWebEngageUser(
      userAttributeName: "lpc_list",
      userAttributeValue: lpcCards.map((e) => e.loanProductCode).toList().join("_"),
    );
    _analytics.trackWebEngageEventWithAttribute(
      eventName: allLoansDashboardLoaded,
      attributeName: {
        "lpc_list": lpcCards.map((e) => e.loanProductCode).toList().join("_"),
      },
    );
  }
}
