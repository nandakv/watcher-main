import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class DigioAadhaarResponseModel {
  ///[executionRequestID] need this id to get the xml file.
  late String executionRequestID;

  ///[digioResponse] holds the aadhaar data of the user from digio
  late Map<String, dynamic> digioResponse;
  late ApiResponse apiResponse;

  DigioAadhaarResponseModel.fromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
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

  void _parseJson(Map<String, dynamic> jsonMap) {
    executionRequestID = jsonMap['actions'][0]['execution_request_id'];
    digioResponse = jsonMap;
  }
}
