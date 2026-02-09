import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_mixin.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_user_states.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/low_and_grow_offer_navigation.dart';

import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../../on_boarding/mixins/app_form_mixin.dart';
import 'model/low_and_grow_enhanced_offer_model.dart';

class LowAndGrowOfferLogic extends GetxController
    with LowAndGrowMixin, ApiErrorMixin, AppFormMixin {
  static const String LOW_AND_GROW_OFFER_PAGE = "low_and_grow_offer_page";

  LowAndGrowOfferNavigation? lowAndGrowOfferNavigation;
  late LowAndGrowEnhancedOfferModel model;

  bool _isConsentChecked = false;

  bool get isConsentChecked => _isConsentChecked;

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: _isConsentChecked == true
            ? WebEngageConstants.lgConsentBoxTicked
            : WebEngageConstants.lgConsentBoxUnTicked);
    update(["SPECIAL_OFFER_CHECK_BOX_KEY", "button"]);
  }

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  ///toggles the check box value to true or false
  toggleIsChecked(bool val) {
    isConsentChecked = val;
  }

  onUpgradePressed() {
    if (lowAndGrowOfferNavigation != null) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgUpgradeNowClicked);
      lowAndGrowOfferNavigation!.navigateUserToState(
        lowAndGrowStates: LowAndGrowUserStates.polling,
      );
    } else {
      onNavigationNull(LOW_AND_GROW_OFFER_PAGE);
    }
  }

  final List<String> termAndConditionPolicyList = [
    "The upgraded credit limit offer is subject to eligibility criteria and \n credit assessment.",
    "This offer is valid for a limited time only.",
    "The upgraded credit limit is based on your credit behaviour and \n repayment history .",
    "Acceptance of the upgraded credit limit offer is voluntary and \n requires your consent.",
    "By accepting the offer, you agree to abide by the terms and \n conditions of the Credit Saison India mobile app and the loan agreement.",
    "The upgraded credit limit terms will be effective for the new \n withdrawals."
  ];
}
