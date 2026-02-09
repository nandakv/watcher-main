import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/mixin/offer_polling_mixin.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer_polling/initial_offer_polling_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../../../models/app_form_rejection_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/home_screen_model.dart';
import 'initial_offer_polling_navigation.dart';

class InitialOfferPollingLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        OfferPollingMixin,
        AppAnalyticsMixin,
        InitialOfferPollingAnalyticsMixin {
  OnBoardingInitialOfferPollingNavigation?
      onBoardingInitialOfferPollingNavigation;

  InitialOfferPollingLogic({this.onBoardingInitialOfferPollingNavigation});

  late SequenceEngineModel sequenceEngineModel;

  static const String OFFER_APPROVED = 'approved';
  static const String OFFER_REJECTED = 'rejected';

  static const String OFFER_SCREEN_POLLING = "offer_screen_polling";

  bool _pageLoading = true;

  bool get pageLoading => _pageLoading;

  set pageLoading(bool value) {
    _pageLoading = value;
    update();
  }

  void onAfterLayout() {
    _computeTitleAndBodyText();
    _getSequenceEngineModel();
    logSbdMachineOfferPollingLoaded();
    _offerRequest();
  }

  late List<String> pollingTitles = [];
  late List<String> pollingBodyText = [
    "Almost there! We are calculating your ideal offer...",
  ];
  late String progressIndicatorText = "";

  _getSequenceEngineModel() {
    if (onBoardingInitialOfferPollingNavigation != null) {
      onBoardingInitialOfferPollingNavigation!.toggleAppBarVisibility(false);
      _onSequenceEngineDetailsFetched();
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  void _onSequenceEngineDetailsFetched() {
    sequenceEngineModel =
        onBoardingInitialOfferPollingNavigation!.getSequenceEngineDetails();
  }

  _offerRequest() async {
    await getOfferStatus(
      onApiError: _onApiError,
      onRejected: _onAppFormRejectionNavigation,
      onSuccess: _onOfferPollingSuccess,
      sequenceEngineModel: sequenceEngineModel,
      requestPayload: _fetchRequestPayload(),
    );
  }

  _onApiError(ApiResponse apiResponse) {
    handleAPIError(ApiResponse(state: ResponseState.failure, apiResponse: ""),
        screenName: OFFER_SCREEN_POLLING, retry: _offerRequest);
  }

  _onOfferPollingSuccess(CheckAppFormModel checkAppFormModel) {
    _toggleBackDisabled(isBackDisabled: false);
    if (onBoardingInitialOfferPollingNavigation != null) {
      onBoardingInitialOfferPollingNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  _fetchRequestPayload() {
    if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestPayload;
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    logSbdMachineOfferRejected();
    if (onBoardingInitialOfferPollingNavigation != null) {
      onBoardingInitialOfferPollingNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  void _toggleBackDisabled({required bool isBackDisabled}) {
    if (onBoardingInitialOfferPollingNavigation != null) {
      onBoardingInitialOfferPollingNavigation!
          .toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  @override
  void onClose() {
    Get.log("offer polling close called");
    stopPolling();
    super.onClose();
  }

  onClosePressed() {
    stopPolling();
    Get.back();
  }

  stopOfferPolling() {
    stopPolling();
  }

  startOfferPolling() {
    _offerRequest();
  }

  _computeTitleAndBodyText() {
    switch (LPCService.instance.activeCard?.lpcCardType) {
      case LPCCardType.loan:
      case LPCCardType.lowngrow:
      case null:
        pollingTitles = ["Hold Tight !"];
        pollingBodyText = [
          "Almost there! We are calculating your ideal offer..."
        ];
        progressIndicatorText =
            "It usually takes less than a minute to complete";
        break;
      case LPCCardType.topUp:
        pollingBodyText = [
          "We’re currently working on your loan offer.\nThank you for your patience"
        ];
        pollingTitles = ["Your Loan Offer is on its Way!"];
        progressIndicatorText = "This should only take a few minutes";
        break;
    }
    pageLoading = false;
  }
}
