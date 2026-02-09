import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class VKYCInitiateModel {
  late String vkycWaitPageUrl;
  late String status;
  late bool isSwitchToSelfie;
  late ApiResponse apiResponse;

  VKYCInitiateModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
          this.apiResponse = apiResponse;
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

  void _parseJson(Map<String, dynamic> jsonMap) {
    status = jsonMap['responseBody']['status'];
    isSwitchToSelfie =
        ["SWITCHTOSELFIE", "OKYCEXPIRED"].contains(status.toUpperCase());
    if (!isSwitchToSelfie) {
      vkycWaitPageUrl = jsonMap['responseBody']['vkycWaitPageUrl'] ??
          jsonMap['responseBody']['vkycUrl'] ??
          "";
    }
  }
}
