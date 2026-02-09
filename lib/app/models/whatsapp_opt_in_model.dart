import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class WhatsappOptInModel {
  late bool status;
  late ApiResponse apiResponse;

  WhatsappOptInModel.fromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
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

  void _parseJson(Map<String, dynamic> jsonMap) async {
    status = jsonMap['response']['status'] == null
        ? false
        : jsonMap['response']['status'].toLowerCase() ==
            'SUCCESS'.toLowerCase();
  }
}
