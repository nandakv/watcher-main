import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class BankReportPollingModel {
  late bool isCompleted;
  late bool isSuccess;
  late String reportId;
  late ApiResponse apiResponse;
  late String failureTitle;
  late String failureMessage;
  late String status;

  BankReportPollingModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
      isCompleted = jsonMap['responseBody']['polling_status'] != "PENDING";
      reportId = jsonMap['responseBody']['reportId'];
      isSuccess = jsonMap['responseBody']['status'] != "FAILURE";
      failureTitle = jsonMap['responseBody']['failureTitle']??"";
      failureMessage = jsonMap['responseBody']['failureMessage']??"";
      status = jsonMap['responseBody']['status']??"";
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
