import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

EMandateResponseModel eMandateResponseModelFromJson(ApiResponse apiResponse) {
  return EMandateResponseModel.decodeResponse(apiResponse);
}

class EMandateResponseModel extends CheckAppFormModel {
  late final String customerId;
  late final String orderId;
  late final bool isJusPay;
  late final String jusPayWebViewUrl;
  late final bool isSuccess;

  EMandateResponseModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson();
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

  void _parseJson() {
    isSuccess = responseBody['mandateStatus'] == null
        ? false
        : responseBody['mandateStatus'] == "SUCCESS";
    if (!isSuccess) {
      customerId = responseBody['customerId'];
      orderId = responseBody['orderId'];
      isJusPay = responseBody['htmlSnippet'] == null;
      jusPayWebViewUrl = responseBody['mandateLink'] ?? "";
    }
  }
}
