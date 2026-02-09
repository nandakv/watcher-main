import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

class KycPollingMixin {
  String _QC_APPROVED_STATUS = "COMPLETE";

  late Function(ApiResponse) _onApiError;
  late Function(AppFormRejectionModel rejectionModel) _onRejected;
  late Function(CheckAppFormModel checkAppFormModel) _onSuccess;
  late Map<String, dynamic> _requestPayload;
  late SequenceEngineModel _sequenceEngineModel;

  startKycPolling(
      {required Function(ApiResponse) onApiError,
      required Function(AppFormRejectionModel rejectionModel) onRejected,
      required SequenceEngineModel sequenceEngineModel,
      required Map<String, dynamic> requestPayload,
      required Function(CheckAppFormModel model) onSuccess}) async {
    _onApiError = onApiError;
    _onRejected = onRejected;
    _onSuccess = onSuccess;
    _sequenceEngineModel = sequenceEngineModel;
    _requestPayload = requestPayload;

    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: requestPayload);

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _onGetAppFormStatus(checkAppFormModel);
        break;
      default:
        _onApiError(checkAppFormModel.apiResponse);
    }
  }

  void _onGetAppFormStatus(CheckAppFormModel checkAppFormModel) async {
    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycRejected);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.kycVerificationFailureScreenLoaded);
      _onRejected(checkAppFormModel.appFormRejectionModel);
    } else {
      _checkQCStatus(checkAppFormModel);
    }
  }

  void _checkQCStatus(CheckAppFormModel checkAppFormModel) async {
    if (checkAppFormModel.responseBody["polling_status"] ==
        _QC_APPROVED_STATUS) {
      _onKycSuccess(checkAppFormModel);
    } else {
      await Future.delayed(const Duration(seconds: 5));
      startKycPolling(
          onApiError: _onApiError,
          onRejected: _onRejected,
          sequenceEngineModel: _sequenceEngineModel,
          requestPayload: _requestPayload,
          onSuccess: _onSuccess);
    }
  }

  void _onKycSuccess(CheckAppFormModel checkAppFormModel) async {
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycApproved);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.kycVerificationSuccessScreenLoaded);
    await Future.delayed(const Duration(seconds: 3));
    _onSuccess(checkAppFormModel);
  }
}
