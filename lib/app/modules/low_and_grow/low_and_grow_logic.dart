import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_navigation_base.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_user_states.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_agreement/low_and_grow_agreement_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_agreement/low_and_grow_agreement_navigation.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/low_and_grow_offer_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/low_and_grow_offer_navigation.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/model/low_and_grow_enhanced_offer_model.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/model/special_offer_model.dart';

import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_success/low_and_grow_success_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_success/low_and_grow_success_navigation.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_waiting/low_and_grow_wait_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_waiting/low_and_grow_wait_navigation.dart';

import '../../api/response_model.dart';
import '../../firebase/analytics.dart';
import '../../utils/snack_bar.dart';
import '../../utils/web_engage_constant.dart';
import '../on_boarding/mixins/app_form_mixin.dart';

class LowAndGrowLogic extends GetxController
    with AppFormMixin, ApiErrorMixin
    implements
        LowAndGrowNavigationBase,
        LowAndGrowAgreementNavigation,
        LowAndGrowOfferNavigation,
        LowAndGrowWaitNavigation,
        LowAndGrowSuccessNavigation {
  final String LOW_AND_GROW_SCREEN_ID = "low_and_grow_screen_id";

  LowAndGrowUserStates _lowAndGrowUserStates = LowAndGrowUserStates.loading;
  late LowAndGrowEnhancedOfferModel model;

  LowAndGrowUserStates get lowAndGrowUserStates => _lowAndGrowUserStates;

  set lowAndGrowUserStates(LowAndGrowUserStates value) {
    _lowAndGrowUserStates = value;
    update([LOW_AND_GROW_SCREEN_ID]);
  }

  late String LOW_AND_GROW_SCREEN = "low_and_grow";

  bool _isLoading = true;

  afterLayout() async {
    _computeGetAppForm();
  }

  _computeGetAppForm() async {
    getAppForm(
      onSuccess: _onAppFormApiSuccess,
      onApiError: _onAppFormApiError,
      onRejected: (appform) {},
    );
  }

  _onAppFormApiSuccess(AppForm appForm) async {
    await _enhancedOfferDetails(appForm);
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    handleAPIError(
      apiResponse,
      screenName: LOW_AND_GROW_SCREEN,
      retry: _computeGetAppForm,
    );
  }

  _enhancedOfferDetails(AppForm appForm) async {
    try {
      model = LowAndGrowEnhancedOfferModel.fromJson(appForm.responseBody);
      _isLoading = false;
      lowAndGrowUserStates = LowAndGrowUserStates.offer;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgOfferProcessingLoaded);
    } catch (e) {
      handleAPIError(
        ApiResponse(
          state: ResponseState.jsonParsingError,
          apiResponse: "",
          exception: e.toString(),
        ),
        screenName: LOW_AND_GROW_SCREEN,
      );
    }
  }

  @override
  void onInit() {
    final agreementLogic = Get.find<LowAndGrowAgreementLogic>();
    agreementLogic.lowAndGrowAgreementNavigation = this;

    final offerLogic = Get.find<LowAndGrowOfferLogic>();
    offerLogic.lowAndGrowOfferNavigation = this;

    final pollingLogic = Get.find<LowAndGrowWaitLogic>();
    pollingLogic.lowAndGrowPollingNavigation = this;

    final successLogic = Get.find<LowAndGrowSuccessLogic>();
    successLogic.lowAndGrowSuccessNavigation = this;
    super.onInit();
  }

  @override
  navigateUserToState({required LowAndGrowUserStates lowAndGrowStates}) {
    lowAndGrowUserStates = lowAndGrowStates;
  }

  @override
  toggleBack({required bool isBackDisabled}) {
    _isLoading = isBackDisabled;
  }

  String computeEnhancedTenureText() {
    return "${model.enhancedOfferSection!.minTenure} - ${model.enhancedOfferSection!.maxTenure} months";
  }

  String computeTenureText() {
    return "${model.offerSection!.minTenure.toInt()} - ${model.offerSection!.maxTenure.toInt()} months";
  }

  @override
  navigateToSuccessScreen() {
    LowAndGrowUserStates lowAndGrowUserStates = LowAndGrowUserStates.success;
    return lowAndGrowUserStates;
  }

  onBackPressed() {
    if (_isLoading) {
      AppSnackBar.successBar(title: 'Loading', message: 'Please Wait');
      return false;
    }
    return true;
  }

  computeSpecialOfferDetails() {
    return SpecialOffer(
        upgradedLimitAmount: model.upgradedFeatures!.limitAmount,
        upgradedInterest: model.upgradedFeatures!.interest,
        upgradedTenure: model.upgradedFeatures!.tenure,
        upgradedPF: model.upgradedFeatures!.processingFee,
        enhancedLimitAmount: model.enhancedOfferSection!.limitAmount,
        enhancedInterest: model.enhancedOfferSection!.interest,
        enhancedProcessingFee: model.enhancedOfferSection!.processingFee,
        enhancedTenure: computeEnhancedTenureText());
  }
}
