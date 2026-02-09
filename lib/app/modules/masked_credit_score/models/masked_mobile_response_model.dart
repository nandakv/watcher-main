import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

MaskedMobileResponseModel maskedMobileResponseModelFromJson(ApiResponse apiResponse) {
  return MaskedMobileResponseModel.fromApiResponse(apiResponse);
}

class MaskedMobileResponseModel {
  late String responseCode;
  late int timestamp;
  late String appFormId;
  late List<String> maskedMobileNumbers;

  late ApiResponse apiResponse;

  MaskedMobileResponseModel.fromApiResponse(ApiResponse apiResponse) {
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

    responseCode = jsonMap['responseCode'];
    timestamp = jsonMap['timestamp'];
    appFormId = jsonMap['appFormId'];
    var responseBody = jsonMap['responseBody'] ?? {};
    maskedMobileNumbers = List<String>.from(responseBody['maskedMobileNumbers'] ?? []);
  }
}
