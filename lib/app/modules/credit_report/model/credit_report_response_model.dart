import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';

enum CreditReportStatus { INITIATED, COMPLETED, FAILED }

class CreditReportResponseModel {
  CreditReport? creditReport;
  late final CreditReportStatus status;
  late bool refreshAvailable;
  late String lastPulledDateTime;
  late ApiResponse apiResponse;

  CreditReportResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Credit report details exception ${e.toString()}");
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
    String rawStatus = json['status'];
    lastPulledDateTime = json['lastPulledDateTime'] ?? "";
    refreshAvailable = json['refreshAvailable'] ?? false;
    switch (rawStatus) {
      case "INITIATED":
        status = CreditReportStatus.INITIATED;
        break;
      case "COMPLETED":
        status = CreditReportStatus.COMPLETED;
        creditReport = CreditReport.fromJson(json);
        break;
      case "FAILED":
      default:
        status = CreditReportStatus.FAILED;
        break;
    }
  }
}
