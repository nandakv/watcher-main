import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/sliding_button.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/experian_consent_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/credit_report/credit_report_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../api/response_model.dart';
import '../../../../data/repository/credit_report_repository.dart';
import '../../../../mixin/app_analytics_mixin.dart';
import '../../../../models/credit_score_request_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/polling_service.dart';
import '../../../../utils/error_logger_mixin.dart';
import '../../../masked_credit_score/masked_number_analytics_mixin.dart';
import '../../credit_report_helper_mixin.dart';
import '../../credit_report_logic.dart';
import '../../model/credit_report_response_model.dart';

enum CreditReportRefreshWidgetState {
  sliding,
  completed,
  error,
}

class CreditReportRefreshBottomSheetLogic extends GetxController
    with
        ErrorLoggerMixin,
        AppAnalyticsMixin,
        MaskedNumberAnalyticsMixin,
        CreditReportAnalyticsMixin,
        CreditReportHelperMixin {
  CreditReportRefreshWidgetState _state =
      CreditReportRefreshWidgetState.sliding;

  CreditReportRefreshWidgetState get state => _state;

  set state(CreditReportRefreshWidgetState value) {
    _state = value;
    update();
  }

  final slidingButtonController = SlidingButtonController();

  CreditScoreScale creditScoreScale = CreditScoreScale.poor;

  String creditScore = "";

  final _pollingService = PollingService();

  late CreditReportResponseModel creditReportResponseModel;

  final String SPARKLE_WIDGET = "sparkleWidget";

  bool _showSparkle = false;

  bool get showSparkle => _showSparkle;

  set showSparkle(bool value) {
    _showSparkle = value;
    update([SPARKLE_WIDGET]);
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isApiLoading = false;

  bool get isApiLoading => _isApiLoading;

  set isApiLoading(bool value) {
    _isApiLoading = value;
    update();
  }

  bool _isConsentRequired = false;

  bool get isConsentRequired => _isConsentRequired;

  set isConsentRequired(bool value) {
    _isConsentRequired = value;
    update();
  }

  bool _isConsentChecked = false;

  bool get isConsentChecked => _isConsentChecked;

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    update();
  }

  void onSlideToLoadTriggered(CreditScoreModel creditScoreModel) async {
    isApiLoading = true;
    logCreditScoreD2CRefreshPromptCTAClicked();
    if (creditScoreModel.applicationDetails.appFormId.isEmpty &&
        creditScoreModel.applicationDetails.pullStatus == "COMPLETED") {
      await _fetchCreditReportWithPhoneNumber();
    } else {
      _initiateCreditReportPulling(creditScoreModel);
    }
  }

  _fetchCreditReportWithPhoneNumber() async {
    Map body = {
      "phoneNumber": await AppAuthProvider.phoneNumber,
      "pullType": REFRESH_PULL,
      "consent": true
    };
    CreditReportResponseModel _creditReportResponse =
        await creditReportRepository.getCreditReportWithPhoneNumber(body: body);
    switch (_creditReportResponse.apiResponse.state) {
      case ResponseState.success:
        creditReportResponseModel = _creditReportResponse;
        _cleckPollingStatus();
        break;
      default:
        _onExperianPollingFailure();
        var apiResponse = creditReportResponseModel.apiResponse;
        logError(
          statusCode: apiResponse.statusCode.toString(),
          responseBody: apiResponse.apiResponse,
          requestBody: apiResponse.requestBody,
          exception: apiResponse.exception,
          url: apiResponse.url,
        );
    }
  }

  _initiateCreditReportPulling(CreditScoreModel creditScoreModel) async {
    Map body = {
      "appFormId": creditScoreModel.applicationDetails.appFormId,
      "applicantId": creditScoreModel.applicationDetails.applicantId,
      "pullType": REFRESH_PULL,
    };

    if (isConsentRequired && isConsentChecked) {
      body["consent"] = true;
    }
    CreditScoreRequestModel creditScoreData =
        await creditReportRepository.initiatePullCreditScore(body: body);

    switch (creditScoreData.apiResponse.state) {
      case ResponseState.success:
        _startPolling();
        break;
      default:
        _onExperianPollingFailure();
        var apiResponse = creditScoreData.apiResponse;
        logError(
          statusCode: apiResponse.statusCode.toString(),
          responseBody: apiResponse.apiResponse,
          requestBody: apiResponse.requestBody,
          exception: apiResponse.exception,
          url: apiResponse.url,
        );
    }
  }

  _startPolling() async {
    _pollingService.initAndStartPolling(
      pollingInterval: 10,
      maxPollingLimit: 5,
      pollingFunction: () {
        _fetchCreditReport();
      },
      onRetryFinished: Get.back,
      pollOnStart: true,
    );
  }

  _fetchCreditReport() async {
    CreditReportResponseModel creditReportResponse =
        await creditReportRepository.getCreditReport();
    switch (creditReportResponse.apiResponse.state) {
      case ResponseState.success:
        creditReportResponseModel = creditReportResponse;
        _cleckPollingStatus();
        break;
      default:
        _onExperianPollingFailure();
        var apiResponse = creditReportResponse.apiResponse;
        logError(
          statusCode: apiResponse.statusCode.toString(),
          responseBody: apiResponse.apiResponse,
          requestBody: apiResponse.requestBody,
          exception: apiResponse.exception,
          url: apiResponse.url,
        );
    }
  }

  _cleckPollingStatus() async {
    switch (creditReportResponseModel.status) {
      case CreditReportStatus.INITIATED:
        // keep polling
        break;
      case CreditReportStatus.COMPLETED:
        if (creditReportResponseModel.creditReport == null) {
          _onExperianPollingFailure();
          break;
        }
        logCreditScoreD2CRefreshPromptSuccessLoaded();
        _pollingService.stopPolling();
        creditScore = creditReportResponseModel.creditReport!.score.toString();
        _computeCreditScoreScaleInfo(
            creditReportResponseModel.creditReport!.score);
        slidingButtonController.markAsCompleted();
        showSparkle = true;
        await Future.delayed(const Duration(seconds: 2));
        showSparkle = false;
        state = CreditReportRefreshWidgetState.completed;
        await AppAuthProvider.setCreditScoreHomeRefreshShown();
        isApiLoading = false;
        break;
      case CreditReportStatus.FAILED:
        _onExperianPollingFailure();
        break;
    }
  }

  _onExperianPollingFailure() {
    slidingButtonController.reset();
    _pollingService.stopPolling();
    state = CreditReportRefreshWidgetState.error;
  }

  CreditScoreScale _computeCreditScoreScaleInfo(int score) {
    for (var scale in CreditScoreScale.values) {
      if (score >= scale.minScore && score <= scale.maxScore) {
        creditScoreScale = scale;
        return scale;
      }
    }
    return CreditScoreScale.poor;
  }

  onClosedClicked({CreditReportRefreshWidgetState? state}) async {
    await AppAuthProvider.setCreditScoreHomeRefreshShown();
    if (state != null) {
      state == CreditReportRefreshWidgetState.sliding
          ? logCreditScoreD2CRefreshPromptClosed()
          : null;
    }
    _pollingService.stopPolling();
    Get.back();
  }

  void onTapViewInsights(
      CreditScoreModel creditScoreModel, bool isReferralEnabled) async {
    await AppAuthProvider.setCreditScoreHomeRefreshShown();
    logCreditScoreD2CRefreshPromptInsightsCTAClicked();
    creditScoreModel.updateApplicationDetails(creditReportResponseModel);
    await Get.toNamed(
      Routes.CREDIT_REPORT,
      arguments: {
        'creditScoreModel': creditScoreModel,
        'isReferralEnabled': isReferralEnabled
      },
    );
    Get.back(result: true);
  }

  @override
  void onClose() {
    AppAuthProvider.setCreditScoreHomeRefreshShown();
    _pollingService.stopPolling();
    Get.log("Bottom Sheet Closed");
    super.onClose();
  }

  @override
  void dispose() {
    AppAuthProvider.setCreditScoreHomeRefreshShown();
    _pollingService.stopPolling();
    Get.log("Bottom Sheet Closed");
    super.dispose();
  }

  void onAfterFirstLayout() {
    ///check consent first
    _checkConsent();
  }

  _checkConsent() async {
    isLoading = true;
    ExperianConsentStatus? status = await checkConsentStatus();
    switch (status) {
      case ExperianConsentStatus.absent:
      case ExperianConsentStatus.expired:
        logCreditScoreD2CRefreshPromptLoaded();
        isConsentRequired = true;
        isLoading = false;
        break;
      case ExperianConsentStatus.active:
        isConsentRequired = false;
        isLoading = false;
        logCreditScoreD2CRefreshPromptLoaded();
        break;
      case null:
        state = CreditReportRefreshWidgetState.error;
    }
  }

  onConsentChanged(bool value) {
    isConsentChecked = value;
  }
}
