import 'dart:convert';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';

import '../utils/app_functions.dart';
import 'app_form_status_model.dart';

///Response model that have CheckAppFormModel as base
///Helps in catching the json parsing errors
///If parsing fails we have the response state

enum PennyTestingStatus { success, pending, failed }

PennyStatusModel pennyStatusModelFromJson(ApiResponse apiResponse) {
  return PennyStatusModel.decodeResponse(apiResponse);
}

class PennyStatusModel extends CheckAppFormModel {
  late var id;
  late final String serviceProvider;
  late final String name;
  late final String accountNumber;
  late final String ifsc;
  late final String debitAccountNumber;
  late final String status;
  late final String utr;
  late final String registeredName;
  late final String accountStatus;
  late final String failureReason;
  late final String validationId;
  late final String nameMatchStatus;
  late final PennyTestingStatus pennyTestingStatus;
  late final String appState;
  late final String result;
  late Rejection? rejection;
  late AppFormRejectionModel appFormRejectionModel;

  PennyStatusModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        // _parseJson(apiResponse);
        // _computeRejection();
        // this.apiResponse = apiResponse..state = ResponseState.success;
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
      default:
        this.apiResponse = apiResponse;
    }
  }

  void _computeRejection() {
    appFormRejectionModel =
        AppFunctions().computeAppFormRejection(rejection: rejection);
  }

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    Map<String, dynamic> json = jsonMap['responseBody'];
    rejection = jsonMap['rejection'] == null
        ? null
        : Rejection.fromJson(jsonMap['rejection']);
    id = json['id'];
    serviceProvider = json['serviceProvider'] ?? "";
    name = json['name'] ?? "";
    accountNumber = json['accountNumber'] ?? "";
    ifsc = json['ifsc'] ?? "";
    debitAccountNumber = json['debitAccountNumber'] ?? "";
    status = json['status'];
    utr = json['utr'] ?? "";
    registeredName = json['registeredName'] ?? "";
    accountStatus = json['accountStatus'] ?? "";
    failureReason = json['failureReason'] ?? "";
    validationId = json['validationId'] ?? "";
    result = json['result'] ?? "";
    nameMatchStatus = json['nameMatchStatus'] ?? "";
    pennyTestingStatus = _computePennyTestingStatus(result);
    appState = json['app_state'] ?? "$PENNY_TESTING";
  }

  PennyTestingStatus _computePennyTestingStatus(String result) {
    switch (result) {
      case "PENDING":
        return PennyTestingStatus.pending;
      case "SUCCESS":
        return PennyTestingStatus.success;
      case "FAILURE":
        return PennyTestingStatus.failed;
      default:
        return PennyTestingStatus.pending;
    }
  }
}
