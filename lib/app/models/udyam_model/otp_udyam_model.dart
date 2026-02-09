import 'dart:convert';
import '../../api/response_model.dart';

OTPUdyamModel otpUdyamModelFromJson(ApiResponse apiResponse) =>
    OTPUdyamModel.decodeFromJson(apiResponse);

class OTPUdyamModel {
  late String caseId;
  late ApiResponse apiResponse;

  OTPUdyamModel.decodeFromJson(ApiResponse apiResponse) {
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
    caseId = json['responseBody']['caseId'] ?? '';
  }
}
