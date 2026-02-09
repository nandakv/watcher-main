import 'dart:convert';
import '../../api/response_model.dart';

OTPUdyamDetailsModel otpUdyamDetailsModelFromJson(ApiResponse apiResponse) =>
    OTPUdyamDetailsModel.decodeFromJson(apiResponse);

class OTPUdyamDetailsModel {
  late String udyam;
  late String applicantId;
  late ApiResponse apiResponse;

  OTPUdyamDetailsModel.decodeFromJson(ApiResponse apiResponse) {
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
    udyam = json['responseBody']['udyamNumber'] ?? "";
    applicantId = json['responseBody']['applicantId'].toString();
  }
}
