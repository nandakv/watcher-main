import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

OverDueLoansModel overDueLoanListModelFromJson(ApiResponse apiResponse) {
  return OverDueLoansModel.decodeResponse(apiResponse);
}

class OverDueLoan {
/*
{
  "loanId": "75145",
  "dpd": "15"
}
*/

  late String loanId;
  late String dpd;

  OverDueLoan({
    required this.loanId,
    required this.dpd,
  });

  OverDueLoan.fromJson(Map<String, dynamic> json) {
    loanId = json['loanId'];
    dpd = json['dpd'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['loanId'] = loanId;
    data['dpd'] = dpd;
    return data;
  }
}

class OverDueLoansModel {
/*
sample response
{
  "loan_product_code": "CLP",
  "over_due_loans": [
    {
      "loanId": "75145",
      "dpd": "15"
    }
  ]
}
*/

  late String loanProductCode;
  late List<OverDueLoan> overDueLoansList;
  late ApiResponse apiResponse;

  OverDueLoansModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(jsonDecode(apiResponse.apiResponse));
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Loan details exception ${e.toString()}");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  OverDueLoansModel({
    required this.loanProductCode,
    required this.overDueLoansList,
  });

  _parseJson(Map<String, dynamic> json) {
    loanProductCode = json['loan_product_code'];
    if (json['over_due_loans'] != null) {
      final overDueLoansJson = json['over_due_loans'];
      final overDueLoans = <OverDueLoan>[];
      overDueLoansJson.forEach((v) {
        overDueLoans.add(OverDueLoan.fromJson(v));
      });
      overDueLoansList = overDueLoans;
    }
  }
}
