import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/app_form_status_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

///Response model that have CheckAppFormModel as base
///Helps in catching the json parsing errors
///If parsing fails we have the response state

enum WithdrawalPollingStatus {
  initiated,
  processed,
  withdrawCancelled,
  loanCreated,
  withdrawalFailed
}

class WithdrawalStatusModel extends CheckAppFormModel {
  late String disbursedAmount;
  late String errorMessage;
  late DateTime? errorDateTime;
  late WithdrawalPollingStatus pollingStatus =
      WithdrawalPollingStatus.initiated;

  WithdrawalStatusModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(responseBody);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  void _parseJson(jsonMap) {
    if (jsonMap['currentWithdrawal'] != null) {
      var currentWithdrawal = jsonMap['currentWithdrawal'];
      _computeWithdrawalStatus(currentWithdrawal['withdrawalStatusCode']);
      disbursedAmount = jsonMap['currentWithdrawal']['disbursalAmount'];
      errorMessage = jsonMap['currentWithdrawal']['message'] ?? "";
      if (jsonMap['currentWithdrawal']['date_time'] != null &&
          "${jsonMap['currentWithdrawal']['date_time']}".isNotEmpty) {
        errorDateTime = DateTime.parse(jsonMap['currentWithdrawal']['date_time']);
      }
    }
  }

  void _computeWithdrawalStatus(String status) {
    late String CODE_INITIATED = "101";
    late String CODE_PROCESSING = "111";
    late String CODE_WITHDRAWAL_CANCELED = "90";
    late String CODE_LOAN_CREATED = "140";
    late String CODE_WITHDRAWAL_FAILED = "-90";

    var statusMap = {
      CODE_INITIATED: WithdrawalPollingStatus.initiated,
      CODE_PROCESSING: WithdrawalPollingStatus.processed,
      CODE_WITHDRAWAL_CANCELED: WithdrawalPollingStatus.withdrawCancelled,
      CODE_LOAN_CREATED: WithdrawalPollingStatus.loanCreated,
      CODE_WITHDRAWAL_FAILED: WithdrawalPollingStatus.withdrawalFailed,
    };

    pollingStatus = statusMap[status] ?? WithdrawalPollingStatus.initiated;
  }
}
