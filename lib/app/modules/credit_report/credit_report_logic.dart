import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/models/experian_consent_model.dart';
import 'package:privo/app/models/credit_score_request_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/ab_user/ab_testing_mixin.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_response_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_know_more_v2_widget.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_line_graph/credit_line_graph_bottom_Sheet.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_line_graph/credit_scoreline_graph_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_line_graph/credit_score_update_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_redirect_bottom_sheet.dart';
import 'package:privo/app/modules/credit_report/model/key_benefits_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_feedback_bottom_sheet.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_scale_info_bottom_sheet.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/modules/credit_report/widgets/update_info_bottom_sheet.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/faq/faq_page.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/modules/masked_credit_score/masked_number_analytics_mixin.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/polling_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/components/button.dart';
import 'package:privo/components/selection_chip_widget/selection_chip_model.dart';

import '../../../res.dart';
import '../../api/api_error_mixin.dart';
import '../../api/response_model.dart';
import '../../common_widgets/bottom_sheet_widget.dart';
import '../../common_widgets/forms/base_field_validator.dart';
import '../../common_widgets/forms/personal_details_field_validators.dart';
import '../../common_widgets/gradient_button.dart';
import '../../common_widgets/otp/bottom_sheet_otp_interface.dart';
import '../../common_widgets/otp/bottom_sheet_otp_logic.dart';
import '../../common_widgets/otp/bottom_sheet_otp_widget.dart';
import '../../common_widgets/privo_text_editing_controller.dart';
import '../../mixin/app_analytics_mixin.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_logger_mixin.dart';
import '../../utils/snack_bar.dart';
import '../authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../know_more_and_get_started/know_more_helper.dart';
import '../masked_credit_score/credit_score_mobile_bottom_sheet.dart';
import '../masked_credit_score/models/masked_mobile_response_model.dart';
import '../masked_credit_score/models/masked_otp_response_model.dart';
import '../on_boarding/widgets/search_screen/bank_logo_mixin.dart';
import '../stateless_credit_score/stateless_credit_Score_analytics_mixin.dart';
import 'credit_report_analytics_mixin.dart';
import 'credit_report_helper_mixin.dart';
import 'model/key_metric.dart';
import 'widgets/credit_score_consent_modal_sheet.dart';
import 'widgets/credit_score_consent_widget/credit_score_consent_widget.dart';
import 'widgets/credit_scrore_know_more_body_widget.dart';
import 'widgets/powered_by_widget.dart';

enum CreditReportFeedbackState {
  feedback,
  thankYou,
}

