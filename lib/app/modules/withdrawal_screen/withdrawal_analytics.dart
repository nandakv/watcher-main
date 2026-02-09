import 'package:privo/app/mixin/app_analytics_mixin.dart';

import '../../utils/web_engage_constant.dart';

mixin WithdrawalAnalytics {
  final _analyticsMixin = AppAnalyticsMixin();

  late String withdrawalSuccessfulScreenLoaded =
      "Withdrawal Successful Screen Loaded";

  logWithdrawalSuccessfulScreenLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: withdrawalSuccessfulScreenLoaded,
    );
  }

  logWithdrawalPollingLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.disbursalPollingLoaded,
        attributeName: {
          'disbursal_screen': true,
        });
  }

  logWithdrawalFailureLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.disbursalFailureLoaded,
        attributeName: {
          'disbursal_screen': true,
        });
  }

  logWithdrawalRetryClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.retryWithdrawalClicked,
        attributeName: {
          'disbursal_screen': true,
        });
  }

  logWithdrawalPollingMinimizedClicked(bool isPollingFailed) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawalMinimised,
        attributeName: {
          isPollingFailed ? 'failed' : 'polling': true,
        });
  }
}
