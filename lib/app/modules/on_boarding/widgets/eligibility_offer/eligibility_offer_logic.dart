import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../data/repository/on_boarding_repository/offer_repository.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/eligibility_offer_model.dart';
import '../../../../models/sequence_engine_model.dart';
import '../../../../services/preprocessor_service/preprocessor_service.dart';
import '../../../../utils/apps_flyer_constants.dart';
import '../../mixins/app_form_mixin.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../offer/offer_navigation.dart';
import 'package:get/get.dart';

class EligibilityOfferLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, AppFormMixin {
  OnBoardingOfferNavigation? onBoardingEligibilityOfferNavigation;

  EligibilityOfferLogic({this.onBoardingEligibilityOfferNavigation});

  final String BUTTON_ID = 'button';
  static const String ELIGIBILITY_OFFER = 'eligibility_offer';

  late EligibilityOfferModel eligibilityOfferModel;

  OfferRepository offerRepository = OfferRepository();
  late SequenceEngineModel sequenceEngineModel;

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (onBoardingEligibilityOfferNavigation != null) {
      onBoardingEligibilityOfferNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(ELIGIBILITY_OFFER);
    }
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID]);
    if (onBoardingEligibilityOfferNavigation != null) {
      onBoardingEligibilityOfferNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(ELIGIBILITY_OFFER);
    }
  }

  afterLayout() async {
    _fetchEligibilityOfferDetails();
  }

  _fetchEligibilityOfferDetails() async {
    EligibilityOfferModel eligibilityOfferModel =
        await offerRepository.fetchEligibilityOfferDetails();
    switch (eligibilityOfferModel.apiResponse.state) {
      case ResponseState.success:
        this.eligibilityOfferModel = eligibilityOfferModel;
        isPageLoading = false;
        _checkIfAppFormRejected();
        break;
      default:
        handleAPIError(eligibilityOfferModel.apiResponse,
            screenName: ELIGIBILITY_OFFER, retry: afterLayout);
    }
  }

  void _checkIfAppFormRejected() {
    if (eligibilityOfferModel.appFormRejectionModel.isRejected) {
      isButtonLoading = false;
      onBoardingEligibilityOfferNavigation!.onAppFormRejected(
          model: eligibilityOfferModel.appFormRejectionModel);
    }
  }

  onEligibilityOfferKycProceed() async {
    isButtonLoading = true;
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycStarted);

    acceptEligibilityOffer();
  }

  acceptEligibilityOffer() async {
    isButtonLoading = true;

    if (onBoardingEligibilityOfferNavigation != null) {
      _getSequenceEngineModel();
      CheckAppFormModel checkAppFormModel =
          await SequenceEngineRepository(sequenceEngineModel)
              .makeHttpRequest(body: {});
      switch (checkAppFormModel.apiResponse.state) {
        case ResponseState.success:
          isButtonLoading = false;
          _onApiSuccess(checkAppFormModel);
          break;
        default:
          isButtonLoading = false;
          handleAPIError(
            checkAppFormModel.apiResponse,
            screenName: ELIGIBILITY_OFFER,
            retry: acceptEligibilityOffer,
          );
      }
    }
  }

  void _onApiSuccess(CheckAppFormModel checkAppFormModel) {
    PreprocessorService(
      triggerCustomerDeviceDetails: true,
    ).pushOnEligibilityOfferAcceptance(checkAppFormModel);
    if (onBoardingEligibilityOfferNavigation != null) {
      onBoardingEligibilityOfferNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(ELIGIBILITY_OFFER);
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingEligibilityOfferNavigation != null) {
      sequenceEngineModel =
          onBoardingEligibilityOfferNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(ELIGIBILITY_OFFER);
    }
  }
}
