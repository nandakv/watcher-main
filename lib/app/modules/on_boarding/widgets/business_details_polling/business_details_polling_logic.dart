import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/business_details_polling/business_details_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_analytics.dart';

import '../../../../api/api_error_mixin.dart';
import '../../../../services/polling_service.dart';

class BusinessDetailsPollingLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppAnalyticsMixin,
        CoApplicantDetailsAnalytics {
  final String BUSINESS_DETAILS_POLLING_SCREEN =
      "BUSINESS_DETAILS_POLLING_SCREEN";

  BusinessDetailsPollingNavigation? navigation;

  BusinessDetailsPollingLogic({this.navigation});

  final _pollingService = PollingService();

  late SequenceEngineModel sequenceEngineModel;

  onAfterLayout() {
    logSbdExperianPollingLoaded();
    _getSequenceEngine();
    startPolling();
  }

  _getSequenceEngine() {
    if (navigation != null) {
      sequenceEngineModel = navigation!.getSequenceEngineDetails();
      navigation!.toggleAppBarVisibility(false);
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_POLLING_SCREEN);
    }
  }

  startPolling() {
    _pollingService.initAndStartPolling(
      pollingInterval: sequenceEngineModel.onPolling?.callFrequency ?? 5,
      maxPollingLimit: sequenceEngineModel.onPolling?.maxCalls,
      pollingFunction: _pollingFunction,
    );
  }

  _pollingFunction() async {
    if (sequenceEngineModel.onPolling != null) {
      CheckAppFormModel model =
          await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
        body: sequenceEngineModel.onPolling!.requestPayload,
      );
      switch (model.apiResponse.state) {
        case ResponseState.success:
          try {
            if (model.responseBody['polling_status'] == 'COMPLETE') {
              _pollingService.stopPolling();
              _checkAppFormRejection(model);
            }
          } catch (e) {
            handleAPIError(model.apiResponse..exception = e.toString(),
                screenName: BUSINESS_DETAILS_POLLING_SCREEN,
                retry: _pollingFunction);
          }
          break;
        default:
          _pollingService.stopPolling();
          handleAPIError(model.apiResponse,
              screenName: BUSINESS_DETAILS_POLLING_SCREEN,
              retry: _pollingFunction);
      }
    } else {
      _pollingService.stopPolling();
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          url: "",
          exception: "Sequence Engine Polling object is null",
        ),
        screenName: BUSINESS_DETAILS_POLLING_SCREEN,
      );
    }
  }

  void _checkAppFormRejection(CheckAppFormModel model) {
    if (model.appFormRejectionModel.isRejected) {
      logSbdExperianRejection();
      _onAppFormRejected(model);
    } else {
      _navigateToNextAppStage(model);
    }
  }

  _onAppFormRejected(CheckAppFormModel model) {
    if (navigation != null) {
      navigation!.onAppFormRejected(model: model.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_POLLING_SCREEN);
    }
  }

  void _navigateToNextAppStage(CheckAppFormModel model) {
    if (navigation != null && model.sequenceEngine != null) {
      navigation!
          .navigateUserToAppStage(sequenceEngineModel: model.sequenceEngine!);
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_POLLING_SCREEN);
    }
  }

  onClosePressed() {
    Get.back();
  }

  onStopPolling() {
    _pollingService.stopPolling();
  }
}
