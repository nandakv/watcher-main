import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/initial_offer_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/initial_offer_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer/initial_offer_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../mixins/on_boarding_mixin.dart';
import 'package:get/get.dart';

import '../offer/offer_navigation.dart';

class InitialOfferLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppAnalyticsMixin,
        InitialOfferAnalyticsMixin {
  final LPCCardType lpcCardType =
      LPCService.instance.activeCard?.lpcCardType ?? LPCCardType.loan;

  OnBoardingOfferNavigation? onBoardingOfferNavigation;

  late SequenceEngineModel sequenceEngineModel;

  InitialOfferRepository initialOfferRepository = InitialOfferRepository();

  late InitialOfferModel initialOfferModel;

  late final String INITIAL_OFFER_SCREEN = 'initial_offer_screen';
  late final String BUTTON_ID = 'button';

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID]);
  }

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  onKycProceed() {
    logSbdMachineOfferContinueKYCClicked();
    if (onBoardingOfferNavigation != null) {
      _acceptInitialOffer();
    } else {
      onNavigationDetailsNull(INITIAL_OFFER_SCREEN);
    }
  }

  _acceptInitialOffer() async {
    isButtonLoading = true;
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: {});

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _navigateToNextState(checkAppFormModel);
        break;
      default:
        isButtonLoading = false;
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: INITIAL_OFFER_SCREEN, retry: _acceptInitialOffer);
    }
  }

  void _navigateToNextState(CheckAppFormModel checkAppFormModel) {
    onBoardingOfferNavigation?.toggleAppBarVisibility(true);
    if (onBoardingOfferNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingOfferNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(INITIAL_OFFER_SCREEN);
    }
  }

  _fetchInitialOfferDetails() async {
    InitialOfferModel initialOfferDetails =
        await initialOfferRepository.getInitialOfferDetails();
    switch (initialOfferDetails.apiResponse.state) {
      case ResponseState.success:
        initialOfferModel = initialOfferDetails;
        isPageLoading = false;
        logSbdMachineOfferDetailsLoaded();
        _getSequenceEngineModel();
        break;
      default:
        handleAPIError(
          initialOfferDetails.apiResponse,
          screenName: INITIAL_OFFER_SCREEN,
          retry: _fetchInitialOfferDetails,
        );
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingOfferNavigation != null) {
      sequenceEngineModel =
          onBoardingOfferNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(INITIAL_OFFER_SCREEN);
    }
  }

  afterLayout() {
    onBoardingOfferNavigation?.toggleAppBarVisibility(false);
    _fetchInitialOfferDetails();
  }

  String computeButtonText() {
    switch (lpcCardType) {
      case LPCCardType.loan:
      case LPCCardType.lowngrow:
        return "Continue to KYC";
      case LPCCardType.topUp:
        return "Continue";
    }
  }

  String computeNoteText() {
    switch (lpcCardType) {
      case LPCCardType.loan:
      case LPCCardType.lowngrow:
        return "This is your preliminary offer. Your final offer is curated once you complete your KYC";
      case LPCCardType.topUp:
        return "This is your preliminary offer. Please complete the next steps to receive your final offer";
    }
  }
}
