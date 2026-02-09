import 'dart:convert';

import '../api/response_model.dart';

class ForeclosurePaymentInfoModel {
  late final num principalOutStanding;
  late final num currentInterest;
  late final num prepaymentCharges;
  late final num? bpiCharges;
  late final num totalAmount;
  late final ApiResponse apiResponse;

  ForeclosurePaymentInfoModel.decodeResponse(ApiResponse apiResponse) {
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
    principalOutStanding = json['principalOutStanding'];
    currentInterest = json['currentInterest'];
    prepaymentCharges = json['prepaymentCharges'];

    /// if FCdate < bpidate backend will not send key. In this scenario we should not show the data row
    bpiCharges = json['bpiCharges'];
    totalAmount = json['totalAmount'];
  }
}
