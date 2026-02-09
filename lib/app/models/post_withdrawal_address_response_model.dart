// To parse this JSON data, do
//
//     final postWithdrawalAddressResponseModel = postWithdrawalAddressResponseModelFromJson(jsonString);

import 'package:get/get.dart';
import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

PostWithdrawalAddressResponseModel postWithdrawalAddressResponseModelFromJson(
    ApiResponse apiResponse) {
  return PostWithdrawalAddressResponseModel.decodeResponse(apiResponse);
}

class PostWithdrawalAddressResponseModel {
  PostWithdrawalAddressResponseModel({
    required this.id,
  });

  String? id;
  late final ApiResponse apiResponse;

  PostWithdrawalAddressResponseModel.decodeResponse(ApiResponse apiResponse) {
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
    id = jsonMap['id'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
