import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/processing_bank_details_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/penny_status_model.dart';
import 'package:privo/app/models/penny_success_model_response_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/flavors.dart';

import '../services/polling_service.dart';

class PennyTestingPollingMixin {
  static const String _APPROVED_STATUS = "COMPLETE";
  static const String _FAILED_STATUS = "FAILURE";
  static const String _PENDING_STATUS = "PENDING";

  late Function(ApiResponse) _onApiError;
  late Function(AppFormRejectionModel rejectionModel) _onRejected;
  late Function(CheckAppFormModel checkAppFormModel) _onSuccess;
  late Function(CheckAppFormModel checkAppFormModel) _onFailed;
  late Map<String, dynamic> _requestPayload;
  late SequenceEngineModel _sequenceEngineModel;

  static const String _PENNY_STATUS_COMPLETE = "SUCCESS";
  static const String _PENNY_STATUS_FAILED = "FAILURE";

  final _pollingService = PollingService();

  startPennyTestingPolling(
      {required Function(ApiResponse) onApiError,
      required Function(AppFormRejectionModel rejectionModel) onRejected,
      required Function(CheckAppFormModel checkAppFormModel) onSuccess,
      required Map<String, dynamic> requestPayload,
      required Function(CheckAppFormModel) onFailed,
      required SequenceEngineModel sequenceEngineModel}) async {
    _onApiError = onApiError;
    _onRejected = onRejected;
    _onSuccess = onSuccess;
    _onFailed = onFailed;
    _requestPayload = requestPayload;
    _sequenceEngineModel = sequenceEngineModel;

    _pollingService.initAndStartPolling(
        pollingInterval: sequenceEngineModel.onPolling?.callFrequency ?? 5,
        maxPollingLimit: sequenceEngineModel.onPolling?.maxCalls,
        pollingFunction: startPolling);
  }

  startPolling() async {
    CheckAppFormModel pennyStatusModel =
        await SequenceEngineRepository(_sequenceEngineModel)
            .makeHttpRequest(body: _requestPayload);
    switch (pennyStatusModel.apiResponse.state) {
      case ResponseState.success:
        await _computeRejected(pennyStatusModel);
        break;
      default:
        _pollingService.stopPolling();
        _onApiError(pennyStatusModel.apiResponse);
    }
  }

  stopPennyTestingPolling() {
    _pollingService.stopPolling();
  }

  _computeRejected(CheckAppFormModel pennyStatusModel) {
    if (pennyStatusModel.appFormRejectionModel.isRejected) {
      _onRejected(pennyStatusModel.appFormRejectionModel);
    } else {
      _checkPennyTestingStatus(pennyStatusModel);
    }
  }

  _checkPennyTestingStatus(CheckAppFormModel pennyStatusModel) async {
    try {
      switch (pennyStatusModel.responseBody["polling_status"]) {
        case _APPROVED_STATUS:
          await _onPollingComplete(pennyStatusModel);
          break;
        case _FAILED_STATUS:
          _onPennyFailure(pennyStatusModel);
          break;
      }
    } catch (e) {
      Get.log("penny key not found - $e");
    }
  }

  Future<void> _onPollingComplete(CheckAppFormModel pennyStatusModel) async {
    try {
      switch (pennyStatusModel.responseBody["pennyTestingStatus"]) {
        case _PENNY_STATUS_COMPLETE:
          AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.pennyTestSuccessScreenLoaded);
          _pollingService.stopPolling();
          _onSuccess(pennyStatusModel);
          break;
        case _PENNY_STATUS_FAILED:
          _pollingService.stopPolling();
          _onPennyFailure(pennyStatusModel);
          break;
        default:
          break;
      }
    } catch (e) {
      Get.log("penny key not found - $e");
    }
  }

  _onPennyFailure(CheckAppFormModel checkAppFormModel) {
    _pollingService.stopPolling();
    _onFailed(checkAppFormModel);
  }
}
