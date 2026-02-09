import 'dart:convert';

import '../api/response_model.dart';

AadhaarOTPModel aadhaarOTPModelFromJson(ApiResponse apiResponse) =>
    AadhaarOTPModel.decodeFromJson(apiResponse);

class AadhaarOTPModel {
  late String requestID;
  late String? message;
  late int statusCode;
  late ApiResponse apiResponse;

  AadhaarOTPModel.decodeFromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          _fromJson(jsonMap);
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

  _fromJson(Map<String, dynamic> json) {
    requestID = json['requestId'];
    message = json['result'].isEmpty ? null : json['result']['message'];
    statusCode = json['statusCode'];
  }
}
