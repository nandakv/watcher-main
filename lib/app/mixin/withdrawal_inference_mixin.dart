import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/home_page_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';

import '../modules/home_screen_module/model/withdrawal_blocking_details.dart';

class WithdrawalInferenceMixin {
  late Function(ApiResponse) _onApiError;
  late Function(CheckAppFormModel checkAppFormModel) _onSuccess;
  late Function(WithdrawalBlockingDetails withdrawalBlockingDetails) _onFailure;

  final String POLLING_COMPLETE_KEY = "COMPLETE";

  void startWithdrawalInferencePolling({
    required Function(ApiResponse) onApiError,
    required Function(WithdrawalBlockingDetails withdrawalBlockingDetails)
        onFailure,
    required Function(CheckAppFormModel checkAppFormModel) onSuccess,
  }) async {
    _onApiError = onApiError;
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    CheckAppFormModel checkAppFormModel =
        await HomePageRepository().withdrawalInferencePolling();
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _computeInferencePollingStatus(checkAppFormModel);
        break;
      default:
        _onApiError(checkAppFormModel.apiResponse);
    }
  }

  void _computeInferencePollingStatus(
      CheckAppFormModel checkAppFormModel) async {
    try {
      bool isPollingCompleted =
          checkAppFormModel.responseBody["polling_status"] ==
              POLLING_COMPLETE_KEY;
      if (isPollingCompleted) {
        _onWithdrawalInferenceStatusCompleted(checkAppFormModel);
      } else {
        await Future.delayed(const Duration(seconds: 5));
        startWithdrawalInferencePolling(
            onApiError: _onApiError,
            onFailure: _onFailure,
            onSuccess: _onSuccess);
      }
    } on Exception catch (e) {
      _onApiError(checkAppFormModel.apiResponse);
    }
  }

  void _onWithdrawalInferenceStatusCompleted(
      CheckAppFormModel checkAppFormModel) {
    try {
      bool isBlockWithdrawal =
          checkAppFormModel.responseBody['block_withdrawal'];
      String errorMessage =
          checkAppFormModel.responseBody['popup_message'] ?? "";
      String errorTitle = checkAppFormModel.responseBody['popup_title'] ?? "";
      String type = checkAppFormModel.responseBody['popup_type'] ?? "";
      if (isBlockWithdrawal) {
        _onFailure(WithdrawalBlockingDetails(
          title: errorTitle,
          message: errorMessage,
          type: type,
        ));
      } else {
        _onSuccess(checkAppFormModel);
      }
    } on Exception catch (e) {
      _onApiError(checkAppFormModel.apiResponse);
    }
  }
}
