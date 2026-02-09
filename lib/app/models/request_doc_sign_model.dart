import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

RequestDocSignModel requestDocSignModelFromJson(ApiResponse apiResponse) {
  return RequestDocSignModel.decodeResponse(apiResponse);
}

class RequestDocSignModel {
  late String url;
  late final ApiResponse apiResponse;
  late String docId;
  late String accessToken;

  RequestDocSignModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          url = apiResponse.apiResponse;
          docId = jsonMap['accessToken']['entity_id'];
          accessToken = jsonMap['accessToken']['id'];
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("RequestDocSign url model exception ${e.toString()}");
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
