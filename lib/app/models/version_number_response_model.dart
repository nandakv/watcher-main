import 'dart:convert';

import 'package:privo/app/api/response_model.dart';


VersionNumberResponseModel versionNumberResponseModelFromJson(ApiResponse apiResponse) {
  return VersionNumberResponseModel.decodeResponse(apiResponse);
}

class VersionNumberResponseModel {
  VersionNumberResponseModel({
    required this.responseCode,
    required this.appFormId,
    required this.responseBody,
    required this.error,
    required this.state,
  });

  late final String responseCode;
  late final String appFormId;
  late final String responseBody;
  late final Map error;
  late final ResponseState state;

  VersionNumberResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          parseFromJson(jsonMap);
        } catch (e) {
          state = ResponseState.jsonParsingError;
        }
        break;
      default:
        state = apiResponse.state;
    }
  }


  parseFromJson(Map<String, dynamic> jsonMap){
    responseCode = jsonMap['responseCode'];
    appFormId = jsonMap['appFormId'];
    error = jsonMap['error'] ?? {};
    responseBody = jsonMap['responseBody'] ?? "";
    state = ResponseState.success;
  }


}
