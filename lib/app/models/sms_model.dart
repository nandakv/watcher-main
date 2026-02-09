import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class SMSModel {
  late bool isFileUploaded;
  late ApiResponse apiResponse;

  SMSModel.fromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> _json = jsonDecode(apiResponse.apiResponse);
          _parseJson(_json);
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

  void _parseJson(Map<String, dynamic> json) {
    String s3Path = json['responseBody']['raw_sms_s3_url'] ?? "";
    isFileUploaded = s3Path.isNotEmpty;
  }
}
