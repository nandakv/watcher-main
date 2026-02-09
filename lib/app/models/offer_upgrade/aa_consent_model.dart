import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_initiate_model.dart';

class AAConsentModel extends BankReportInitiateModel {
  late List<String> consentId;
  late String responseURL;

  AAConsentModel.fromJson(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    try {
      if (apiResponse.state != ResponseState.success) {
        this.apiResponse = apiResponse;
        return;
      }
      Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
      Map<String, dynamic> responseBody = jsonMap['responseBody'];
      consentId = List.from(responseBody['vendorDetails'])
          .map((e) => "${e['consentId']}")
          .toList();
      responseURL = responseBody['vendorDetails'][0]['responseUrl'];
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
