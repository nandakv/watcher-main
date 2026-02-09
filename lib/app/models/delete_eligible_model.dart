import 'dart:convert';

import 'package:privo/app/api/response_model.dart';


DeleteEligibleModel deleteEligibleModelFromJson(ApiResponse apiResponse) {
  return DeleteEligibleModel.decodeResponse(apiResponse);
}

class DeleteEligibleModel {
  late bool isAllowedtoDelete;
  late String message;
  late final ApiResponse apiResponse;

  DeleteEligibleModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          isAllowedtoDelete = jsonMap['isAllowedtoDelete'];
          message = jsonMap['message'];
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
}