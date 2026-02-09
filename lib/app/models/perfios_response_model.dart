
import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

PerfiosResponseModel perfiosResponseModelFromJson(ApiResponse apiResponse) {
 return PerfiosResponseModel.decodeResponse(apiResponse);
}

class PerfiosResponseModel {
  PerfiosResponseModel({
    required this.transactionId,
    required this.fromDate,
    required this.toDate,
    required this.institutionId,
    required this.loanProductCode,
    required this.partnerLoanId,
    required this.partnerId,
    required this.emailId,
    this.appId,
    required this.type,
    required this.payload,
    required this.signature,
    required this.htmlSnippet,
    required this.apiResponse
  });
  late final String transactionId;
  late final String fromDate;
  late final String toDate;
  late final String institutionId;
  late final String loanProductCode;
  late final String? partnerLoanId;
  late final String partnerId;
  late final String emailId;
  late final Null appId;
  late final String type;
  late final String payload;
  late final String signature;
  late final String htmlSnippet;
    late ApiResponse apiResponse;


  PerfiosResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        _parseJson(apiResponse);
        this.apiResponse = apiResponse..state = ResponseState.success;
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }


  void _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    transactionId = jsonMap['transactionId'];
    fromDate = jsonMap['fromDate'];
    toDate = jsonMap['toDate'];
    institutionId = jsonMap['institutionId'];
    loanProductCode = jsonMap['loanProductCode'];
    partnerLoanId = jsonMap['partnerLoanId'];
    partnerId = jsonMap['partnerId'];
    emailId = jsonMap['emailId'];
    appId = null;
    type = jsonMap['type'];
    payload = jsonMap['payload'];
    signature = jsonMap['signature'];
    htmlSnippet = jsonMap['htmlSnippet'];
  }


  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['transactionId'] = transactionId;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['institutionId'] = institutionId;
    _data['loanProductCode'] = loanProductCode;
    _data['partnerLoanId'] = partnerLoanId;
    _data['partnerId'] = partnerId;
    _data['emailId'] = emailId;
    _data['appId'] = appId;
    _data['type'] = type;
    _data['payload'] = payload;
    _data['signature'] = signature;
    _data['htmlSnippet'] = htmlSnippet;
    return _data;
  }
}