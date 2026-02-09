import 'package:get/get.dart';

import '../../../../../firebase/analytics.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/web_engage_constant.dart';

class PartnerHomeScreenMixin {
  void partnerFlowKnowMore(String partnerLimitAmount) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.partnerDirectionalOfferHomePageKnowMore);

    Get.toNamed(Routes.PARTNER_OFFER_DETAILS_SCREEN,
        arguments: {"limitAmount": partnerLimitAmount});
  }

  void partnerFlowGetStartedEvent() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName:
            WebEngageConstants.partnerDirectionalOfferHomePageGetStartedCTA);
  }

  void onPartnerHomeAfterFirstLayout() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.partnerDirectionalOfferHomePageLoaded);
  }
}
