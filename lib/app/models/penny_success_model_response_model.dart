// To parse this JSON data, do
//
//     final pennySuccessResponseModel = pennySuccessResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

PennySuccessResponseModel pennySuccessResponseModelFromJson(
    ApiResponse apiResponse) {
  return PennySuccessResponseModel.decodeResponse(apiResponse);
}

class PennySuccessResponseModel {
  PennySuccessResponseModel({
    required this.id,
    required this.eventType,
  });

  late int id;
  late String eventType;
  late final ApiResponse apiResponse;

  PennySuccessResponseModel.decodeResponse(ApiResponse apiResponse) {
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
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    id = jsonMap["id"] ?? "";
    eventType = jsonMap["eventType"] ?? "";
  }

  Map<String, dynamic> toJson() => {"id": id, "eventType": eventType};
}
