import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

///Model to parse the response from customer loan details. This api returns all the
///available loans under a particular customer id
DocumentModel documentModelFromJson(ApiResponse apiResponse) {
  return DocumentModel.decodeResponse(apiResponse);
}

class DocumentModel {
  DocumentModel({
    required this.loanProductCode,
    required this.appFormId,
    required this.ksfLoanId,
    required this.outputUrl,
    required this.templateType,
  });

  late final String loanProductCode;
  late final String appFormId;
  late final String ksfLoanId;
  late final String outputUrl;
  late ApiResponse apiResponse;
  late final String templateType;

  DocumentModel.decodeResponse(ApiResponse apiResponse) {
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
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    loanProductCode = json['loanProductCode'];
    appFormId = json['appFormId'];
    ksfLoanId = json['ksfLoanId'];
    outputUrl = json['outputUrl'];
    templateType = json['templateType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loanProductCode'] = loanProductCode;
    _data['appFormId'] = appFormId;
    _data['ksfLoanId'] = ksfLoanId;
    _data['outputUrl'] = outputUrl;
    _data['templateType'] = templateType;
    return _data;
  }
}
