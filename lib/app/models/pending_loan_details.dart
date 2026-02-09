import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

PendingLoanDetailsModel pendingLoanDetailModelFromJson(
    ApiResponse apiResponse) {
  return PendingLoanDetailsModel.decodeResponse(apiResponse);
}

class PendingLoanDetailsModel {
  late final String overduePrincipal;
  late final String overdueInterest;
  late final String latePaymentPenaltyInterest;
  late final String bounceCharges;
  late final String totalPendingAmount;
  late final ApiResponse apiResponse;

  PendingLoanDetailsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Pending loan details exception ${e.toString()}");
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
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    overduePrincipal = json['overduePrincipal'];
    overdueInterest = json['overdueInterest'];
    latePaymentPenaltyInterest = json['latePaymentPenaltyInterest'];
    bounceCharges = json['bounceCharges'];
    totalPendingAmount = json['totalPendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['overduePrincipal'] = overduePrincipal;
    _data['overdueInterest'] = overdueInterest;
    _data['latePaymentPenaltyInterest'] = latePaymentPenaltyInterest;
    _data['bounceCharges'] = bounceCharges;
    _data['totalPendingAmount'] = totalPendingAmount;
    return _data;
  }
}
