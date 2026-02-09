import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';

import '../../../../api/response_model.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../data/repository/on_boarding_repository/verify_bank_statement_repository.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../low_and_grow_user_states.dart';
import 'low_and_grow_agreement_navigation.dart';

class LowAndGrowAgreementLogic extends GetxController
    with LowAndGrowMixin, AppFormMixin, ApiErrorMixin {
  LowAndGrowAgreementNavigation? lowAndGrowAgreementNavigation;

  bool _isButtonLoading = false;

  late String LOW_AND_GROW_AGREEMENT_PAGE = "low_and_grow_agreement";

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update(['low_and_grow_accept_button_id']);
    if (lowAndGrowAgreementNavigation != null) {
      lowAndGrowAgreementNavigation!
          .toggleBack(isBackDisabled: isPageLoading || isButtonLoading);
    } else {
      onNavigationNull("LOW_AND_GROW_AGREEMENT_PAGE");
    }
  }

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update(['low_and_grow_agreement_id']);
    if (lowAndGrowAgreementNavigation != null) {
      lowAndGrowAgreementNavigation!
          .toggleBack(isBackDisabled: isPageLoading || isButtonLoading);
    } else {
      onNavigationNull("LOW_AND_GROW_AGREEMENT_PAGE");
    }
  }

  void afterLayout() {
    isPageLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.lgLineAgreementScreenLoaded);
    getPDFUrl();
  }

  String pdfDownloadURL = "";
  final String fileName = "ENHANCED_OFFER_LOAN_AGREEMENT";

  onAcceptPressed() async {
    isButtonLoading = true;

    CheckAppFormModel model = await VerifyBankStatementRepository()
        .getEnhancedOfferAgreementAccepted();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        onLineAgreementAccept();
        isButtonLoading = false;
        return model.responseBody;
      default:
        handleAPIError(model.apiResponse,
            screenName: LOW_AND_GROW_AGREEMENT_PAGE, retry: onAcceptPressed);
    }
  }

  getPDFUrl() async {
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getEnhancedOfferAgreement();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        pdfDownloadURL = model.responseBody;
        isButtonLoading = false;
        isPageLoading = false;
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: LOW_AND_GROW_AGREEMENT_PAGE, retry: getPDFUrl);
    }
  }

  onLineAgreementAccept() async {
    var appFormId = await AppAuthProvider.appFormID;
    if (lowAndGrowAgreementNavigation != null) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgLineAgreementAccepted,
          attributeName: {"appFormId": appFormId});
      lowAndGrowAgreementNavigation!.navigateUserToState(
        lowAndGrowStates: LowAndGrowUserStates.success,
      );
    } else {
      onNavigationNull("LOW_AND_GROW_AGREEMENT_PAGE");
    }
  }
}
