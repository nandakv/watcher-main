import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

/// Response model for Credit Score Data.
/// Handles JSON parsing errors and response state management.

CreditScoreRequestModel creditScoreRequestModelFromJson(ApiResponse apiResponse) {
  return CreditScoreRequestModel.fromApiResponse(apiResponse);
}

class CreditScoreRequestModel {
  late String status;
  late String message;
  late String code;

  late ApiResponse apiResponse;

  CreditScoreRequestModel.fromApiResponse(ApiResponse apiResponse) {
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

  void _parseJson(ApiResponse apiResponse) {
     Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);

    jsonMap=jsonMap['responseBody'];
    status = jsonMap['status'];
     message = jsonMap['message'];
    code = jsonMap['code']??"";
  }
}
