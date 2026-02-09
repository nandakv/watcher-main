import 'dart:convert';

import 'package:get/get.dart';

import '../../../api/response_model.dart';

MaskedOTPResponseModel maskedOTPResponseModelFromJson(ApiResponse apiResponse) {
  return MaskedOTPResponseModel.fromApiResponse(apiResponse);
}

class MaskedOTPResponseModel {
  late String message ;
  late ApiResponse apiResponse;

  MaskedOTPResponseModel.fromApiResponse(ApiResponse apiResponse) {
    try {
      final jsonMap = jsonDecode(apiResponse.apiResponse);
      message = jsonMap['message'] ?? "";
    } catch (e) {
      Get.log(e.toString());}

    switch (apiResponse.state) {
      case ResponseState.success:
        try {
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