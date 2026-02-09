import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin AppRatingAnalytics {
  final _analyticsMixin = AppAnalyticsMixin();

  late String appRatingPrompted = "App_Rating_Prompted_V1";
  late String appRatingClosed = "App_Rating_V1_Closed";
  late String appRatingSubmit = "App_Rating_V1_Submit";
  late String appRatingPromptLoaded = "App_Rating_Prompt_Loaded_V1";

  logAppRatingPrompted() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: appRatingPrompted,
    );
  }

  logAppRatingClosed() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: appRatingClosed);
  }

  logAppRatingSubmit(Map<String, dynamic> attributes) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: appRatingSubmit, attributeName: attributes);
  }

  logPlayStoreRatingPrompted(bool isAppRatingAvailable) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: appRatingPromptLoaded, attributeName: {'Is_PlayStore_Rating_Available': isAppRatingAvailable});
  }
}
