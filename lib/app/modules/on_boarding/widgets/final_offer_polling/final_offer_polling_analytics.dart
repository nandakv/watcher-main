import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin FinalOfferPollingAnalytics on AppAnalyticsMixin {
  late String additionalDetailsLoaded = "Additional_Details_Loaded";
  late String additionalDocumentClicked = "Additional_Document_Clicked";
  late String additionalDocumentUploaded = "Additional_Document_Uploaded";
  late final String finalOfferInProgress =
      "Final_Offer_Jarvis_InProgress_Loaded_BL";

  void logFinalOfferInProgress() {
    trackWebEngageEventWithAttribute(eventName: finalOfferInProgress);
  }

  void logAdditionalDetailsLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: additionalDetailsLoaded,
    );
  }

  void logAdditionalDocumentClicked() {
    trackWebEngageEventWithAttribute(
      eventName: additionalDocumentClicked,
    );
  }

  void logAdditionalDocumentUploaded() {
    trackWebEngageEventWithAttribute(
      eventName: additionalDocumentUploaded,
    );
  }
}
