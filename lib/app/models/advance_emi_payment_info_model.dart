import 'dart:convert';

import '../api/response_model.dart';

class AdvanceEMIPaymentInfoModel {
  late final num emiAmount;
  late final num emiInterest;
  late final num emiPrincipal;
  late final String loanId;
  late final ApiResponse apiResponse;

  AdvanceEMIPaymentInfoModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  _parseJson(Map<String, dynamic> json) {
    emiAmount = json['emiAmount'];
    emiInterest = json['emiInterest'];
    emiPrincipal = json['emiPrincipal'];
    loanId = json['loanId'];
  }
}
