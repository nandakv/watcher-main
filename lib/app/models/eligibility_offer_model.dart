import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';
import 'check_app_form_model.dart';

EligibilityOfferModel eligibilityOfferModelFromJson(ApiResponse apiResponse) {
  return EligibilityOfferModel.decodeResponse(apiResponse);
}

class EligibilityOfferModel extends CheckAppFormModel {
  late String title;
  late String subtitle;
  late String roi;
  late String limitAmount;
  late String buttonText;

  EligibilityOfferModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);

          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log(e.toString());
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
    Map<String, dynamic> offerDetails = json['responseBody']['offerSection'];
    roi = offerDetails['interest'].toString();
    limitAmount = offerDetails['limitAmount'];
    title = json['responseBody']['title'];
    subtitle = json['responseBody']['subtitle'];
    buttonText = json['responseBody']['button_text'];
  }
}
