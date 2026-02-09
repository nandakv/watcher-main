import 'dart:convert';

import '../../../../api/response_model.dart';

LowAndGrowWaitScreenModel lowAndGrowWaitScreenModelFromJson(
    ApiResponse apiResponse) {
  return LowAndGrowWaitScreenModel.decodeResponse(apiResponse);
}

class LowAndGrowWaitScreenModel {
  late final String? responseCode;
  late var responseBody;
  late ApiResponse apiResponse;

  LowAndGrowWaitScreenModel.decodeResponse(ApiResponse apiResponse) {
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
    responseCode = jsonMap['responseCode'] ?? '';

    responseBody = jsonMap['responseBody'] ?? {};
  }
}
