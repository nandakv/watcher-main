import 'dart:convert';

import '../../api/response_model.dart';

class BankReportModel {
  late bool shouldPoll;
  late String reportId;
  late List<BankReport> bankList;
  late ApiResponse apiResponse;

  BankReportModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
      shouldPoll = json['responseBody']['shouldPoll'];
      if (shouldPoll) {
        reportId = json['responseBody']['pendingReport']["reportId"];
      }
      bankList = json['responseBody']['bankReports'] == null
          ? []
          : List.from(json['responseBody']['bankReports'])
              .map((e) {
                return BankReport.fromJson(e);
              })
              .toList()
              .where((element) => element.isSuccess)
              .toList();
      this.apiResponse = apiResponse;
    } on Exception catch (e) {
      apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}

class BankReport {
  late String bankName;
  late String accountNumber;
  late String ifscCode;
  late bool isSuccess;

  BankReport.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNumber = json['accountNumber'] ?? "";
    ifscCode = json['ifscCode'] ?? "";
    isSuccess = json['status'] == "SUCCESS";
  }
}
