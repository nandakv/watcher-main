import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class DigioIDModel {
  late String kID;
  late String token;
  late ApiResponse apiResponse;

  DigioIDModel.fromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        this.apiResponse = apiResponse;
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  void _parseJson(Map<String, dynamic> jsonMap) {
    kID = jsonMap['id'];
    token = jsonMap['access_token']['id'];
  }
}
