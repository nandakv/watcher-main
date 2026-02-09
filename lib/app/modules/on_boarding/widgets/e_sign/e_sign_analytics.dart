import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin ESignAnalytics on AppAnalyticsMixin {

  // Variables
  late String eSignLoaded = "ESign_Loaded";
  late String eSignReviewAcceptClicked = "ESign_Review_Accept_Clicked";
  late String eSignSuccessLoaded = "ESign_Success_Loaded";
  late String disbursementInProgress = "Disbursement_In_Progress";

// Functions
  void logESignLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: eSignLoaded,
    );
  }

  void logESignReviewAcceptClicked() {
    trackWebEngageEventWithAttribute(
      eventName: eSignReviewAcceptClicked,
    );
  }

  void logESignSuccessLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: eSignSuccessLoaded,
    );
  }

  void logDisbursementInProgress() {
    trackWebEngageEventWithAttribute(
      eventName: disbursementInProgress,
    );
  }


}