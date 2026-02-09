import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class GSTListModel {
  late List<String> gstList;
  late ApiResponse apiResponse;

  GSTListModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);

      gstList =
          List<String>.from(jsonMap['responseBody']).map((e) => e).toList();

      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
