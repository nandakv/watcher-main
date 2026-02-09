import 'dart:async';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';

import '../models/e_mandate_polling_model.dart';
import '../services/polling_service.dart';

class EMandatePolling {
  late Function(EMandatePollingModel) _onSuccess;
  late Function(EMandatePollingModel) _onFailure;
  late Function(EMandatePollingModel) _onPending;
  late Function(ApiResponse) _onApiError;
  late SequenceEngineModel _sequenceEngineModel;

  final _pollingService = PollingService();

  initAndStart({
    required Function(EMandatePollingModel) onSuccess,
    required Function(EMandatePollingModel) onFailure,
    required Function(EMandatePollingModel) onPending,
    required Function(ApiResponse) onApiError,
    required SequenceEngineModel sequenceEngineModel,
  }) {
    _onSuccess = onSuccess;
    _onPending = onPending;
    _onFailure = onFailure;
    _onApiError = onApiError;
    _sequenceEngineModel = sequenceEngineModel;

    _pollingService.initAndStartPolling(
      pollingInterval: sequenceEngineModel.onPolling?.callFrequency ?? 5,
      maxPollingLimit: sequenceEngineModel.onPolling?.maxCalls,
      pollingFunction: _startPolling,
    );
  }

  _startPolling() {
    _getEMandateStatus(_sequenceEngineModel);
  }

  stop() {
    _pollingService.stopPolling();
  }

  void _getEMandateStatus(SequenceEngineModel sequenceEngineModel) async {
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: sequenceEngineModel.onPolling!.requestPayload,
    );
    EMandatePollingModel model =
        EMandatePollingModel.decodeResponse(checkAppFormModel.apiResponse);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _computeEMandateStatus(model);
        break;
      default:
        stop();
        _onApiError(checkAppFormModel.apiResponse);
    }
  }

  void _computeEMandateStatus(EMandatePollingModel model) {
    switch (model.eMandatePollingStatus) {
      case EMandatePollingStatus.success:
        stop();
        _onSuccess(model);
        break;
      case EMandatePollingStatus.failure:
        stop();
        _onFailure(model);
        break;
      case EMandatePollingStatus.pending:
        _onPending(model);
        break;
    }
  }
}
