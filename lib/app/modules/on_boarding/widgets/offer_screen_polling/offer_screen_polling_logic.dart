import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/complete_kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/offer_polling_mixin.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_screen_polling/offer_screen_polling_navigation.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../models/app_form_rejection_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../services/preprocessor_service/preprocessor_service.dart';

class OfferScreenPollingLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, OfferPollingMixin {
  OnBoardingOfferScreenPollingNavigation?
      onBoardingOfferScreenPollingNavigation;

  OfferScreenPollingLogic({this.onBoardingOfferScreenPollingNavigation});

  late SequenceEngineModel sequenceEngineModel;

  CompleteKycRepository completeKycRepository = CompleteKycRepository();

  static const String OFFER_APPROVED = 'approved';
  static const String OFFER_REJECTED = 'rejected';

  static const String OFFER_SCREEN_POLLING = "offer_screen_polling";

  void onAfterLayout() {
    onBoardingOfferScreenPollingNavigation?.toggleAppBarVisibility(false);
    _getSequenceEngineModel();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: 'Entered Polling Screen');
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.cpcProcessingScreen);
    _offerRequest();
  }

  // void startPolling() async {
  //   if (_enablePolling) {
  //     _offerRequest();
  //   }
  // }

  List<String> computePollingBody() {
    if (onBoardingOfferScreenPollingNavigation?.isPartnerFlow() ?? false) {
      return [
        "Give us a minute while we find the best offer for you",
        "Evaluating credit profile…",
      ];
    } else {
      return [
        "Give us a minute for checking eligibility…",
        "Evaluating credit profile…",
      ];
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingOfferScreenPollingNavigation != null) {
      _onSequenceEngineDetailsFetched();
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  void _onSequenceEngineDetailsFetched() {
    sequenceEngineModel =
        onBoardingOfferScreenPollingNavigation!.getSequenceEngineDetails();
  }

  _getMethodType() {
    if (onBoardingOfferScreenPollingNavigation != null) {
      return onBoardingOfferScreenPollingNavigation!
          .computeMethodFromSequenceEngine();
    }
  }

  _offerRequest() async {
    await getOfferStatus(
        onApiError: (ApiResponse apiResponse) {
          handleAPIError(
              ApiResponse(state: ResponseState.failure, apiResponse: ""),
              screenName: OFFER_SCREEN_POLLING,
              retry: _offerRequest);
        },
        onRejected: _onAppFormRejectionNavigation,
        onSuccess: _onOfferPollingSuccess,
        sequenceEngineModel: sequenceEngineModel,
        requestPayload: _fetchRequestPayload());
  }

  _onOfferPollingSuccess(CheckAppFormModel checkAppFormModel) {
    _toggleBackDisabled(isBackDisabled: false);
    if (onBoardingOfferScreenPollingNavigation != null) {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: 'Offer Polling Success',
        attributeName: {
          'app_state': OFFER_POLLING,
        },
      );
      onBoardingOfferScreenPollingNavigation!.navigateUserToAppStage(
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
    if (onBoardingOfferScreenPollingNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.offerejected);
      onBoardingOfferScreenPollingNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN_POLLING);
    }
  }

  void _toggleBackDisabled({required bool isBackDisabled}) {
    if (onBoardingOfferScreenPollingNavigation != null) {
      onBoardingOfferScreenPollingNavigation!
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
}
