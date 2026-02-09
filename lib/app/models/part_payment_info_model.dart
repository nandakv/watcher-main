import 'dart:convert';

import '../api/response_model.dart';

class PartPaymentInfoModel {
  late final num minPartPayAmount;
  late final num maxPartPayAmount;
  late final num sanctionedLimit;
  late final num availableLimit;
  late final ApiResponse apiResponse;

  PartPaymentInfoModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  _parseJson(Map<String, dynamic> json) {
    minPartPayAmount = json['minPartPayAmount'];
    maxPartPayAmount = json['maxPartPayAmount'];
    sanctionedLimit = json['sanctionAmount'];
    availableLimit = json['availableLimit'];
  }
}
