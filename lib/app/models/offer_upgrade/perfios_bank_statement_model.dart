import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_initiate_model.dart';

class PerfiosBankStatementModel extends BankReportInitiateModel {
  late String htmlSnippet;
  late String signature;
  late String payload;

  PerfiosBankStatementModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    try {
      if (apiResponse.state != ResponseState.success) {
        this.apiResponse = apiResponse;
        return;
      }
      Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
      Map<String, dynamic> responseBody = jsonMap['responseBody'];
      payload = responseBody['vendorDetails']['payload'];
      signature = responseBody['vendorDetails']['signature'] ?? "null";
      htmlSnippet = responseBody['vendorDetails']['htmlSnippet'];
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
