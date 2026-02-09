import '../../../mixin/app_analytics_mixin.dart';

mixin AABankAnalyticsMixin on AppAnalyticsMixin {
  late final String aaBotfScreenLoaded = "AA_BOTF_Screen_Loaded";
  late final String aaBotfScreenContinueClicked =
      "AA_BOTF_Screen_Continue_Clicked";
  late final String mobileNumberContinueWithoutEditing =
      "Mobile_Number_Continue_Without_Editing";
  late final String mobileNumberContinueAfterEditing =
      "Mobile_Number_Continue_After_Editing";
  late final String mobileNumberCloseButtonClicked =
      "Mobile_Number_Close_Button_Clicked";
  late final String aaBotfPollingScreen = "AA_BOTF_Polling_Screen";
  late final String aaBotfSuccessScreen = "AA_BOTF_Success_Screen";
  late final String aaBotfFailureScreen = "AA_BOTF_Failure_Screen";
  late final String aaBotfTryAgainClicked = "AA_BOTF_Try_Again_Clicked";
  late final String aaBotfFailureScreenWithSkip =
      "AA_BOTF_Failure_Screen_With_Skip";
  late final String aaBotfSkipCtaClicked = "AA_BOTF_Skip_CTA_Clicked";
  late final String crossButtonClicked = "Cross_Button_Clicked";
  late final String aaBotfBenefitsKnowMoreClicked =
      "AA_BOTF_Benefits_Know_More_Clicked";
  late final String aaBotfBenefitsKnowMoreContinueClicked =
      "AA_BOTF_Benefits_Know_More_Continue_CTA_Clicked";
  late final String aaBotfBenefitsCrossClicked =
      "AA_BOTF_Benefits_Cross_Clicked";

  logBotfScreenLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfScreenLoaded,
    );
  }

  logBotfPollingScreen() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfPollingScreen,
    );
  }

  logBotfSuccessScreen() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfSuccessScreen,
    );
  }

  logAABotfFailureScreen({required String failureReason}) {
    trackWebEngageEventWithAttribute(
        eventName: aaBotfFailureScreen,
        attributeName: {"failure reason": failureReason});
  }

  logBotfTryAgainClicked() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfTryAgainClicked,
    );
  }

  logBotfFailureScreenWithSkip() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfFailureScreenWithSkip,
    );
  }

  logBotfSkipCtaClicked() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfSkipCtaClicked,
    );
  }

  logCrossButtonClicked({String screenName = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: crossButtonClicked,
        attributeName: {"screen_name": screenName});
  }

  logBotfBenefitsKnowMoreContinueClicked() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfBenefitsKnowMoreContinueClicked,
    );
  }

  logMobileNumberCloseButtonClicked({String flowType = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: mobileNumberCloseButtonClicked,
        attributeName: {"flow": flowType});
  }

  logMobileNumberContinueAfterEditing({String flowType = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: mobileNumberContinueAfterEditing,
        attributeName: {"flow": flowType});
  }

  logMobileNumberContinueWithoutEditing({String flowType = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: mobileNumberContinueWithoutEditing,
        attributeName: {"flow": flowType});
  }

  logAABotfBenefitsCrossClicked() {
    trackWebEngageEventWithAttribute(eventName: aaBotfBenefitsCrossClicked);
  }

  logBotfBenefitsKnowMoreClicked() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfBenefitsKnowMoreClicked,
    );
  }

  logBotfScreenContinueClicked() {
    trackWebEngageEventWithAttribute(
      eventName: aaBotfScreenContinueClicked,
    );
  }
}
