import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

PanDetailsVerifyModel panDetailsVerifyModelFromJson(ApiResponse apiResponse) {
  return PanDetailsVerifyModel.decodeResponse(apiResponse);
}

class PanDetailsVerifyModel {
  late final bool isPanValid;
  late final ApiResponse apiResponse;

  PanDetailsVerifyModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e, s) {
          Get.log("Pan details verify model exception $e stack $s");
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

    isPanValid = json["responseBody"]['is_pan_valid'];
  }
}
