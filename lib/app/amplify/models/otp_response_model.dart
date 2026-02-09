import 'dart:convert';

import '../../api/response_model.dart';

OTPResponseModel otpResponseModelFromJson(ApiResponse apiResponse) {
  return OTPResponseModel.decodeResponse(apiResponse);
}

class OTPResponseModel {
  OTPResponseModel({
    required this.msg,
    required this.body,
    required this.lastTried,
    required this.state,
  });

  late final String msg;
  late final String body;
  late final int lastTried;
  late final ResponseState state;

  OTPResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          msg = jsonMap['body']['msg'];
          state = ResponseState.success;
        } catch (e) {
          state = ResponseState.jsonParsingError;
        }
        break;
      default:
        state = apiResponse.state;
    }
  }
}
