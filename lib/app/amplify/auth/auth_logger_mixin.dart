import 'package:privo/app/mixin/app_analytics_mixin.dart';

class AuthLoggerMixin {
  final _analytics = AppAnalyticsMixin();

  late String sessionExpired = "Session Expired";
  late String authNotAuthorizedException = "AuthNotAuthorizedException";
  late String authException = "AuthException";
  late String generalCatchException = "GeneralCatchException";

  logSessionExpiredEvent(String event, String attribute) {
    _analytics.trackWebEngageEventWithAttribute(
      eventName: event,
      attributeName: {
        "exception": attribute,
      },
    );
  }

  logUnAuthorizedApiResponse(String screenName) {
    _analytics.trackWebEngageEventWithAttribute(
      eventName: "Unauthorized Api Response",
      attributeName: {
        "screen_name": screenName,
      },
    );
  }
}
