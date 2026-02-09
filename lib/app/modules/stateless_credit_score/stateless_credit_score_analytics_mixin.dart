import '../../mixin/app_analytics_mixin.dart';

class StatelessCreditScoreAnalyticsMixin {
  final _appAnalytics = AppAnalyticsMixin();

  late final String creditScoreD2CWhitelistHomeLoaded =
      "Credit_Score_D2C_Whitelist_Home_Loaded";
  late final String creditScoreD2CWhitelistHomeClicked =
      "Credit_Score_D2C_Whitelist_Home_Clicked";
  late final String creditScoreD2CWhitelistFormLoaded =
      "Credit_Score_D2C_Whitelist_Form_Loaded";
  late final String creditScoreD2CWhitelistFormSubmitted =
      "Credit_Score_D2C_Whitelist_Form_Submitted";
  late final String creditScoreD2CWhitelistPollingLoaded =
      "Credit_Score_D2C_Whitelist_Polling_Loaded";
  late final String creditScoreD2CWhitelistSuccessLoaded =
      "Credit_Score_D2C_Whitelist_Success_Loaded";
  late final String creditScoreD2CWhitelistFailureLoaded =
      "Credit_Score_D2C_Whitelist_Failure_Loaded";

  logCreditScoreD2CWhitelistHomeLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistHomeLoaded,
    );
  }

  logCreditScoreD2CWhitelistHomeClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistHomeClicked,
    );
  }

  logCreditScoreD2CWhitelistFormLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistFormLoaded,
    );
  }

  logCreditScoreD2CWhitelistFormSubmitted() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistFormSubmitted,
    );
  }

  logCreditScoreD2CWhitelistPollingLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistPollingLoaded,
    );
  }

  logCreditScoreD2CWhitelistSuccessLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistSuccessLoaded,
    );
  }

  logCreditScoreD2CWhitelistFailureLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CWhitelistFailureLoaded,
    );
  }
}