class CreditReportLogic extends GetxController
    with
        ErrorLoggerMixin,
        CreditReportAnalyticsMixin,
        BankLogoMixin,
        BaseFieldValidators,
        ApiErrorMixin,
        AppAnalyticsMixin,
        MaskedNumberAnalyticsMixin,
        CreditReportHelperMixin,
        AbTestingMixin,
        PersonalDetailsFieldValidators,
        StatelessCreditScoreAnalyticsMixin
    implements KnowMoreHelper, BottomSheetOTPHandler {
  late final String CREDIT_REPORT_FEEDBACK_ID = "CREDIT_REPORT_FEEDBACK";
  late final String FEEDBACK_OPTIONS_ID = "FEEDBACK_OPTIONS_ID";
  late final String FEEDBACK_REASON_ID = "FEEDBACK_REASON_ID";
  late final String FEEDBACK_SUBMIT_BUTTON_ID = "FEEDBACK_SUBMIT_BUTTON_ID";

  late final TextEditingController feedbackController = TextEditingController();

  late CreditScoreUpdate creditScoreUpdate;

  CreditReportFeedbackState _creditReportFeedbackState =
      CreditReportFeedbackState.feedback;

  CreditReportFeedbackState get creditReportFeedbackState =>
      _creditReportFeedbackState;

  set creditReportFeedbackState(CreditReportFeedbackState value) {
    _creditReportFeedbackState = value;
    update([CREDIT_REPORT_FEEDBACK_ID]);
  }

  final String RADIO_BUTTON_ID = "RADIO_BUTTON_ID";
  final String BOTTOM_SHEET_CONTINUE_CTA = "BOTTOM_SHEET_CONTINUE_CTA";
  final String MASKED_TEXT_FIELD = "MASKED_TEXT_FIELD";
  final String OTP_PINPUT = "pinput";
  final String MASKED_OTP_SCREEN = 'MASKED_OTP_SCREEN';
  late final String ALL_CREDIT_LOANS = "ALL_CREDIT_LOANS_ID";
  final String CREDIT_SCORE_HISTORY = 'CREDIT_SCORE_HISTORY';

  late final String FRESH_PULL = "D2CFP";
  late final String CONSENT_CHECKBOX_ID = "consent_checkbox";
  late final String STATELESS_CONSENT_CHECKBOX_ID =
      "stateless_consent_checkbox";
  late final String BUTTON_ID = "button";
  late final String STATELESS_BUTTON_ID = "stateless_button";
  late final String PAYMENT_HISTORY_TABLE = "payment_hisory_table";
  late final String CREDIT_OVERVIEW = "credit_overview";
  late String PAGE_INDICATOR_ID = "'PAGE_INDICATOR'";
  static const String MASKED_NUMBER_FLOW = "D2C001";
  static const String UNABLE_TO_PROCEED = "D2CERR103";
  late final String SCORE_POINT_WIDGET = "SCORE_POINT_WIDGET";

  String CREDITSCORE_EXP_NAME = "credit_score_know_more_exp";

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  final List<String> _radioGroupValues = [];
  String selectedValue = "";
  String otpErrorText = "";
  bool _isMobileNumberSelected = false;
  bool _isResendLoading = false;
  String selectedMaskedNumber = "";

  List<String> get radioGroupValues => _radioGroupValues;

  String get radioGroupValue => selectedValue;

  bool get isMobileNumberSelected => _isMobileNumberSelected;

  bool get isResendLoading => _isResendLoading;

  bool isReferralEnabled = false;

  set isResendLoading(bool value) {
    _isResendLoading = value;
    update(['resend']);
  }

  String group = "know_more_screen_1";

  set isMobileNumberSelected(bool value) {
    _isMobileNumberSelected = value;
    update([BOTTOM_SHEET_CONTINUE_CTA]);
  }

  set radioGroupValue(String value) {
    phoneController.clear();
    _radioGroupValues.add(value);
    selectedValue = value;
    logCreditScoreMaskedFlowNumberSelected();
    _updateMobileNumberSelection(
        validateMaskedMobileNumber(phoneController.text, maskedValue: value));
  }

  bool _isCreditScorePointLoading = true;

  bool get isCreditScorePointLoading => _isCreditScorePointLoading;

  set isCreditScorePointLoading(bool value) {
    _isCreditScorePointLoading = value;

    update(["SCORE_POINT_WIDGET"]);
  }

  late final BoxDecoration errorPinPutDecoration =
      _buildDecoration(borderColor: const Color(0xffE35959));
  late final BoxDecoration pinPutDecoration = _buildDecoration();
  late BoxDecoration selectedFieldDecoration = _buildDecoration();

  CreditReportState _currentCreditReportState = CreditReportState.loading;
  CreditReportState _previousCreditReportState = CreditReportState.loading;

  CreditReportState get currentCreditReportState => _currentCreditReportState;

  late CreditScoreModel creditScoreModel;

  bool isConsentRequired = false;

  // this variable is set when user clicks on refresh button
  bool _isRefresh = false;
  bool _isCreditScoreFeedbackGiven = false;

  late final List<String> feedbackOptions = [
    "I recently checked my credit score",
    "I feel this will affect my score",
    "I expected to see my loan eligibility",
    "I am concerned about my data sharing",
    "Others",
  ];

  late final String FEEDBACK_OTHERS = "Others";

  late String _selectedFeedbackOption = "";

  bool get shouldShowCreditPointStatus {
    return !isCreditScorePointLoading && creditScoreLineGraphModel.creditScoreHistory.length >= 2;
  }

  String get selectedFeedbackOption => _selectedFeedbackOption;

  set selectedFeedbackOption(String value) {
    _selectedFeedbackOption = value;
    logCSIntroFeedbackSelectionChange(value);
    update([FEEDBACK_OPTIONS_ID, FEEDBACK_SUBMIT_BUTTON_ID]);
  }

  set currentCreditReportState(CreditReportState newCreditReportState) {
    logEventsOnScreenChange(newCreditReportState,
        _computeEventArgumentsOnScreenChange(newCreditReportState), _isRefresh);
    _previousCreditReportState = _currentCreditReportState;
    _currentCreditReportState = newCreditReportState;
    update();
  }

  onFeedbackSelectionChanged(String? value) {
    selectedFeedbackOption = value ?? "";
    validateFeedback();
  }

  bool _isFeedbackSubmitButtonEnabled = false;

  bool get isFeedbackSubmitButtonEnabled => _isFeedbackSubmitButtonEnabled;

  set isFeedbackSubmitButtonEnabled(bool value) {
    _isFeedbackSubmitButtonEnabled = value;
    update([FEEDBACK_SUBMIT_BUTTON_ID]);
  }

  validateFeedback() {
    if (selectedFeedbackOption == FEEDBACK_OTHERS) {
      isFeedbackSubmitButtonEnabled = feedbackController.text.length >= 5;
    } else {
      isFeedbackSubmitButtonEnabled = true;
    }
  }

  Map<String, dynamic>? _computeEventArgumentsOnScreenChange(
      CreditReportState newCreditReportState) {
    switch (newCreditReportState) {
      case CreditReportState.success:
        return {creditScoreScale.title: true};
      case CreditReportState.dashboard:
        return {
          "refresh_available": creditScoreModel.refreshAvailable,
          "last_update": creditScoreModel.applicationDetails.lastUpdatedDate
        };
      case CreditReportState.knowMore:
        return {'version': assignedGroup};
      default:
        return null;
    }
  }

  late final ScrollController creditReportScrollController = ScrollController();
  late final ScrollController creditOverviewScrollController =
      ScrollController();
  late final ScrollController keyMetricScrollController = ScrollController();
  late final Key creditOverviewScrollKey =
      const PageStorageKey<String>('credit_overview');
  late Key creditReportScrollKey =
      const PageStorageKey<String>('credit_report');
  late Key keyMetricScrollKey = const PageStorageKey<String>('key_metric');

  late CreditInfoType _selectedCreditInfoType;

  CreditInfoType get selectedCreditInfoType => _selectedCreditInfoType;

  set selectedCreditInfoType(CreditInfoType value) {
    _selectedCreditInfoType = value;
  }

  CreditAccountType _creditOverviewAccountType = CreditAccountType.loan;

  CreditAccountType get creditOverviewAccountType => _creditOverviewAccountType;

  set creditOverviewAccountType(CreditAccountType newCreditAccountTypeValue) {
    _creditOverviewAccountType = newCreditAccountTypeValue;
    logEventsOnCreditAccountTypeChange(
      creditAccountType: newCreditAccountTypeValue,
      activeCount: getAccountCount(false),
      closedCount: getAccountCount(true),
    );
    update([ALL_CREDIT_LOANS]);
  }

  static const String KNOW_MORE_V1 = 'know_more_v1';
  static const String KNOW_MORE_V2 = 'know_more_v2';

  int getAccountCount(isClosed) =>
      fetchAccounts(fetchClosedLoans: isClosed).length;

  CreditReportStatus? creditReportStatus;

  bool isShowingMore = false;

  int maxCreditOverviewItems = 3;

  late CreditReport creditReport;

  late CreditScoreScale creditScoreScale;

  late CreditScoreLineGraphModel creditScoreLineGraphModel;

  late PageController creditScoreScaleCarousalController;

  late int currSelectedYear;
  late int startYear;
  late int lastYear;

  late CreditAccount creditAccount;

  late List<SelectionChipModel> selectionChips = [];
  PrivoTextEditingController emailController = PrivoTextEditingController();
  PrivoTextEditingController panController = PrivoTextEditingController();
  PrivoTextEditingController fullNameController = PrivoTextEditingController();

  String applicantMobileNumber = "";
  List<String> otherApplicantsPanNumbers = [];

  bool _coApplicantButtonEnabled = false;

  bool get coApplicantButtonEnabled => _coApplicantButtonEnabled;

  set coApplicantButtonEnabled(bool value) {
    _coApplicantButtonEnabled = value;
    update();
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID, STATELESS_BUTTON_ID]);
  }

  bool _isStatelessConsentChecked = false;

  bool get isStatelessConsentChecked => _isStatelessConsentChecked;

  set isStatelessConsentChecked(bool value) {
    _isStatelessConsentChecked = value;
    validateCoApplicantForm();
    update([STATELESS_CONSENT_CHECKBOX_ID, STATELESS_BUTTON_ID]);
  }

  onStatelessConsentValueChanged(bool? val) {
    if (val != null) {
      isStatelessConsentChecked = val;
      update();
    }
  }

  bool _isConsentChecked = false;

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    update([CONSENT_CHECKBOX_ID, BUTTON_ID]);
  }

  bool get isConsentChecked => _isConsentChecked;

  final _pollingService = PollingService();

  late int _creditOverviewLength;

  int get creditOverviewLength => _creditOverviewLength;

  set creditOverviewLength(int value) {
    _creditOverviewLength = value;
    update([CREDIT_OVERVIEW]);
  }

  onNextYear() {
    currSelectedYear += 1;
    update([PAYMENT_HISTORY_TABLE]);
  }

  onPrevYear() {
    currSelectedYear -= 1;
    update([PAYMENT_HISTORY_TABLE]);
  }

  TransactionHistoryDataType getTransactionHistoryType(int index) {
    return creditAccount.tableData[currSelectedYear]![index];
  }

  gotoFAQ() async {
    await Get.to(
      () => FAQPage(faqModel: FAQUtility().creditReportFAQs),
    );
  }

  bool get isPrevYearDisabled => currSelectedYear < startYear + 1;

  bool get isNextYearDisabled => currSelectedYear > lastYear - 1;

  _fetchCreditReport() async {
    CreditReportResponseModel _creditReportResponse =
        await creditReportRepository.getCreditReport();
    switch (_creditReportResponse.apiResponse.state) {
      case ResponseState.success:
        _checkPollingStatus(_creditReportResponse);
        break;
      default:
        stopExperianPolling();
        currentCreditReportState = CreditReportState.failure;
        var apiResponse = _creditReportResponse.apiResponse;
        logErrorFromApi(apiResponse);
    }
  }

  _fetchCreditReportWithPhoneNumber() async {
    currentCreditReportState = CreditReportState.polling;
    Map body = {
      "phoneNumber": await AppAuthProvider.phoneNumber,
      "pullType": creditScoreModel.refreshAvailable ? REFRESH_PULL : FRESH_PULL,
      "consent": true
    };
    CreditReportResponseModel _creditReportResponse =
        await creditReportRepository.getCreditReportWithPhoneNumber(body: body);
    switch (_creditReportResponse.apiResponse.state) {
      case ResponseState.success:
        _checkPollingStatus(_creditReportResponse);
        break;
      default:
        stopExperianPolling();
        currentCreditReportState = CreditReportState.failure;
        var apiResponse = _creditReportResponse.apiResponse;
        logErrorFromApi(apiResponse);
    }
  }

  fetchStatelessCreditReport() async {
    isButtonLoading = true;
    currentCreditReportState = CreditReportState.polling;
    logCreditScoreD2CWhitelistPollingLoaded();
    String firstName = '';
    String lastName = '';
    String fullName = fullNameController.text.trim();
    List<String> nameParts = fullName.trim().split(RegExp(r'\s+'));

    if (nameParts.isNotEmpty) {
      firstName = nameParts.first;
      if (nameParts.length > 1) {
        lastName = nameParts.last;
      }
    }
    Map body = {
      "firstName": firstName,
      "surName": lastName,
      "email": emailController.text,
      "phoneNumber": await AppAuthProvider.phoneNumber,
      "pan": panController.text,
      "consent": isStatelessConsentChecked ? true : false
    };
    CreditReportResponseModel _creditReportResponse =
        await creditReportRepository.getStatelessCreditReport(body: body);
    switch (_creditReportResponse.apiResponse.state) {
      case ResponseState.success:
        _checkPollingStatus(_creditReportResponse);
        isButtonLoading = false;
        logCreditScoreD2CWhitelistSuccessLoaded();
        break;
      default:
        stopExperianPolling();
        currentCreditReportState = CreditReportState.failure;
        logCreditScoreD2CWhitelistFailureLoaded();
        var apiResponse = _creditReportResponse.apiResponse;
        logErrorFromApi(apiResponse);
        isButtonLoading = false;
    }
  }

  String? validateReason(String? reason) {
    if (reason == null || reason.length < 5) {
      return "Please state the reason";
    }
    return null;
  }

  _updateCreditScoreModel(CreditReportResponseModel creditReportResponse) {
    String lastPulledDateTime = creditReportResponse.lastPulledDateTime;
    if (lastPulledDateTime.isNotEmpty) {
      CreditScoreApplicationDetails applicationDetailsModel =
          creditScoreModel.applicationDetails;
      creditScoreModel.refreshAvailable = creditReportResponse.refreshAvailable;
      applicationDetailsModel.lastPulledDateTime = lastPulledDateTime;
      applicationDetailsModel.lastUpdatedDate =
          AppFunctions().getLastUpdatedFormat(lastPulledDateTime);
      applicationDetailsModel.nextScoreUpdateDays =
          AppFunctions().getNextScoreUpdateDaysCount(lastPulledDateTime);
      applicationDetailsModel.nextUpdateAvailableFormat =
          AppFunctions().getNextUpdateAvailableFormat(lastPulledDateTime);
    }
  }

  List<KeyMetric> getKeyMetricsForSelectedCreditInfoType() {
    return creditReport.keyMetricInfos[selectedCreditInfoType]?.keyMetrics ??
        [];
  }

  int getKeyMetricsAccountCount() {
    return creditReport.keyMetricInfos[selectedCreditInfoType]
            ?.keyMetricCreditAccountDetails.length ??
        0;
  }

  List<KeyMetricCreditAccountDetails> getKeyMetricsAccountDetails() {
    return (creditReport.keyMetricInfos[selectedCreditInfoType]
            ?.keyMetricCreditAccountDetails) ??
        [];
  }

  _checkPollingStatus(CreditReportResponseModel creditReportResponse) async {
    creditReportStatus = creditReportResponse.status;
    creditScoreModel.updateApplicationDetails(creditReportResponse);
    switch (creditReportResponse.status) {
      case CreditReportStatus.INITIATED:
        // keep polling
        break;
      case CreditReportStatus.COMPLETED:
        if (creditReportResponse.creditReport == null) {
          _onExperianPollingFailure();
          break;
        }
        creditReport = creditReportResponse.creditReport!;
        _onCreditReportFetchSuccess();
        break;
      case CreditReportStatus.FAILED:
        _onExperianPollingFailure();
        break;
    }
  }

  _onExperianPollingFailure() {
    currentCreditReportState = CreditReportState.failure;
    stopExperianPolling();
  }

  bool computeKnowMoreCTAEnabled() {
    return !isConsentRequired || isConsentChecked;
  }

  _onCreditReportFetchSuccess() {
    stopExperianPolling();
    _computeCreditScoreScaleInfo(creditReport.score);
    creditOverviewLength = min(4, creditReport.accounts.length);

    if (!creditScoreModel.applicationDetails.dataPageViewed || _isRefresh) {
      currentCreditReportState = CreditReportState.success;
    } else {
      currentCreditReportState = CreditReportState.dashboard;
      getCreditScorePoint();
    }

    AppAuthProvider.setCreditScore(creditReport.score.toString());
    logCreditScoreRefreshAvailable(
        isRefreshAvailable: creditScoreModel.refreshAvailable, isHome: false);
    _isRefresh = creditScoreModel.refreshAvailable;
  }

  bool get showSeeMore => creditReport.accounts.length > 4;

  onSeeMoreClicked() {
    if (isShowingMore) {
      creditOverviewLength = 4;
      isShowingMore = false;
    } else {
      creditOverviewLength = creditReport.accounts.length;
      isShowingMore = true;
    }
  }

  onSuccessContinue() {
    currentCreditReportState = CreditReportState.dashboard;
    getCreditScorePoint();
    logCreditScore5KeyLoaded();
    logCreditScoreSuccessViewDetailsClicked();
    logCreditScoreReportHomeNextUpdateiLoaded(
        creditScoreModel.applicationDetails.nextScoreUpdateDays);
  }

  onCreditInfoTap(CreditInfoType creditInfoType) {
    selectedCreditInfoType = creditInfoType;
    logCreditScore5KeyClicked(creditInfoType.indexValue);
    currentCreditReportState = CreditReportState.keyMetricView;
    logCreditScore5KeyMetricPageLoaded(creditInfoType.indexValue,
        creditReport.keyMetricInfos[creditInfoType]?.isAnyValueNA ?? false);
  }

  onCreditScoreInfoClicked() {
    logCreditScoreReportHomeScoreiClicked();
    Get.bottomSheet(CreditScoreScaleInfoBottomSheet());
  }

  onCreditOverviewTapped(CreditAccount creditAccount) {
    this.creditAccount = creditAccount;
    logEventsOnLoanClicked(creditAccount, currentCreditReportState);
    startYear = creditAccount.paymentHistoryStartDate.year;
    lastYear = creditAccount.paymentHistoryEndDate.year;
    currSelectedYear = lastYear;
    currentCreditReportState = CreditReportState.accountDetails;
  }

  onCreditAccountTapped(int? accountSerialNumber) {
    if (accountSerialNumber == null) return;
    CreditAccount? creditAccount =
        creditReport.creditAccountMap[accountSerialNumber];
    if (creditAccount != null) {
      onCreditOverviewTapped(creditAccount);
    }
  }

  onPollingClosePressed() {
    _pollingService.stopPolling();
    onBackClicked();
  }

  stopExperianPolling() {
    _pollingService.stopPolling();
  }

  startExperianPolling() {
    _startPolling();
  }

  _startPolling() {
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

  @override
  void onClose() {
    _pollingService.stopPolling();
    phoneController.dispose();
    pinPutController.dispose();
    getPinPutFocus.dispose();
    super.onClose();
  }

  onTryAgainClicked() {
    logCreditScoreFailureTryAgainClicked();
    if (creditReportStatus != null &&
        creditReportStatus == CreditReportStatus.FAILED) {
      initiateCreditReportPull(additionalBody: {
        "pullType": creditScoreModel.applicationDetails.reportS3url.isEmpty
            ? FRESH_PULL
            : REFRESH_PULL,
      });
    } else {
      _goToCreditPolling();
    }
  }

  _goToCreditPolling({String code = ""}) async {
    currentCreditReportState = CreditReportState.polling;
    switch (code) {
      case MASKED_NUMBER_FLOW:
        fetchAndShowMaskedMobileBottomSheet(
            creditScoreModel: creditScoreModel,
            currentCreditReportState: currentCreditReportState);
        break;
      case UNABLE_TO_PROCEED:
        _unableToProceed();
        break;
      default:
        _startPolling();
    }
  }

  Future<bool> onBackClicked({bool isExpiredConsent = false}) async {
    if (isExpiredConsent) logCreditScoreIntroExpiredConsentClosed();
    logCreditScoreBackClicked(currentCreditReportState);
    switch (currentCreditReportState) {
      case CreditReportState.knowMore:
        if (_isCreditScoreFeedbackGiven) {
          Get.back();
        } else {
          _openFeedbackBottomSheet();
        }
        break;
      case CreditReportState.accountDetails:
        currentCreditReportState = _previousCreditReportState;
        break;
      case CreditReportState.creditOverview:
        // reset loan chip selection
        _creditOverviewAccountType = CreditAccountType.loan;
        // reset scroll position
        _resetScrollPosition(creditOverviewScrollController);
        currentCreditReportState = CreditReportState.dashboard;
        break;
      case CreditReportState.keyMetricView:
        currentCreditReportState = CreditReportState.dashboard;
        // reset scroll position
        _resetScrollPosition(keyMetricScrollController);
        break;
      case CreditReportState.dashboard:
        await onDashboardBackClicked();
        Get.back();
        break;
      default:
        Get.back();
    }
    return false;
  }

  _openFeedbackBottomSheet() async {
    logCSIntroFeedbackLoaded();
    await Get.bottomSheet(
      CreditScoreFeedbackBottomSheet(),
      isDismissible: false,
      isScrollControlled: true,
    );
    logCSIntroFeedbackClosed();
    Get.back();
  }

  _resetScrollPosition(ScrollController scrollController) {
    try {
      scrollController.jumpTo(0);
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Future<bool> onDashboardBackClicked() async {
    try {
      await AppFunctions().showInAppReview(playStorePromptedCreditScore);
    } catch (e) {
      Get.log("Error while in app review in credit score $e");
    }
    return true;
  }

  CreditScoreScale _computeCreditScoreScaleInfo(int score) {
    for (var scale in CreditScoreScale.values) {
      if (score >= scale.minScore && score <= scale.maxScore) {
        creditScoreScale = scale;
        creditScoreScaleCarousalController = PageController(
          initialPage: CreditScoreScale.values.indexOf(scale),
        );
        return scale;
      }
    }
    return CreditScoreScale.poor;
  }

  void onNextScoreUpdateClicked() {
    logCreditScoreReportHomeNextUpdateiClicked();
    logCreditScoreReportHomeNextUpdateLoaded(
        creditScoreModel.applicationDetails.nextUpdateAvailableFormat);
    Get.bottomSheet(UpdateInfoBottomSheet());
  }

  void onViewAllTapped() {
    currentCreditReportState = CreditReportState.creditOverview;
    logCreditScoreReportHomeViewAllClicked();
  }

  onCreditAccountChipTapped(CreditAccountType creditAccountType) {
    creditOverviewAccountType = creditAccountType;
  }

  @override
  void onInit() async {
    var arguments = Get.arguments;
    creditScoreModel = arguments['creditScoreModel'];
    isReferralEnabled = arguments['isReferralEnabled'] ?? false;
    if (!creditScoreModel.applicationDetails.dataPageViewed) {
      await computeAndFetchAbTesting(
          expName: CREDITSCORE_EXP_NAME,
          onSuccess: _onAbTestingFetchSuccess,
          onFailure: _onAbTestingFetchFailed);
      final bool isAppFormIdEmpty =
          creditScoreModel.applicationDetails.appFormId.isEmpty;
      currentCreditReportState = (isAppFormIdEmpty &&
              creditScoreModel.applicationDetails.pullStatus != "COMPLETED")
          ? CreditReportState.statelessKnowMore
          : CreditReportState.knowMore;
      if (isAppFormIdEmpty) {
        logCreditScoreD2CWhitelistFormLoaded();
      }
    } else {
      _goToCreditPolling();
    }
    super.onInit();
  }

  _checkFeedbackStatus() async {
    _isCreditScoreFeedbackGiven =
        await AppAuthProvider.isCreditScoreFeedbackGiven;
  }

  onKnowMoreContinue(
      {bool isFromBottomSheet = false, bool isExpiredConsent = false}) {
    if (isFromBottomSheet) Get.back();
    // TODO: have scope to refactor
    if (isExpiredConsent) logCreditScoreIntroExpiredConsentAccepted();
    if (!isExpiredConsent)logEventsOnKnowMoreCta(isConsentRequired);
    if (!isConsentRequired && creditScoreModel.isFreshPullDone) {
      _goToCreditPolling();
      return;
    }
    Map<String, dynamic> additionalBody = {
      "pullType": creditScoreModel.isFreshPullDone ? REFRESH_PULL : FRESH_PULL,
      "dataPageViewed": true,
    };
    if (isConsentRequired && (isConsentChecked || isStatelessConsentChecked)) {
      additionalBody["consent"] = true;
    }

    initiateCreditReportPull(additionalBody: additionalBody);
  }

  initiateCreditReportPull(
      {Map additionalBody = const {}, String unMaskedNumber = ""}) async {
    isButtonLoading = true;
    currentCreditReportState = CreditReportState.polling;
    Map body = {
      "appFormId": creditScoreModel.applicationDetails.appFormId,
      "applicantId": creditScoreModel.applicationDetails.applicantId,
      if (unMaskedNumber.isNotEmpty) "unMaskedPhoneNumber": unMaskedNumber
    };
    body.addAll(additionalBody);
    CreditScoreRequestModel creditScoreData =
        await creditReportRepository.initiatePullCreditScore(body: body);
    switch (creditScoreData.apiResponse.state) {
      case ResponseState.success:
        isButtonLoading = false;
        _goToCreditPolling(code: creditScoreData.code);
        break;
      default:
        currentCreditReportState = CreditReportState.failure;
        var apiResponse = creditScoreData.apiResponse;
        logErrorFromApi(apiResponse);
    }
  }

  onRefreshCreditScorePressed() async {
    _isRefresh = true;
    logCreditScoreRefreshClicked();
    currentCreditReportState = CreditReportState.polling;
    bool? showConsentScreen = await checkConsent();
    if (showConsentScreen != null && showConsentScreen) {
      _showRefreshConsent();
    } else {
      await _onConsentNoExpired();
    }
  }

  Future<void> _onConsentNoExpired() async {
    if (creditScoreModel.applicationDetails.appFormId.isEmpty &&
        creditScoreModel.applicationDetails.pullStatus == "COMPLETED") {
      _fetchCreditReportWithPhoneNumber();
    } else {
      await initiateCreditReportPull(
          additionalBody: {"pullType": REFRESH_PULL});
    }
  }

  void _showRefreshConsent() {
    isConsentRequired = true;
    logCreditScoreIntroExpiredConsentLoaded();
    Get.bottomSheet(
      CreditScoreConsentModalSheet(
        isRefreshFlow: true,
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<bool?> checkConsent({bool isFromRefreshPull = false}) async {
    ExperianConsentStatus? consentStatus = await checkConsentStatus();

    switch (consentStatus) {
      case ExperianConsentStatus.absent:
        isConsentRequired = true;
        logCreditScoreIntroConsentLoaded();
        return true;
      case ExperianConsentStatus.active:
        break;
      case ExperianConsentStatus.expired:
        if (isFromRefreshPull) {
          await initiateCreditReportPull(
              additionalBody: {"pullType": REFRESH_PULL});
        }
        isConsentRequired = true;
        return true;
      case null:
        currentCreditReportState = CreditReportState.failure;
      ///Mixin handles the api error logging

      ///Mixin handles the api error logging
    }
    _checkFeedbackStatus();
    return null;
  }

  void onCreditScoreScalePageChanged(int value) {
    update([PAGE_INDICATOR_ID]);
  }

  List<CreditAccount> fetchAccounts({
    bool fetchClosedLoans = false,
  }) {
    return creditReport.accounts.where((account) {
      // Filter by account type index
      if (creditOverviewAccountType == CreditAccountType.creditCard) {
        return account.isCreditCard &&
            (account.isLoanClosed ==
                fetchClosedLoans); // Only credit card accounts
      }
      if (creditOverviewAccountType == CreditAccountType.loan) {
        return !account.isCreditCard &&
            account.isLoanClosed == fetchClosedLoans;
      }

      // If no creditAccountTypeIndex, apply fetchClosedLoans for all loans
      if (fetchClosedLoans) {
        return account.isLoanClosed; // Closed loans (default case)
      } else {
        return !account.isLoanClosed; // Active loans (default case)
      }
    }).toList();
  }

  onFeedbackSubmitClicked() {
    logCSIntroFeedbackSubmitted(
        selectedFeedbackOption, feedbackController.text);
    creditReportFeedbackState = CreditReportFeedbackState.thankYou;
    AppAuthProvider.setCreditScoreFeedbackGiven();
  }

  onConsentValueChanged(bool? val) {
    if (val != null) {
      isConsentChecked = val;
    }
  }

  @override
  Widget get consentWidget => CreditScoreConsentWidget(
        onConsentChanged: onConsentValueChanged,
      );

  @override
  String get knowMoreAppBarTitle => "Credit Score";

  @override
  String? get knowMoreBackground => Res.creditScoreKnowMoreV2;

  @override
  Widget get knowMoreBody => const SizedBox.shrink();

  @override
  Widget get knowMoreButton => GetBuilder<CreditReportLogic>(
        id: BUTTON_ID,
        builder: (logic) {
          return Button(
            buttonType: ButtonType.primary,
            buttonSize: ButtonSize.large,
            enabled: logic.computeKnowMoreCTAEnabled(),
            onPressed: logic.onKnowMoreContinue,
            title: logic.isConsentRequired ? "Accept & Continue" : "Continue",
            isLoading: logic.isButtonLoading,
          );
        },
      );

  @override
  FAQModel? get knowMoreFaqModel => null;

  @override
  String get knowMoreIllustration => Res.creditScoreKnowMore;

  @override
  String get knowMoreMessage => "";

  @override
  String get knowMoreTitle => "";

  @override
  Widget get poweredByWidget => const PoweredByExperian();

  @override
  void onKnowMoreBackPressed() {
    onBackClicked();
  }

  @override
  Widget? get backButton => null;

  @override
  Widget? get closeButton => const SizedBox.shrink();

  @override
  void onClosePressed() {}

  BoxDecoration _buildDecoration({Color? borderColor}) {
    return BoxDecoration(
      color: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(4),
      border:
          borderColor != null ? Border.all(color: borderColor, width: 2) : null,
    );
  }

  void mobileTextField(String number) {
    if (number.length > 9) {
      _updateMobileNumberSelection(
          validateMaskedMobileNumber(number, maskedValue: selectedValue));
    } else {
      isMobileNumberSelected = false;
      update([BOTTOM_SHEET_CONTINUE_CTA]);
    }
  }

  void _updateMobileNumberSelection(String? validationResult) {
    final isMatch =
        isPhoneMatchingMaskedValue(selectedValue, phoneController.text);
    isMobileNumberSelected = isMatch && isFieldValid(validationResult);
    update([RADIO_BUTTON_ID, MASKED_TEXT_FIELD, BOTTOM_SHEET_CONTINUE_CTA]);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update([BOTTOM_SHEET_CONTINUE_CTA]);
  }

  Future<void> toGetOTP({bool reSet = false}) async {
    isLoading = true;
    Map<String, dynamic> body = {
      "phoneNumber": phoneController.text,
      "identifier": "ExperianMaskedMobile"
    };
    MaskedOTPResponseModel model =
        await creditReportRepository.fetchOtp(body: body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        logCreditScoreMaskedFlowOTPTriggered();
        isLoading = false;
        if (!reSet) {
          otpBottomCTA();
        }
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: MASKED_OTP_SCREEN,
          retry: () => toGetOTP(reSet: reSet),
        );
    }
  }

  Future<void> _toVerifyOTP(
      {required Function(bool) pinSet,
      required Function(String errorText) onError,
      bool reSet = false,
      Function? onSuccess}) async {
    isLoading = true;
    Map<String, dynamic> body = {
      "phoneNumber": phoneController.text,
      "identifier": "ExperianMaskedMobile",
      "otp": pinPutController.text
    };
    MaskedOTPResponseModel model =
        await creditReportRepository.verifyOtp(body: body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        onError("");
        pinSet(true);
        logCreditScoreMaskedFlowOTPVerifiedSuccess();
        initiateCreditReportPull(additionalBody: {
          "pullType": creditScoreModel.applicationDetails.reportS3url.isEmpty
              ? FRESH_PULL
              : REFRESH_PULL,
          "consent": true
        }, unMaskedNumber: phoneController.text);
        isLoading = false;
        if (onSuccess != null) onSuccess();
        break;
      case ResponseState.badRequestError:
        _computeErrorMessage(model, onError);
        logCreditScoreMaskedFlow400Error(error: model.message);
        break;
      default:
        isLoading = false;
        handleAPIError(
          model.apiResponse,
          screenName: MASKED_OTP_SCREEN,
          retry: _toVerifyOTP,
        );
    }
  }

  void _computeErrorMessage(
      MaskedOTPResponseModel model, Function(String errorText) onError) {
    switch (model.message) {
      case "OTP expired":
        onError("OTP expired. Please resend OTP");
        break;
      case "Invalid OTP":
        onError("Incorrect OTP. Please try again.");
        break;
      default:
        onError("Incorrect OTP. Please try again.");
        break;
    }
  }

  void otpBottomCTA() {
    Get.back();
    Get.bottomSheet(
        BottomSheetWidget(
          onCloseClicked: () async {
            Get.back();
            _openMaskedMobileBottomSheet();
          },
          child: PopScope(
            canPop: false,
            child: BottomSheetOTPWidget(
                bottomSheetOTPHandler: this,
                headerType: OTPHeaderType.maskedOtp),
          ),
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false);
  }

  @override
  String mobileNumber() => selectedValue;

  @override
  void onEditClick() {
    Get.back();
    pinPutController.clear();
    otpErrorText = "";
    _openMaskedMobileBottomSheet();
  }

  @override
  bool resendLoading() => isResendLoading;

  @override
  Future<void> resetOtp({bool reSet = false}) async {
    Get.focusScope?.unfocus();

    await AppSnackBar.successBar(
      title: "An OTP has been sent to your Mobile Number",
      message: phoneController.text,
    );

    isResendLoading = true;
    toGetOTP(reSet: true);
    isResendLoading = false;
  }

  String onMaskedNumberChange(
      int index, String? val, MaskedMobileResponseModel model) {
    selectedValue = val ?? "";
    model.maskedMobileNumbers[index] = selectedValue;
    update();
    return selectedValue;
  }

  @override
  FocusNode get getPinPutFocus => pinPutFocusNode;

  late List<String> maskedMobileNumbers;

  Future<void> fetchAndShowMaskedMobileBottomSheet({
    required CreditScoreModel creditScoreModel,
    required CreditReportState currentCreditReportState,
  }) async {
    currentCreditReportState = CreditReportState.polling;
    Map body = {
      "appFormId": creditScoreModel.applicationDetails.appFormId,
      "applicantId": creditScoreModel.applicationDetails.applicantId,
      "pullType": FRESH_PULL
    };
    MaskedMobileResponseModel maskedMobileResponseModel =
        await creditReportRepository.experianD2CMaskedMobileCall(body: body);
    switch (maskedMobileResponseModel.apiResponse.state) {
      case ResponseState.success:
        maskedMobileNumbers = maskedMobileResponseModel.maskedMobileNumbers;
        await _openMaskedMobileBottomSheet();
        break;
      default:
        var apiResponse = maskedMobileResponseModel.apiResponse;
        logErrorFromApi(apiResponse);
        ;
    }
  }

  Future<void> _openMaskedMobileBottomSheet() async {
    isLoading = false;
    logCreditScoreMaskedFlowLoaded();
    await Get.bottomSheet(CreditScoreMobileBottomSheet(),
        isScrollControlled: true, isDismissible: false, enableDrag: false);
  }

  @override
  Future<void> onConfirmPinSubmitted({
    required Function updateToLoading,
    required Function(String errorText) onError,
    required String otp,
    required Function(bool) pinSet,
    required Function onShowVerified,
  }) async {
    pinPutController.text = otp;

    if (otp.isEmpty) {
      _markOtpError("Enter OTP", pinSet);
      return;
    }

    selectedFieldDecoration = pinPutDecoration;
    update([OTP_PINPUT]);

    if (otp.length > 5) {
      pinPutFocusNode.unfocus();
      pinSet(true);
      updateToLoading();
      await _toVerifyOTP(
          pinSet: pinSet,
          onError: onError,
          onSuccess: () async {
            onShowVerified();
            await Future.delayed(const Duration(seconds: 2));
            Get.back();
          });
    } else {
      onError("");
      pinSet(false);
    }
  }

  void _markOtpError(String errorText, Function(bool) pinSet) {
    selectedFieldDecoration = errorPinPutDecoration;
    update([OTP_PINPUT]);
    pinSet(false);
  }

  Future<void> numberNotFoundClicked() async {
    Get.back();
    logCreditScoreMaskedFlowNumberNotFoundClicked();
    await _unableToProceed();
  }

  Future<void> _unableToProceed() async {
    Get.bottomSheet(const CreditScoreRedirectBottomSheet(),
        isDismissible: false);
    logCreditScoreMaskedFlowNumberNotFoundRedirected();
    await Future.delayed(const Duration(seconds: 5));
    Get.back(); // close bottom sheet
    Get.back(); //
  }

  maskedBackClicked() {
    logCreditScoreMaskedFlowScreenClosed();
    switch (group) {
      case KNOW_MORE_V2:
        Get.back();
        Get.back();
        break;
      default:
        Get.back();
        break;
    }
  }

  void logErrorFromApi(ApiResponse apiResponse) {
    logError(
      statusCode: apiResponse.statusCode.toString(),
      responseBody: apiResponse.apiResponse,
      requestBody: apiResponse.requestBody,
      exception: apiResponse.exception,
      url: apiResponse.url,
    );
  }

  void _onAbTestingFetchSuccess(String assignedGroup) async {
    group = assignedGroup;
    bool? showConsent = await checkConsent();
    // if(showConsent != null){
    //   currentCreditReportState = CreditReportState.knowMore;
    // }
  }

  void _onAbTestingFetchFailed(response) async {
    bool? showConsent = await checkConsent();
    // if(showConsent != null){
    //   currentCreditReportState = CreditReportState.knowMore;
    // }
  }

  Widget computeKnowMoreScreen() {
    switch (group) {
      case KNOW_MORE_V1:
        return _knowMoreV1Widget();
      case KNOW_MORE_V2:
        isConsentRequired = true;
        return CreditScoreKnowMoreV2Widget(knowMoreHelper: this);
    }
    return _knowMoreV1Widget();
  }

  Widget _knowMoreV1Widget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isConsentRequired = true;
      Get.bottomSheet(
        CreditScoreConsentModalSheet(),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    });
    return const Column(
      children: [
        Expanded(
          child: PollingScreen(
            isV2: true,
            isClosedEnable: false,
            assetImagePath: Res.creditScoreInProgress,
            titleLines: ["Track your Credit Score"],
            bodyTexts: [
              "Monitor your financial health with ease,without affecting your score"
            ],
            progressIndicatorText: "This usually takes about 30 seconds",
          ),
        ),
        VerticalSpacer(16),
        PoweredByWidget(
          logo: Res.experianLogo,
        ),
        VerticalSpacer(36),
      ],
    );
  }

  validateCoApplicantForm() {
    coApplicantButtonEnabled =
        isFieldValid(nameValidator(fullNameController.text.trim())) &&
            isFieldValid(panValidator(panController.text.trim())) &&
            isFieldValid(emailValidator(emailController.text.trim())) &&
            isStatelessConsentChecked;
    update([STATELESS_BUTTON_ID]);
  }

  computeOnTryAgainClicked() {
    creditScoreModel.applicationDetails.appFormId.isEmpty
        ? creditScoreModel.applicationDetails.pullStatus != "COMPLETED"
            ? fetchStatelessCreditReport()
            : _fetchCreditReportWithPhoneNumber()
        : onTryAgainClicked();
  }

  void logEventOnAcceptAndContinue() {
    logCreditScoreD2CWhitelistFormSubmitted();
  }

  void onReferralCardTapped() {
    Get.toNamed(Routes.REFERRAL);
  }

  getCreditScorePoint() async {
    isCreditScorePointLoading = true;
    CreditScoreLineGraphModel _model =
        await creditReportRepository.getCreditScoreHistory();
    switch (_model.apiResponse.state) {
      case ResponseState.success:
        creditScoreLineGraphModel = _model;
        creditScoreUpdate = creditScoreLineGraphModel.creditScoreUpdate;
        isCreditScorePointLoading = false;
        update([SCORE_POINT_WIDGET]);
        break;
      default:
        handleAPIError(
          _model.apiResponse,
          screenName: CREDIT_SCORE_HISTORY,
          retry: getCreditScorePoint,
        );
    }
  }

  //remainder is equal to 0, which means the original value had no decimal part
  String formatScoreForYAxis(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }

  void onTapViewDetails() {
    currentCreditReportState= CreditReportState.dashboard;
    Get.bottomSheet(CreditLineGraphBottomSheet());
    logCreditScoreGraphDetailsLoaded();
  }

  void logEventOnTapCreditHomeGraphTile() {
    if (creditScoreLineGraphModel.scoreDifference == 0) {
      logCreditScoreGraphClicked("no_change");
    }
    else {
      logCreditScoreGraphClicked(creditScoreLineGraphModel.scoreDifference > 0
          ? "increase"
          : "decrease");
    }
  }

   showCreditScoreHistory(CreditReportLogic logic) {
    if (logic.isCreditScorePointLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logic.creditScoreLineGraphModel.creditScoreHistory.length < 2) {
      return const SizedBox.shrink();
    }
  }

  bool get hasValidGraphData {
    return creditScoreLineGraphModel.creditScoreHistory.isNotEmpty &&
       creditScoreLineGraphModel.isMonthPresentInSixMonth;
  }
}
