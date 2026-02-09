import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

PanDetailsModel panDetailsModelFromJson(ApiResponse apiResponse) {
  return PanDetailsModel.decodeResponse(apiResponse);
}

class PanDetailsModel {
  late final ApiResponse apiResponse;
  late final String maskedPanValue;
  late final String appFormId;
  late final bool isPanTwoFA;

  PanDetailsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e, s) {
          Get.log("Pan details Model exception $e $s");
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
    Get.log(json.toString());
    maskedPanValue = json['responseBody']['pan_value'] ?? "";
    isPanTwoFA = json['responseBody']['is_pan_2fa'] ?? false;
    appFormId = json['appFormId'] ?? "";
  }
}
