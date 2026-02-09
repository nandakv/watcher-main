import 'dart:convert';
import 'package:privo/app/api/response_model.dart';

ReferralDataModel referralDataModelFromJson(ApiResponse apiResponse) =>
    ReferralDataModel.decodeResponse(apiResponse);

class ReferralDataModel {
  // apiResponse is now nullable to support creation from a map.
  ApiResponse? apiResponse;
  late final String gotReferredBy;
  late final String gotReferredAt;
  late final String referralCode;
  late final List<dynamic> referrals;
  late final bool enableReferral;

  /// Keeps the original functionality to decode from an ApiResponse.
  ReferralDataModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          gotReferredBy = jsonMap['gotReferredBy'] ?? "";
          gotReferredAt = jsonMap['gotReferredAt'] ?? "";
          referralCode = jsonMap['referralCode'] ?? "";
          referrals = jsonMap['referrals'] ?? [];
          enableReferral = referralCode.isNotEmpty;
          this.apiResponse = apiResponse;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
        break;
    }
  }

  /// Named constructor to decode directly from a map.
  ReferralDataModel.fromJson(Map<String, dynamic> jsonMap) {
    apiResponse = null; // No ApiResponse when creating from a map.
    gotReferredBy = jsonMap['gotReferredBy'] ?? "";
    gotReferredAt = jsonMap['gotReferredAt'] ?? "";
    referralCode = jsonMap['referralCode'] ?? "";
    referrals = jsonMap['referrals'] ?? [];
    enableReferral = referralCode.isNotEmpty;
  }
}