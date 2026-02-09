import 'dart:convert';

import '../api/response_model.dart';

LoanCancellationDetailsModel loanCancellationDetailsModelFromJson(
    ApiResponse apiResponse) {
  return LoanCancellationDetailsModel.decodeResponse(apiResponse);
}

class LoanCancellationDetailsModel {
  late int loanAmount;
  late int disbursalAmount;
  late String roi;
  late String apr;
  late int bpiAmount;
  late int processingFee;
  late int currentInterestAmount;
  late int totalPayableAmount;
  late ApiResponse apiResponse;

  LoanCancellationDetailsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
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

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    loanAmount = json['loanAmount'];
    disbursalAmount = json['disbursalAmount'];
    roi = "${json['roi']}";
    apr = "${json['apr']}";
    bpiAmount = json['bpiAmount'];
    processingFee = json['processingFee'];
    currentInterestAmount = json['currentInterestAmount'];
    totalPayableAmount = json['totalPayableAmount'];
  }
}
