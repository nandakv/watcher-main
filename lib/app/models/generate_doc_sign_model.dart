import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

GenerateDocSignModel generateDocSignModelFromJson(ApiResponse apiResponse) {
  return GenerateDocSignModel.decodeResponse(apiResponse);
}

class GenerateDocSignModel {
  late String url;
  late final ApiResponse apiResponse;

  GenerateDocSignModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          url = apiResponse.apiResponse;
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("GenerateDocSign url model exception ${e.toString()}");
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
