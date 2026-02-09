import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/bank_details_model.dart';

class EMandateBankModel {
  late ApiResponse apiResponse;
  late BankAccount bankAccount;

  EMandateBankModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
      bankAccount =
          BankAccount.fromJson(jsonMap['responseBody']['bankAccount']);
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
