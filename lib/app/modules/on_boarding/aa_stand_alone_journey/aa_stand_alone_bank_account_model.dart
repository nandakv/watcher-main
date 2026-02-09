import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/bank_details_model.dart';

class AAStandAloneBankAccountModel {
  late ApiResponse apiResponse;
  late AAStandAloneBankReport aaStandAloneBankReport;

  AAStandAloneBankAccountModel.decodeResponse(ApiResponse apiResponse) {
    if (apiResponse.state != ResponseState.success) {
      this.apiResponse = apiResponse;
      return;
    }
    try {
      Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
      aaStandAloneBankReport = AAStandAloneBankReport.fromJson(
          jsonMap['responseBody']['bankAccount']);
      this.apiResponse = apiResponse;
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }
}

class AAStandAloneBankReport extends BankAccount {
  late final int perfiosInstitutionId;
  late final String pirimidBankId;

  AAStandAloneBankReport.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    perfiosInstitutionId = json['perfiosInstitutionId'];
    pirimidBankId = json['pirimidBankId'];
  }
}
