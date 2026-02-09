import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

class AAStatusModel extends CheckAppFormModel {

  AAStatusModel.fromJson(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> _json = json.decode(apiResponse.apiResponse);
          _parseResponse(_json);
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

  void _parseResponse(Map<String, dynamic> json) {}
}
