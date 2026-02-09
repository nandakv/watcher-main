import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class WithdrawalBlockCheckModel {
  late bool isWithdrawalBlocked;
  late ApiResponse apiResponse;

  WithdrawalBlockCheckModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          var jsonMap = jsonDecode(apiResponse.apiResponse);
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

  void _parseJson(jsonMap) {
    if (jsonMap['creditLine'] == null) {
      isWithdrawalBlocked = false;
    } else {
      isWithdrawalBlocked = jsonMap['creditLine']['blocked'] ?? false;
    }
  }
}
