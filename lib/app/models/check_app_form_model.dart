import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../firebase/analytics.dart';
import 'app_form_rejection_model.dart';
import 'app_form_status_model.dart';

CheckAppFormModel checkAppFormModelFromJson(ApiResponse apiResponse) {
  return CheckAppFormModel.decodeResponse(apiResponse);
}

enum VKYCPollingStatus {
  complete,
  rejected,
  physicalKYC,
  open,
  failure,
  agentAssigned,
  newUser,
  switchToSelfie,
  okycExpiredToSelfie,
  okycExpiredToAadhaar,

  ///consider as a new user
  retryingExpiredOkyc,
}

class CheckAppFormModel {
  late final Rejection? rejection;
  late final String? responseCode;
  late final String appFormId;
  late final DateTime? currentTimestamp;
  late var responseBody;
  late ApiResponse apiResponse;
  late AppFormRejectionModel appFormRejectionModel;
  SequenceEngineModel? sequenceEngine;
  Error? error;
  VKYCPollingStatus? vKYCPollingStatus;
  bool isBrowserToAppFlow = false;

  final String _POLLING_COMPLETE_STATUS = "COMPLETE";
  final String _POLLING_FAILURE_STATUS = "FAILURE";
  final String _VKYC_AGENT_ASSIGNED_STATUS = "AGENTASSIGNED";
  final String _VKYC_REJECTED_STATUS = "REJECTED";

  ///If agent feels the user to retry, he will mark the status as  unable
  ///in the dashboard. So, the status will come as unable.
  final String _VKYC_UNABLE_STATUS = "UNABLE";
  final String _VKYC_OPEN_STATUS = "OPEN";
  final String _VKYC_PHYSICAL_KYC_STATUS = "PHYSICALKYC";
  final String _VKYC_SUCCESS_STATUS = "SUCCESSFUL";
  final String _VKYC_TO_SELFIE_STATUS = "SWITCHTOSELFIE";
  final String _OKYC_EXPIRED_STATUS = "OKYCEXPIRED";
  final String _RETRYING_OKYC_EXPIRED = "RETRYINGEXPIREDOKYC";

  CheckAppFormModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          _computeRejection();
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      case ResponseState.badRequestError:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          error = jsonMap['error'] == null || jsonMap['error'].isEmpty
              ? null
              : Error.fromJson(jsonMap['error']);
          this.apiResponse = apiResponse;
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

  void _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    appFormId = jsonMap['appFormId'];

    currentTimestamp = jsonMap["timestamp"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(jsonMap["timestamp"]);
    responseCode = jsonMap['responseCode'] ?? '';

    rejection = jsonMap['rejection'] == null
        ? null
        : Rejection.fromJson(jsonMap['rejection']);
    responseBody = jsonMap['responseBody'] ?? {};

    error = jsonMap['error'] == null || jsonMap['error'].isEmpty
        ? null
        : Error.fromJson(jsonMap['error']);
    sequenceEngine = jsonMap['sequenceEngine'] != null
        ? SequenceEngineModel.fromJson(jsonMap['sequenceEngine'])
        : null;

    if (responseBody is Map) {
      _computeBrowserToAppFlow(responseBody);
      _computeVKYCPollingStatus(responseBody);
    }
  }

  void _computeBrowserToAppFlow(Map responseBody) {
    isBrowserToAppFlow = (responseBody['platform_type'] ?? "") == "web";
  }

  void _computeVKYCPollingStatus(Map<String, dynamic> responseBody) {
    if (responseBody['vkyc'] == null) {
      vKYCPollingStatus = VKYCPollingStatus.newUser;
      return;
    }

    String vkycStatus = responseBody['vkyc']['status'].toString().toUpperCase();

    if (vkycStatus == _OKYC_EXPIRED_STATUS &&
        responseBody['app_state'] == "$KYC_AADHAAR") {
      vKYCPollingStatus = VKYCPollingStatus.okycExpiredToAadhaar;
      return;
    }

    vKYCPollingStatus = _vkycStatusMap[vkycStatus] ?? VKYCPollingStatus.failure;
  }

  Map<String, VKYCPollingStatus> get _vkycStatusMap => {
        _VKYC_OPEN_STATUS: VKYCPollingStatus.open,
        _VKYC_AGENT_ASSIGNED_STATUS: VKYCPollingStatus.agentAssigned,
        _VKYC_UNABLE_STATUS: VKYCPollingStatus.failure,
        _VKYC_REJECTED_STATUS: VKYCPollingStatus.rejected,
        _VKYC_SUCCESS_STATUS: VKYCPollingStatus.complete,
        _VKYC_TO_SELFIE_STATUS: VKYCPollingStatus.switchToSelfie,
        _OKYC_EXPIRED_STATUS: VKYCPollingStatus.okycExpiredToSelfie,
        _RETRYING_OKYC_EXPIRED: VKYCPollingStatus.retryingExpiredOkyc,
        _VKYC_PHYSICAL_KYC_STATUS: VKYCPollingStatus.physicalKYC,
      };

  void _computeRejection() {
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "applicant_rejected",
        userAttributeValue: rejection?.status);
    appFormRejectionModel =
        AppFunctions().computeAppFormRejection(rejection: rejection);
  }
}

// class Rejection {
//   Rejection({
//     required this.status,
//     required this.code,
//     required this.reason,
//   });
//
//   late final String status;
//   late final String code;
//   late final String reason;
//
//   Rejection.fromJson(Map<String, dynamic> json) {
//     status = json['status'] ?? "";
//     code = json['code'] ?? "";
//     reason = json['reason'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['reason'] = reason;
//     _data['status'] = status;
//     return _data;
//   }
// }

class Error {
  Error({
    required this.errorMessage,
    required this.errorBody,
    required this.errorTitle,
  });

  String errorTitle;
  String errorMessage;
  ErrorBody errorBody;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorMessage: json["errorMessage"],
        errorTitle: json["errorTitle"] ?? "",
        errorBody: ErrorBody.fromJson(json["errorBody"]??{}),
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "errorBody": errorBody.toJson(),
      };
}

class ErrorBody {
  ErrorBody({
    required this.fieldErrors,
    required this.message,
    required this.type,
  });

  List<FieldError> fieldErrors;
  String message;
  String type;

  factory ErrorBody.fromJson(Map<String, dynamic> json) => ErrorBody(
        message: json['message'] ?? "",
        type: json['type'] ?? "",
        fieldErrors: json["fieldErrors"] == null
            ? []
            : List<FieldError>.from(
                json["fieldErrors"].map((x) => FieldError.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fieldErrors": List<dynamic>.from(fieldErrors.map((x) => x.toJson())),
      };
}

class FieldError {
  FieldError({
    required this.fieldName,
    required this.message,
  });

  String fieldName;
  String message;

  factory FieldError.fromJson(Map<String, dynamic> json) => FieldError(
        fieldName: json["fieldName"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "fieldName": fieldName,
        "message": message,
      };
}
