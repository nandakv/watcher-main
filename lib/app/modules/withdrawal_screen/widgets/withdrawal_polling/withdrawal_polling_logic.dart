import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/horizontal_timeline_step_widget.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/withdrawal_polling_mixin.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/modules/withdrawal_screen/mixins/withdrawal_api_mixin.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/insurance_container/insurance_container_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_navigation.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_logic.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../../res.dart';
import '../../../../routes/app_pages.dart';
import '../../withdrawal_analytics.dart';

class WithdrawalPollingLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        WithdrawalApiMixin,
        WithdrawalAnalytics {
  final _withdrawalPolling = WithdrawalPolling();
  final logic = Get.find<WithdrawalLogic>();
  final insuranceLogic = Get.find<InsuranceContainerLogic>();
  bool isLoading = true;

  WithdrawalNavigation? withdrawalNavigation;

  WithdrawalPollingLogic({this.withdrawalNavigation});

  double disbursedAmount = 0.0;
  String errorMessage = "";
  DateTime? errorDateTime;

  HorizontalTimelineStepWidgetState initiatedState =
      HorizontalTimelineStepWidgetState.success;

  HorizontalTimelineStepWidgetState processedState =
      HorizontalTimelineStepWidgetState.inActive;

  HorizontalTimelineStepWidgetState transferredState =
      HorizontalTimelineStepWidgetState.inActive;

  final String WITHDRAWAL_POLLING_PAGE_KEY = "WITHDRAWAL_POLLING_PAGE_KEY";

  WithdrawalPollingStatus _withdrawalPollingStatus =
      WithdrawalPollingStatus.initiated;

  WithdrawalPollingStatus get withdrawalPollingStatus =>
      _withdrawalPollingStatus;

  late String WITHDRAWAL_POLLING_SCREEN = "withdrawal_polling";

  set withdrawalPollingStatus(WithdrawalPollingStatus value) {
    isLoading = false;
    _withdrawalPollingStatus = value;
    _computeTimelineStates();
    update([WITHDRAWAL_POLLING_PAGE_KEY]);
  }

  String pollingTitleText = "Cash out, Happiness in!";
  String pollingBodyText = "Most receive their money in 5 minutes or less";
  String topRightIcon = Res.minimizeSVG;
  String centerIllustration = Res.withdrawal_polling_svg;

  _computeTimelineStates() {
    initiatedState = HorizontalTimelineStepWidgetState.success;
    processedState = HorizontalTimelineStepWidgetState.inActive;
    transferredState = HorizontalTimelineStepWidgetState.inActive;

    switch (withdrawalPollingStatus) {
      case WithdrawalPollingStatus.initiated:
        initiatedState = HorizontalTimelineStepWidgetState.success;
        processedState = HorizontalTimelineStepWidgetState.active;
        break;
      case WithdrawalPollingStatus.processed:
        processedState = HorizontalTimelineStepWidgetState.success;
        transferredState = HorizontalTimelineStepWidgetState.active;
        break;
      case WithdrawalPollingStatus.withdrawCancelled:
        pollingTitleText = "Withdrawal Failed";
        pollingBodyText = "Oops! Something went wrong";
        centerIllustration = Res.piggy_bank_failure_svg;
        processedState = HorizontalTimelineStepWidgetState.failure;
        break;
      case WithdrawalPollingStatus.loanCreated:
        processedState = HorizontalTimelineStepWidgetState.success;
        transferredState = HorizontalTimelineStepWidgetState.success;
        break;
      case WithdrawalPollingStatus.withdrawalFailed:
        pollingTitleText = "Withdrawal Failed";
        pollingBodyText = "It is taking longer than expected";
        topRightIcon = Res.close_mark_svg;
        centerIllustration = Res.bank_verify_failure;
        processedState = HorizontalTimelineStepWidgetState.success;
        transferredState = HorizontalTimelineStepWidgetState.failure;
        break;
    }
  }

  startWithdrawPolling() {
    _withdrawalPolling.initAndStart(
      onInitiated: _onWithdrawalInitiated,
      onProcessed: _onWithdrawalProcessed,
      onCancelled: _onWithdrawalCancelled,
      onSuccess: _onWithdrawalSuccess,
      onFailed: _onWithdrawalFailed,
      onApiError: _onWithdrawalApiError,
    );
  }

  _onWithdrawalInitiated() {
    withdrawalPollingStatus = WithdrawalPollingStatus.initiated;
  }

  _onWithdrawalProcessed() {
    withdrawalPollingStatus = WithdrawalPollingStatus.processed;
  }

  _onWithdrawalCancelled(String errorMessage, DateTime? errorDateTime) {
    this.errorMessage = errorMessage;
    this.errorDateTime = errorDateTime;
    logWithdrawalFailureLoaded();
    withdrawalPollingStatus = WithdrawalPollingStatus.withdrawCancelled;
  }

  _onWithdrawalSuccess(double disbursedAmount) async {
    this.disbursedAmount = disbursedAmount;
    withdrawalPollingStatus = WithdrawalPollingStatus.loanCreated;
    _navigateToSuccessScreen();
  }

  _navigateToSuccessScreen() {
    if (withdrawalNavigation != null) {
      withdrawalNavigation!.navigateToSuccessScreen();
    } else {
      onNavigationDetailsNull('withdrawal-polling');
    }
  }

  _onWithdrawalFailed(String errorMessage, DateTime? errorDateTime) {
    this.errorMessage = errorMessage;
    this.errorDateTime = errorDateTime;
    logWithdrawalFailureLoaded();
    withdrawalPollingStatus = WithdrawalPollingStatus.withdrawalFailed;
  }

  _onWithdrawalApiError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: WITHDRAWAL_POLLING_SCREEN, retry: startWithdrawPolling);
  }

  @override
  void onClose() {
    Get.log("on withdrawal closed");
    // _withdrawalPolling.stop();
  }

  void afterLayout() async {
    _initializeVariables();
    isLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawalPendingScreenLoaded);
    logWithdrawalPollingLoaded();
    await startWithdrawPolling();
  }

  void _initializeVariables() {
    pollingTitleText = "Cash out, Happiness in!";
    pollingBodyText = "Most receive their money in 5 minutes or less";
    topRightIcon = Res.minimizeSVG;
    centerIllustration = Res.withdrawal_polling_svg;
    withdrawalPollingStatus = WithdrawalPollingStatus.initiated;
  }

  void onMinimizePressed() {
    logWithdrawalPollingMinimizedClicked(
      withdrawalPollingStatus == WithdrawalPollingStatus.withdrawCancelled,
    );
    _withdrawalPolling.stop();
    Get.back(
        result: withdrawalPollingStatus == WithdrawalPollingStatus.initiated ||
            withdrawalPollingStatus == WithdrawalPollingStatus.processed);
  }

  ///on withdrawal failed, on click on text button
  void navigateToServicingScreen() async {
    await Get.toNamed(Routes.SERVICING_SCREEN);
    Get.back();
  }

  onRetryWithdrawalClicked() {
    logWithdrawalRetryClicked();
    if (withdrawalNavigation != null) {
      logic.withdrawalState = WithdrawalState.loading;
      withdrawalNavigation!.navigateToWithdrawCalculationPage();
      insuranceLogic.toggleInsuranceCheckBox(true);
    } else {
      onNavigationDetailsNull('withdrawal-polling');
    }
  }

  onClosePressed() {
    _withdrawalPolling.stop();
    Get.back();
  }

  stopPolling() {
    _withdrawalPolling.stop();
  }

  startPolling() {
    startWithdrawPolling();
  }
}
