import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

import '../bank_details_model.dart';

class PennyTestingBankModel {
  late ApiResponse apiResponse;
  late bool isBankAccountAvailable;
  late String lpc;
  late String employmentType;
  late BankAccount? bankAccount;

  PennyTestingBankModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
      Map<String,dynamic> responseBody = jsonMap['responseBody'];
      isBankAccountAvailable =
          responseBody['isBankAccountAvailable'];
      bankAccount = responseBody['bankAccount'] == null ||
              responseBody['bankAccount'].isEmpty
          ? null
          : BankAccount.fromJson(responseBody['bankAccount']);
      lpc = responseBody['loanProduct'];
      employmentType = responseBody['employmentType'];
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}
