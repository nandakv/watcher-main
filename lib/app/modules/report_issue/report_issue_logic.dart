import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/report_issue/report_issue_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../amplify/auth/amplify_auth.dart';
import '../../data/repository/report_issue_repository.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_logger_mixin.dart';

class ReportIssueLogic extends GetxController
    with ReportIssueAnalyticsMixin, ErrorLoggerMixin {
  final TextEditingController issueDescriptionController =
      TextEditingController();

  final ReportIssueRepository reportIssueRepository = ReportIssueRepository();

  late String errorLog;
  late String screenName;
  bool fromHomeScreen = false;

  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: darkBlueColor, width: 1),
  );

  late final String BUTTON_ID = "BUTTON_ID";

  bool _buttonEnabled = false;
  bool _isSuccess = false;
  bool _buttonLoading = false;

  bool get buttonEnabled => _buttonEnabled;

  bool get buttonLoading => _buttonLoading;

  bool get isSuccess => _isSuccess;

  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    update([BUTTON_ID]);
  }

  set buttonLoading(bool value) {
    _buttonLoading = value;
    update([BUTTON_ID]);
  }

  set isSuccess(bool value) {
    _isSuccess = value;
    update();
  }

  String? validateReason(String? value) {
    if (value == null || value.isEmpty || value.length < 10) {
      return "Minimum of 10 characters";
    }
    return null;
  }

  onSubmit() async {
    buttonLoading = true;
    logDescribeIssueSubmitted(issueDescriptionController.text);
    Map<String, dynamic> body = {
      "subId": await AmplifyAuth.userID,
      "phoneNumber": await AppAuthProvider.phoneNumber,
      "appFormId": fromHomeScreen
          ? AppAuthProvider.getAppFormList
          : [AppAuthProvider.appFormID],
      "description": issueDescriptionController.text,
      "screenName": screenName,
      "logs": errorLog
    };
    ApiResponse response = await reportIssueRepository.raiseIssue(body);

    switch (response.state) {
      case ResponseState.success:
        break;
      default:
        logDescribeIssueApiFail();
        logError(
          requestBody: response.requestBody,
          exception: response.exception,
          url: response.url,
          responseBody: response.apiResponse,
          statusCode: response.statusCode.toString(),
        );
    }

    isSuccess = true;
    buttonLoading = false;
  }

  onTextChange(String? val) {
    if (val != null && val.isNotEmpty) {
      if (val.length >= 10) {
        buttonEnabled = true;
      } else {
        buttonEnabled = false;
      }
    }
  }

  onAfterLayout(String screenName, String errorLog, bool fromHomeScreen) {
    this.errorLog = errorLog;
    this.screenName = screenName;
    this.fromHomeScreen = fromHomeScreen;
  }
}
