import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

ReferralSubmissionResponseModel referralSubmissionResponseModelFromJson(
        ApiResponse apiResponse) =>
    ReferralSubmissionResponseModel.decodeResponse(apiResponse);

class ReferralSubmissionResponseModel {
  late ApiResponse apiResponse;
  late final String gotReferredBy;
  late final String gotReferredAt;
  late final String referralCode;
  String? message;

  ReferralSubmissionResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          gotReferredBy = jsonMap['gotReferredBy'] ?? "";
          gotReferredAt = jsonMap['gotReferredAt'] ?? "";
          referralCode = jsonMap['referralCode'] ?? "";
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        _handleIncorrectReferralCode(apiResponse);
        this.apiResponse = apiResponse;
    }
  }

  void _handleIncorrectReferralCode(ApiResponse apiResponse) {
    if (apiResponse.statusCode == 400) {
      Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
      message = jsonMap['Message'];
    }
    this.apiResponse = apiResponse..state = ResponseState.success;
  }


}
