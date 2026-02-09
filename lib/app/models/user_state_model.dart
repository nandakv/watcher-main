import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

UserStateModel userStateModelFromJson(ApiResponse apiResponse) {
  return UserStateModel.decodeResponse(apiResponse);
}

class UserStateModel {
  late final String appFormId;
  late final String state;
  late final ApiResponse apiResponse;

  UserStateModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          if (jsonMap['responseBody'] is String) {
            state = '0';
            appFormId = '';
            this.apiResponse = apiResponse..state = ResponseState.success;
          } else {
            _parseJson(jsonMap);
            this.apiResponse = apiResponse..state = ResponseState.success;
          }
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
    appFormId = json['responseBody']['appFormId'] ?? "";
    state = json['responseBody']['state'] ?? "0";
  }
}
