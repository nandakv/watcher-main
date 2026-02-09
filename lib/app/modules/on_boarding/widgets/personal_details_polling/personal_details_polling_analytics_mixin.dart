import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin PersonalDetailsPollingAnalyticsMixin on AppAnalyticsMixin {
  late final String pdPollingStarted = "PD_Polling_Started";
  late final String pdPollingFullScreenLoaded = "PD_Polling_Full_Screen_Loaded";
  late final String pdPollingFullScreenClosed = "PD_Polling_Full_Screen_Closed";

  void logPersonalDetailsPollingStarted() {
    trackWebEngageEventWithAttribute(
      eventName: pdPollingStarted,
    );
  }

  void logPersonalDetailsPollingFullScreenLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: pdPollingFullScreenLoaded,
    );
  }

  void logPersonalDetailsPollingFullScreenClosed() {
    trackWebEngageEventWithAttribute(
      eventName: pdPollingFullScreenClosed,
    );
  }
}
