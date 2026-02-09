import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/complete_kyc_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/mixin/personal_details_polling_mixin.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_navigation.dart';

import '../../../../models/app_form_rejection_model.dart';
import '../../../../models/check_app_form_model.dart';

class PersonalDetailsPollingLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        PersonalDetailsPollingMixin,
        AppAnalyticsMixin,
        PersonalDetailsPollingAnalyticsMixin {
  PersonalDetailsPollingNavigation? personalDetailsPollingNavigation;

  PersonalDetailsPollingLogic({this.personalDetailsPollingNavigation});

  late SequenceEngineModel sequenceEngineModel;

  CompleteKycRepository completeKycRepository = CompleteKycRepository();

  static const String OFFER_APPROVED = 'approved';
  static const String OFFER_REJECTED = 'rejected';

  static const String PERSONAL_DETAILS_POLLING = "personal_details_polling";

  void onAfterLayout() {
    personalDetailsPollingNavigation?.toggleAppBarVisibility(false);
    _getSequenceEngineModel();
    logPersonalDetailsPollingFullScreenLoaded();
    logPersonalDetailsPollingStarted();
    _getPersonalDetailsPollingStatus();
  }

  _getSequenceEngineModel() {
    if (personalDetailsPollingNavigation != null) {
      _onSequenceEngineDetailsFetched();
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING);
    }
  }

  void _onSequenceEngineDetailsFetched() {
    sequenceEngineModel =
        personalDetailsPollingNavigation!.getSequenceEngineDetails();
  }

  _getPersonalDetailsPollingStatus() async {
    await getPersonalDetailsStatus(
        onApiError: _onPollingError,
        onRejected: _onAppFormRejectionNavigation,
        onSuccess: _personalDetailsPollingSuccess,
        sequenceEngineModel: sequenceEngineModel,
        requestPayload: _fetchRequestPayload());
  }

  _personalDetailsPollingSuccess(CheckAppFormModel checkAppFormModel) {
    _toggleBackDisabled(isBackDisabled: false);
    personalDetailsPollingNavigation?.toggleAppBarVisibility(true);
    if (personalDetailsPollingNavigation != null) {
      personalDetailsPollingNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING);
    }
  }

  _onPollingError(ApiResponse apiResponse) {
    stopPolling();
    handleAPIError(
      ApiResponse(state: ResponseState.failure, apiResponse: ""),
      screenName: PERSONAL_DETAILS_POLLING,
      retry: _getPersonalDetailsPollingStatus,
    );
  }

  _fetchRequestPayload() {
    if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestPayload;
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (personalDetailsPollingNavigation != null) {
      personalDetailsPollingNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING);
    }
  }

  void _toggleBackDisabled({required bool isBackDisabled}) {
    if (personalDetailsPollingNavigation != null) {
      personalDetailsPollingNavigation!
          .toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING);
    }
  }

  @override
  void onClose() {
    Get.log("pd polling close called");
    stopPolling();
    super.onClose();
  }

  onClosePressed() {
    logPersonalDetailsPollingFullScreenClosed();
    stopPolling();
    Get.back();
  }

  stopOfferPolling() {
    stopPolling();
  }

  startOfferPolling() {
    _getPersonalDetailsPollingStatus();
  }
}
