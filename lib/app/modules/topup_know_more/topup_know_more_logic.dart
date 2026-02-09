import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/topup_know_more_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/topup_know_more/model/topup_eligibility_details.dart';
import 'package:privo/app/modules/topup_know_more/top_up_know_more_analytics.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_arguments.dart';
import 'package:privo/res.dart';

import '../../models/check_app_form_model.dart';

class TopUpKnowMoreLogic extends GetxController
    with ApiErrorMixin, AppAnalyticsMixin, TopUpKnowMoreAnalytics {
  TopUpKnowMoreArguments arguments = Get.arguments;

  late final List<TopUpEligibilityDetails> topUpEligibilityDetailsList = [
    TopUpEligibilityDetails(
      iconPath: Res.topupTime,
      title: "Pay your EMIs on time.",
    ),
    TopUpEligibilityDetails(
      iconPath: Res.topupCreditScore,
      title: "Maintain a Good Credit Score",
    ),
    TopUpEligibilityDetails(
      iconPath: Res.topupPayEarly,
      title: "Pay EMI Early to Boost Credit",
    ),
  ];

  late final String TOPUP_KNOW_MORE_SCREEN = "topup_know_more_screen";

  late final String CONSENT_CHECKBOX_ID = "consent_checkbox";
  late final String BUTTON_ID = "button";

  bool _isConsentChecked = false;

  bool get isConsentChecked => _isConsentChecked;

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID]);
  }

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    update([CONSENT_CHECKBOX_ID, BUTTON_ID]);
  }

  onConsentValueChanged(bool? val) {
    if (val != null) {
      isConsentChecked = val;
    }
  }

  @override
  void onInit() {
    super.onInit();
    logTopUpKnowMorePageLoaded();
  }

  String computeButtonTitle() {
    if (arguments.isEligible) {
      return "Start now";
    } else {
      return "Notify me";
    }
  }

  onButtonTapped() async {
    logTopUpKnowMoreGetStarted();
    isButtonLoading = true;
    Map<String, String> body = {
      "consentType": "topUp",
      "consentStatus": "YES",
    };
    CheckAppFormModel model =
        await TopUpKnowMoreRepository().recordConsent(body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isButtonLoading = false;
        Get.back(result: true);
        break;
      default:
        isButtonLoading = false;
        handleAPIError(
          model.apiResponse,
          screenName: TOPUP_KNOW_MORE_SCREEN,
          retry: onButtonTapped,
        );
    }
  }
}
