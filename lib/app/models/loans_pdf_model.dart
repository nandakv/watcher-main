import 'dart:convert';
import 'package:privo/app/api/response_model.dart';

LoansPDFModel LoansPDFModelFromJson(ApiResponse apiResponse) {
  return LoansPDFModel.decodeResponse(apiResponse);
}

class LoansPDFModel {
  late String outputUrl;
  late ApiResponse apiResponse;

  LoansPDFModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
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

  void _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    outputUrl = outputUrl = jsonMap['outputUrl'] ?? '';
  }
}
