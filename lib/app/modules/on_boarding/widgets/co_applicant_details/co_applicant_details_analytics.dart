import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin CoApplicantDetailsAnalytics on AppAnalyticsMixin {
  late String sbdPartnershipLlpCoApplicantLoaded =
      "SBD_ParntershipLLP_Co_Applicant_Loaded";
  late String sbdDesignationInput = "SBD_Deisgnation_Input";
  late String sbdShareholdingInput = "SBD_Shareholding_Input";
  late String sbdCoapplicantPageLoaded = "SBD_Coapplicant_Page_Loaded";
  late String sbdCoapplicantAdded = "SBD_Coapplicant_Added";
  late String sbdAddMoreCoapplicantClicked = "SBD_AddMore_Coapplicant_Clicked";
  late String sbdCoapplicantPageSaved = "SBD_Coapplicant_Page_Saved";
  late String sbdExperianPollingLoaded = "SBD_Experian_Polling_Loaded";
  late String sbdExperianRejection = "SBD_Experian_Rejection";

  void logSbdPartnershipLlpCoApplicantLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdPartnershipLlpCoApplicantLoaded,
    );
  }

  logInputEvents(bool isFinalOfferPolling) {
    trackWebEngageEventWithAttribute(
      eventName: sbdDesignationInput,
      attributeName: {
        "final offer Jarvis": isFinalOfferPolling,
      },
    );
    trackWebEngageEventWithAttribute(
      eventName: sbdShareholdingInput,
      attributeName: {
        "final offer Jarvis": isFinalOfferPolling,
      },
    );
  }

  void logSbdCoapplicantPageLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdCoapplicantPageLoaded,
    );
  }

  void logSbdCoapplicantAdded(bool isFinalOfferPolling) {
    trackWebEngageEventWithAttribute(
      eventName: sbdCoapplicantAdded,
      attributeName: {
        "final offer Jarvis": isFinalOfferPolling,
      },
    );
  }

  void logSbdAddMoreCoApplicantClicked(bool isFinalOfferPolling) {
    trackWebEngageEventWithAttribute(
      eventName: sbdAddMoreCoapplicantClicked,
      attributeName: {
        "final offer Jarvis": isFinalOfferPolling,
      },
    );
  }

  void logSbdCoApplicantPageSaved(int length, bool isFinalOfferPolling) {
    trackWebEngageEventWithAttribute(
      eventName: sbdCoapplicantPageSaved,
      attributeName: {
        'no of coapplicants': length,
        "final offer Jarvis": isFinalOfferPolling,
      },
    );
  }

  void logSbdExperianPollingLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdExperianPollingLoaded,
      attributeName: {
        "SBD_Experian_Polling_Loaded": true,
      },
    );
    logAppsFlyerEvent(eventName: "Experian_Polling_SBD");
  }

  void logSbdExperianRejection() {
    trackWebEngageEventWithAttribute(
      eventName: sbdExperianRejection,
      attributeName: {
        "SBD_Experian_Rejection": true,
      },
    );
  }
}
