import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/security_check/security_type_result_model.dart';

mixin SplashScreenAnalyticsMixin on AppAnalyticsMixin {
  logSecurityCheck(SecurityTypeResultModel result, String eventName) {
    trackWebEngageEventWithAttribute(
      eventName: eventName,
      attributeName: result.logs,
    );
  }
}
