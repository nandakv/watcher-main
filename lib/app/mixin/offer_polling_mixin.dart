import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/home_screen_module/home_page_state_maps.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';

import '../services/polling_service.dart';
import '../utils/apps_flyer_constants.dart';

class OfferPollingMixin {
  late Function(ApiResponse) _onApiError;
  late Function(AppFormRejectionModel appFormRejectionModel) _onRejected;
  late Function(CheckAppFormModel) _onSuccess;
  late CheckAppFormModel _model;
  late Map<String, dynamic> _requestPayload;
  late SequenceEngineModel _sequenceEngineModel;

  final _pollingService = PollingService();

  getOfferStatus(
      {required Function(ApiResponse) onApiError,
      required Function(AppFormRejectionModel appFormRejectionModel) onRejected,
      required Function(CheckAppFormModel checkAppFormModel) onSuccess,
      required Map<String, dynamic> requestPayload,
      required SequenceEngineModel sequenceEngineModel}) async {
    _onApiError = onApiError;
    _onRejected = onRejected;
    _onSuccess = onSuccess;
    _sequenceEngineModel = sequenceEngineModel;
    _requestPayload = requestPayload;

    _pollingService.initAndStartPolling(
      pollingInterval: sequenceEngineModel.onPolling?.callFrequency ?? 5,
      maxPollingLimit: sequenceEngineModel.onPolling?.maxCalls,
      pollingFunction: startPolling,
      onRetryFinished: () {
        Get.back();
      },
    );
  }

  startPolling() async {
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(_sequenceEngineModel)
            .makeHttpRequest(body: _requestPayload);
    _model = checkAppFormModel;
    switch (_model.apiResponse.state) {
      case ResponseState.success:
        _onGetAppFormStatus();
        break;
      default:
        _onApiError(_model.apiResponse);
    }
  }

  stopPolling() {
    _pollingService.stopPolling();
  }

  void _onGetAppFormStatus() async {
    if (_model.appFormRejectionModel.isRejected) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.bureauReject);
      _pollingService.stopPolling();
      _onRejected(_model.appFormRejectionModel);
    } else {
      _checkOfferStatus();
    }
  }

  void _checkOfferStatus() async {
    try{
      if(_model.responseBody["polling_status"] == "COMPLETE"){
        _logAppAnalytics();
        _pollingService.stopPolling();
        _onSuccess(_model);
      }
    } catch (e){
      Get.log("offer key not found - $e");
    }
  }

  void _logAppAnalytics() {
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.bureauSuccess);
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.cpcOverAllApproved);
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.offerApproved);

    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: 'Offer Polling Success',
      attributeName: {
        'app_state': OFFER_DETAILS_KEY,
      },
    );
  }
}
