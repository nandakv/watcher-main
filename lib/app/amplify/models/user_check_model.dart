import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

UserCheckModel userCheckModelFromJson(ApiResponse apiResponse) =>
    UserCheckModel.decodeResponse(apiResponse);

class UserCheckModel {
  late final bool phone;
  late final bool email;
  late final bool forceUpdate;
  late final String message;
  late final ApiResponse apiResponse;

  UserCheckModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          _parseJson(jsonMap);
          this.apiResponse = apiResponse
    ..state = ResponseState.success;
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
    phone = json['body']['phone'] ?? false;
    email = json['body']['email'] ?? false;
    forceUpdate = json['body']['forceUpdate'] ?? false;
    message = json['body']['message'] ?? "";
  }
}
