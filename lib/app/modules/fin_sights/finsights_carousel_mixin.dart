import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/fin_sights/finsights_popup_model.dart';
import '../../../res.dart';

mixin FinSightsCarouselMixin on AppAnalyticsMixin {
  late final List<FinSightsPopUpModel> finSightsScrollList = [
    FinSightsPopUpModel(
        img: Res.finsightsBlue,
        title: 'Introducing FinSights',
        subTitle:
            'Track, analyse, and manage all your accounts in one secure place'),
    FinSightsPopUpModel(
        img: Res.finsights3Steps,
        title: 'A Simple 3-Step Process',
        subTitle:
            "Connect, authorise, and manage your financial accounts with transparency and security"),
    FinSightsPopUpModel(
        img: Res.finsightsFinancial,
        title: 'Unlock Smart Financial Benefits',
        subTitle:
            "Gain holistic insights, enhance credit access, and enjoy quicker loan approval, all in one place"),
  ];

  late final String backButtonClicked = "Back_Button_Clicked";

  late final String storyModeLoadedHome = "Story_Mode_Loaded_Home";
  late final String storyModeExploreClicked = "Story_Mode_Explore_Clicked";
  late final String storyModeNotNowClicked = "Story_Mode_Not_Now_Clicked";

  late final String mobileNumberContinueWithoutEditing =
      "Mobile_Number_Continue_Without_Editing";
  late final String mobileNumberContinueAfterEditing =
      "Mobile_Number_Continue_After_Editing";
  late final String mobileNumberCloseButtonClicked =
      "Mobile_Number_Close_Button_Clicked";

// Functions to log events
  void logStoryModeLoadedHome() {
    trackWebEngageEventWithAttribute(eventName: storyModeLoadedHome);
  }

  void logStoryModeExploreClicked() {
    trackWebEngageEventWithAttribute(eventName: storyModeExploreClicked);
  }

  void logStoryModeNotNowClicked() {
    trackWebEngageEventWithAttribute(eventName: storyModeNotNowClicked);
  }

  void logMobileNumberContinueWithoutEditing({required String flowType}) {
    trackWebEngageEventWithAttribute(
        eventName: mobileNumberContinueWithoutEditing,attributeName: {"flow_type": flowType});
  }

  void logMobileNumberContinueAfterEditing({required String flowType}) {
    trackWebEngageEventWithAttribute(
        eventName: mobileNumberContinueAfterEditing,attributeName: {"flow_type": flowType});
  }

  void logMobileNumberCloseButtonClicked({required String flowType}) {
    trackWebEngageEventWithAttribute(eventName: mobileNumberCloseButtonClicked,attributeName: {"flow_type": flowType});
  }

  void logBackButtonClicked(String pageName) {
    trackWebEngageEventWithAttribute(
        eventName: backButtonClicked, attributeName: {"page name": pageName});
  }
}
