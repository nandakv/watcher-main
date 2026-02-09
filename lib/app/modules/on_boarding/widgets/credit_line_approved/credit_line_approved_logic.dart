import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/complete_kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/credit_limit_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_navigation.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../../utils/web_engage_constant.dart';

class CreditLineApprovedLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingCreditLineApprovedNavigation?
      onBoardingCreditLineApprovedNavigation;

  CreditLimitRepository creditLimitRepository = CreditLimitRepository();

  late String CREDIT_LINE_APPROVED_SCREEN = "credit_line_approved_screen";

  CreditLineApprovedLogic({this.onBoardingCreditLineApprovedNavigation});

  late SequenceEngineModel sequenceEngineModel;

  final String CONTINUE_BUTTON = 'continue_button';

  double approvedLimit = 0;
  double roi = 0;

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (onBoardingCreditLineApprovedNavigation != null) {
      onBoardingCreditLineApprovedNavigation!
          .toggleBack(isBackDisabled: _isPageLoading);
    } else {
      onNavigationDetailsNull(CREDIT_LINE_APPROVED_SCREEN);
    }
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([CONTINUE_BUTTON]);
    if (onBoardingCreditLineApprovedNavigation != null) {
      onBoardingCreditLineApprovedNavigation!
          .toggleBack(isBackDisabled: _isPageLoading);
    } else {
      onNavigationDetailsNull(CREDIT_LINE_APPROVED_SCREEN);
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingCreditLineApprovedNavigation != null) {
      sequenceEngineModel =
          onBoardingCreditLineApprovedNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(CREDIT_LINE_APPROVED_SCREEN);
    }
  }

  ///Checks final offer in the final offer screen
  checkFinalOffer() async {
    onBoardingCreditLineApprovedNavigation?.toggleAppBarVisibility(false);
    isPageLoading = true;

    CheckAppFormModel checkAppFormModel =
        await creditLimitRepository.createCreditLinePost();

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _fetchAvailableLimit();
        break;
      default:
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: CREDIT_LINE_APPROVED_SCREEN, retry: checkFinalOffer);
    }
  }

  _fetchAvailableLimit() async {
    CreditLimitModel creditLimitModel =
        await creditLimitRepository.getWithdrawalLimitDetails();
    switch (creditLimitModel.apiResponse.state) {
      case ResponseState.success:
        _onCreditLineCreateSuccess(creditLimitModel);
        break;
      default:
        handleAPIError(creditLimitModel.apiResponse,
            screenName: CREDIT_LINE_APPROVED_SCREEN, retry: checkFinalOffer);
    }
  }

  void _onCreditLineCreateSuccess(CreditLimitModel creditLimitModel) {
    if (creditLimitModel.approvedLimit != null &&
        creditLimitModel.roi != null) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.creditLineActive);
      approvedLimit = creditLimitModel.approvedLimit!;
      roi = creditLimitModel.roi!;
      isPageLoading = false;
    } else {
      isPageLoading = false;
      handleAPIError(
          ApiResponse(
            state: ResponseState.failure,
            apiResponse: "",
            exception: "Approved Limit is null",
          ),
          screenName: CREDIT_LINE_APPROVED_SCREEN);
    }
  }

  onContinuePressed() async {
    isButtonLoading = true;
    _getSequenceEngineModel();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: {});
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        isButtonLoading = false;
        await AppAnalytics.trackWebEngageUser(
            userAttributeName: "CreditLinLineLActivationDate",
            userAttributeValue: AppAnalytics.dateTimeNow());
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.proceedToWithdraw);
        navigateToNextScreen(checkAppFormModel);
        break;
      default:
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: CREDIT_LINE_APPROVED_SCREEN,
          retry: onContinuePressed,
        );
    }
  }

  navigateToNextScreen(CheckAppFormModel checkAppFormModel) async {
    if (onBoardingCreditLineApprovedNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingCreditLineApprovedNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(CREDIT_LINE_APPROVED_SCREEN);
    }
  }
}
