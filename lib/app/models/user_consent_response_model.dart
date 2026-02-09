import 'dart:convert';
import 'package:get/get.dart';

import '../api/response_model.dart';

UserConsentResponseModel userConsentResponseModelFromJson(
    ApiResponse apiResponse) {
  return UserConsentResponseModel.decodeResponse(apiResponse);
}

class UserConsentResponseModel {
  late final int id;
  late final bool pan;
  late final bool cibil;
  late final bool ckyc;
  late final ApiResponse apiResponse;

  UserConsentResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  _parseJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pan = json['pan'];
    cibil = json['cibil'];
    ckyc = json['ckyc'];
  }
}
