import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin InitialOfferAnalyticsMixin on AppAnalyticsMixin {
  late final String sbdMachineOfferDetailsLoaded =
      "SBD_Machine_Offer_Details_Loaded";
  late final String sbdMachineOfferContinueKYCClicked =
      "SBD_Machine_Offer_Continue_KYC_Clicked";

  logSbdMachineOfferDetailsLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdMachineOfferDetailsLoaded,
    );
    logAppsFlyerEvent(eventName: "Machine_Offer_Loaded_SBD");
  }

  logSbdMachineOfferContinueKYCClicked() {
    trackWebEngageEventWithAttribute(
      eventName: sbdMachineOfferContinueKYCClicked,
    );
  }
}
