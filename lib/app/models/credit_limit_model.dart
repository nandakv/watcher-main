import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/app_form_status_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

///Response model that have CheckAppFormModel as base
///Helps in catching the json parsing errors
///If parsing fails we have the response state

CreditLimitModel creditLimitModelFromJson(ApiResponse apiResponse) {
  return CreditLimitModel.decodeResponse(apiResponse);
}

class CreditLimitModel extends CheckAppFormModel {
  double? approvedLimit;
  double? usedLimit;
  double? roi;
  double? minLoanAmount;
  double? maxLoanAmount;
  String? expiryDate;
  int? minTenure;
  int? maxTenure;
  late bool blockWithdrawal;
  late String popUpMessage;
  late bool collectAddress;

  CreditLimitModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
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

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    Map<String, dynamic> json = jsonMap['responseBody'];
    approvedLimit = json['approvedLimit'];
    usedLimit = json['usedLimit'];
    roi = json['roi'];
    minLoanAmount = json['availableMinLimit'];
    maxLoanAmount = json['availableMaxLimit'];
    expiryDate = json['expiryDate'];
    minTenure = json['minTenure'];
    maxTenure = json['maxTenure'];
    blockWithdrawal = json['blockWithdrawal'];
    collectAddress = json['collectAddress'];
    popUpMessage = json['popupMessage'];
  }
}
