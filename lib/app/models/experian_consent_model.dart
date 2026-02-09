import 'dart:convert';
import 'package:privo/app/api/response_model.dart';

enum ExperianConsentStatus { absent, active, expired }

class ExperianConsentModel {
  late final ExperianConsentStatus status;
  late final ApiResponse apiResponse;

  ExperianConsentModel.decodeResponse(this.apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          parseFromJson(jsonMap);
        } catch (e) {
          apiResponse.state = ResponseState.jsonParsingError;
          apiResponse.exception = e.toString();
        }
        break;
      default:
    }
  }

  parseFromJson(Map<String, dynamic> jsonMap) {
    String consentStatus =
        (jsonMap['responseBody']?['d2c_consent_status'] ?? "")
            .toString()
            .toUpperCase();
    status = _computeExperianConsentStatus(consentStatus);
    apiResponse.state = ResponseState.success;
  }

  ExperianConsentStatus _computeExperianConsentStatus(String status) {
    switch (status) {
      case 'ABSENT':
        return ExperianConsentStatus.absent;
      case 'ACTIVE':
        return ExperianConsentStatus.active;
      case 'EXPIRED':
      default:
        return ExperianConsentStatus.expired;
    }
  }
}
