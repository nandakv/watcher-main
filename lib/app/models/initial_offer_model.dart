import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

InitialOfferModel initialOfferModelFromJson(ApiResponse apiResponse) {
  return InitialOfferModel.decodeResponse(apiResponse);
}

class InitialOfferModel {
  late final double loanAmount;
  late final double roi;
  late final int tenure;
  late final ApiResponse apiResponse;
  late final String firstName;

  InitialOfferModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e, s) {
          Get.log("Initial Offer Model exception $e $s");
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
    Get.log(json.toString());
    Map<String, dynamic> jsonMap =
        json['responseBody']?['initialOffer']?['offerSection'];

    loanAmount = double.parse(jsonMap['loanAmount']);
    roi = double.parse(jsonMap['roi']);
    tenure = int.parse(jsonMap['tenure']);
    firstName = json['responseBody']?['firstName'] ?? "";
  }
}
