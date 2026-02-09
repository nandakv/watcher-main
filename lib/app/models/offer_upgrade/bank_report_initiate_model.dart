import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/offer_upgrade/aa_consent_model.dart';
import 'package:privo/app/models/offer_upgrade/perfios_bank_statement_model.dart';

abstract class BankReportInitiateModel {
  late ApiResponse apiResponse;
  late String reportId;

  BankReportInitiateModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
      _parseJson(jsonMap);
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }

  _parseJson(Map<String, dynamic> jsonMap) {
    reportId = jsonMap['responseBody']["bankReport"]["reportId"];
  }

}
