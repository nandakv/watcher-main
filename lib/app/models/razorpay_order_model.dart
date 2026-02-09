import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

RazorPayOrderModel razorPayOrderModelFromJson(ApiResponse apiResponse) =>
    RazorPayOrderModel.decodeResponse(apiResponse);

class RazorPayOrderModel {
  late ApiResponse apiResponse;
  late final String orderId;

  RazorPayOrderModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          orderId = jsonMap['orderId'] ?? "";
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
}
