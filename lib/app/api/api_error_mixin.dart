import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/report_issue/report_issue_analytics_mixin.dart';

import '../common_widgets/something_went_wrong_dialog.dart';
import '../amplify/auth/auth_logger_mixin.dart';
import '../firebase/analytics.dart';
import '../modules/report_issue/report_issue_widget.dart';
import '../utils/app_dialogs.dart';
import '../utils/error_logger_mixin.dart';
import '../utils/web_engage_constant.dart';

class ApiErrorMixin {
  handleAPIError(ApiResponse apiResponse,
      {required String screenName, Function? retry}) async {
    _logError(apiResponse);
    switch (apiResponse.state) {
      case ResponseState.notAuthorized:
        AuthLoggerMixin().logUnAuthorizedApiResponse(screenName);
        // Fluttertoast.showToast(msg: "Session Expired");
        AppAuthProvider.logout();
        break;
      case ResponseState.failure:
      case ResponseState.noInternet:
      case ResponseState.timedOut:
      case ResponseState.badRequestError:
      case ResponseState.jsonParsingError:
        await showErrorDialog(apiResponse, screenName, retry);
        break;
      default:
        break;
    }
  }

  Future<void> showErrorDialog(
      ApiResponse apiResponse, String screenName, Function? retry) async {
    apiResponse.exception = null;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.somethingWentWrongPopup,
      attributeName: {
        "screen_name": screenName,
        "status_code": apiResponse.statusCode ?? 0,
        "endpoint":
            apiResponse.url != null ? apiResponse.url!.split("/").last : "",
        "exception": apiResponse.exception ?? "Unknown",
        "state": apiResponse.state.name,
      },
    );
    ReportIssueAnalyticsMixin reportIssueAnalyticsMixin =
        ReportIssueAnalyticsMixin();
    reportIssueAnalyticsMixin.logRaiseIssueCardLoaded(screenName);
    // ErrorDialogResult? result =
    //     await AppDialogs.appErrorDialog(state, shouldRetry: retry != null);
    bool isReportIssueEnabled = await AppAuthProvider.isReportIssueEnabled;
    ErrorDialogResult? result = await Get.bottomSheet(
      SomethingWentWrongDialog(
        shouldRetry: retry != null,
        showReportIssue: isReportIssueEnabled,
      ),
      isDismissible: false,
    );

    if (result != null) {
      switch (result) {
        case ErrorDialogResult.retry:
          if (retry != null) retry();
          reportIssueAnalyticsMixin.logRaiseIssueCardClicked("retry");
          break;
        case ErrorDialogResult.close:
          reportIssueAnalyticsMixin.logRaiseIssueCardClicked("close");
          Get.back();
          break;
        case ErrorDialogResult.tryAgainLater:
          reportIssueAnalyticsMixin.logRaiseIssueCardClicked("try_again_later");
          Get.back();
          break;
        case ErrorDialogResult.reportIssue:
          onReportIssueClicked(
              apiResponse, screenName, retry, reportIssueAnalyticsMixin);
          break;
      }
    }
  }

  onReportIssueClicked(
      ApiResponse apiResponse,
      String screenName,
      Function? retry,
      ReportIssueAnalyticsMixin reportIssueAnalyticsMixin) async {
    bool isReported = await Get.bottomSheet(
      ReportIssueWidget(
        screenName: screenName,
        errorLog: apiResponse.exception.toString(),
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
    if (isReported) {
      Get.back();
    } else {
      showErrorDialog(apiResponse, screenName, retry);
    }
    reportIssueAnalyticsMixin.logRaiseIssueCardClicked("report_issue");
    reportIssueAnalyticsMixin
        .logDescribeIssueCardLoaded("raise_issue_error_card");
  }

  void _logError(ApiResponse apiResponse) async {
    ErrorLoggerMixin().logError(
      url: apiResponse.url,
      exception: apiResponse.exception,
      requestBody: apiResponse.requestBody,
      responseBody: apiResponse.apiResponse,
      statusCode: apiResponse.statusCode.toString(),
    );
  }
}
