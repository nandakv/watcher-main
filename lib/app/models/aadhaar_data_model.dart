import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

AadhaarDataModel aadhaarDataModelFromJson(ApiResponse apiResponse) =>
    AadhaarDataModel.decodeResponse(apiResponse);

class AadhaarDataModel {
  late Map<String, dynamic> resultMap;
  late ApiResponse apiResponse;

  AadhaarDataModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          resultMap = jsonMap;
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
