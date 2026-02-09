import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin InitialOfferPollingAnalyticsMixin on AppAnalyticsMixin {
  late final String sbdMachineOfferPollingLoaded =
      "SBD_Machine_Offer_Polling_Loaded";
  late final String sbdMachineOfferRejected = "SBD_Machine_Offer_Rejected";

  logSbdMachineOfferPollingLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdMachineOfferPollingLoaded,
    );
    logAppsFlyerEvent(eventName: "Machine_Offer_Polling_SBD");
  }

  logSbdMachineOfferRejected() {
    trackWebEngageEventWithAttribute(
      eventName: sbdMachineOfferRejected,
    );
  }
}
