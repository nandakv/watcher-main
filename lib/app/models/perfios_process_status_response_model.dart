

import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

PerfiosProcessStatus perfiosProcessStatusResponseModelFromJson(ApiResponse apiResponse) {
 return PerfiosProcessStatus.decodeResponse(apiResponse);
}

class PerfiosProcessStatus {
  PerfiosProcessStatus({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isActive,
    required this.isDeleted,
    required this.emailId,
    required this.transactionId,
    required this.partnerLoanId,
    required this.loanProductCode,
    required this.partnerId,
    this.appId,
    required this.perfiosTransactionId,
    required this.fromDate,
    required this.toDate,
    required this.institutionId,
    required this.redirectUrl,
    required this.destination,
    required this.status,
    required this.code,
    required this.message,
    required this.xmlReportUrl,
    required this.statementsUrl,
  });
  late final int id;
  late final int createdAt;
  late final int updatedAt;
  late final String createdBy;
  late final String updatedBy;
  late final bool isActive;
  late final bool isDeleted;
  late final String emailId;
  late final String transactionId;
  late final String? partnerLoanId;
  late final String loanProductCode;
  late final String partnerId;
  late final Null appId;
  late final String perfiosTransactionId;
  late final String fromDate;
  late final String toDate;
  late final String institutionId;
  late final String redirectUrl;
  late final String destination;
  late final String status;
  late final String code;
  late final String message;
  late final String? xmlReportUrl;
  late final String? statementsUrl;
  late final ApiResponse apiResponse;



  PerfiosProcessStatus.decodeResponse(ApiResponse apiResponse) {
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
    id = jsonMap['id'];
    createdAt = jsonMap['createdAt'];
    updatedAt = jsonMap['updatedAt'];
    createdBy = jsonMap['createdBy'];
    updatedBy = jsonMap['updatedBy'];
    isActive = jsonMap['isActive'];
    isDeleted = jsonMap['isDeleted'];
    emailId = jsonMap['emailId'];
    transactionId = jsonMap['transactionId'];
    partnerLoanId = jsonMap['partnerLoanId'];
    loanProductCode = jsonMap['loanProductCode'];
    partnerId = jsonMap['partnerId'];
    appId = null;
    perfiosTransactionId = jsonMap['perfiosTransactionId'];
    fromDate = jsonMap['fromDate'];
    toDate = jsonMap['toDate'];
    institutionId = jsonMap['institutionId'];
    redirectUrl = jsonMap['redirectUrl'];
    destination = jsonMap['destination'];
    status = jsonMap['status'];
    code = jsonMap['code'];
    message = jsonMap['message'];
    xmlReportUrl = jsonMap['xmlReportUrl'];
    statementsUrl = jsonMap['statementsUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['createdBy'] = createdBy;
    _data['updatedBy'] = updatedBy;
    _data['isActive'] = isActive;
    _data['isDeleted'] = isDeleted;
    _data['emailId'] = emailId;
    _data['transactionId'] = transactionId;
    _data['partnerLoanId'] = partnerLoanId;
    _data['loanProductCode'] = loanProductCode;
    _data['partnerId'] = partnerId;
    _data['appId'] = appId;
    _data['perfiosTransactionId'] = perfiosTransactionId;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['institutionId'] = institutionId;
    _data['redirectUrl'] = redirectUrl;
    _data['destination'] = destination;
    _data['status'] = status;
    _data['code'] = code;
    _data['message'] = message;
    _data['xmlReportUrl'] = xmlReportUrl;
    _data['statementsUrl'] = statementsUrl;
    return _data;
  }
}