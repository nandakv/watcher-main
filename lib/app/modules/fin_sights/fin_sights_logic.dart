import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/data/repository/finsights_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/offer_upgrade_repository.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/offer_upgrade/perfios_bank_statement_model.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/feedback/widgets/success_dialog.dart';
import 'package:privo/app/modules/fin_sights/finsights_analytics.dart';
import 'package:privo/app/modules/fin_sights/finsights_carousel_mixin.dart';
import 'package:privo/app/modules/fin_sights/spending_insights/spending_snap_shot_model.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_exit_dialog.dart';
import 'package:privo/app/components/mobile_number_bottom_sheet/mobile_number_bottom_sheet.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_failure_bottom_sheet.dart';
import 'package:privo/app/modules/fin_sights/widgets/new_intro/finsights_intro_model.dart';
import 'package:privo/app/modules/fin_sights/widgets/know_more_body_widget.dart';
import 'package:privo/app/modules/know_more_and_get_started/helper/know_more_helper_mixin.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_helper.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/res.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../common_widgets/forms/base_field_validator.dart';
import '../../common_widgets/java_script_web_event_channel.dart';
import '../../common_widgets/web_view_close_alert_dialog.dart';
import '../../data/provider/auth_provider.dart';
import '../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../mixin/app_analytics_mixin.dart';
import '../../models/check_app_form_model.dart';
import '../../models/finsights/finsights_overview_model.dart';
import '../../models/finsights/finsights_view_model.dart';
import '../../models/offer_upgrade/aa_consent_model.dart';
import '../../models/offer_upgrade/bank_report_initiate_model.dart';
import '../../models/offer_upgrade/bank_report_polling_model.dart';
import '../../models/sequence_engine_model.dart';
import '../../models/supported_banks_model.dart';
import '../../services/polling_service.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/error_logger_mixin.dart';
import '../ab_user/ab_testing_mixin.dart';
import '../authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../non_eligible_finsights/non_eligible_finsights_carousal_model.dart';
import '../on_boarding/mixins/on_boarding_mixin.dart';
import 'finsights_argument.dart';
import 'package:carousel_slider/carousel_controller.dart' as carouselSlider;

import 'widgets/finsights_feedback_dialog.dart';

enum FinSightState {
  loading,
  introScreen,
  knowMore,
  bankDetails,
  aaWebView,
  polling,
  pollingFailure,
  dashboardLoading,
  dashboard,
  mobileInputScreen,
  newIntroScreen,
  waitScreen
}

enum TransactionState { success, badRequest }
enum BankFlowState { bankNameFlow, mobileNumberFlow }

enum TopTranscationType {
  sent(title: "Debited"),
  received(title: "Credited");

  final String title;

  const TopTranscationType({
    required this.title,
  });
}

class FinSightsLogic extends GetxController
    with
        KnowMoreHelperMixin,
        ApiErrorMixin,
        ErrorLoggerMixin,
        AppAnalyticsMixin,
        FinsightsAnalytics,
        FinSightsCarouselMixin,
        AbTestingMixin,
        SignInFieldValidator,
        BaseFieldValidators
    implements KnowMoreHelper, WebEventHandler {
  final String FINSIGHTS_DASHBOARD_SCREEN = "FINSIGHTS_DASHBOARD_SCREEN";
  final String FINSIGHTS_AA = "FINSIGHTS_AA";
  late Map<String, double> currentChartData = {};
  String _showMonths = "Last 3 months";
  final SNAP_SHOT_PAGE_INDICATOR = "SNAP_SHOT_PAGE_INDICATOR";
  final OVER_ALL_SPENDING = "OVER_ALL_SPENDING";
  final PIE_CHART = "PIE_CHART";
  final SHOW_MONTHS = "SHOW_MONTHS";
  final SPENDING_INSIGHTS_SCREEN = "SPENDING_INSIGHTS_SCREEN";
  final String TRANSACTION_LIST_KEY = "TRANSACTION_LIST_KEY";
  final String GET_STARTED_CTA_ID = "GET_STARTED_CTA_ID";
  final MOBILE_NUMBER_CTA_ID = "MOBILE_NUMBER_CTA_ID";
  final String BANK_DETAILS_WIDGET_KEY = "BANK_DETAILS_WIDGET_KEY";
  final String MASKWIDGET_KEY = "MASKWIDGET_KEY";
  final String HIDE_INFORMATION_WIDGET_KEY = "HIDE_INFORMATION_WIDGET_KEY";
  final String YOUR_FINANCE_WIDGET_KEY = "YOUR_FINANCE_WIDGET_KEY";
  final String MONTH_ID = "month_id";
  final INTRO_SCREEN_ID = "INTRO_SCREEN_ID";
  final REFRESH_ERROR_KEY = "REFRESH_ERROR_KEY";
  final String MOBILE_NUMBER_CTA = 'MOBILE_NUMBER_CTA';
  final String MOBILE_NUMBER_TEXT_FIELD = 'MOBILE_NUMBER_TEXT_FIELD';
  final String MOBILE_FLOW = 'MOBILE_FLOW';
  String REMOVE_BANK_EXP_NAME = "finsight_bank_remove_flow";

  late MonthlyAmount highestSpend;
  late MonthlyAmount lowestSpend;
  late HighestCategory highestCategory;
  late EodSummary eodSummary;
  late double totalDebitAmount;
  late double averageTotalDebitAmount;
  late BankReportPollingModel bankReportPollingModel;
  Map<String, Map<String, double>> chartDataMap = {};
  late String assignedGroup;
  late String totalDebitAmountLast6Months;

  late FinsightsOverviewModel overviewModel;
  late FinSightsViewModel finSightsViewModel;

  String accountOverviewMonths = "";
  final String maskedText = "******";

  String accountId = "";

  DateFormat monthYearDateFormat = DateFormat("MMM ''yy");
  DateFormat dropDownDateFormat = DateFormat("MMMM yyyy");

  List<SpendingSnapShotModel> carouselSlides = [];
  List<Transaction> filteredList = [];
  List<MonthAmount> selectedCreditAmountList = [];
  List<MonthAmount> selectedDebitAmountList = [];
  List<String> selectMonthList = ['Last 3 months', "Last 6 months"];
  final _pollingService = PollingService();
  String perfiosInitiateHTMLSnippet = "";
  String perfiosWebViewCallBackURL = "https://privo.in?txnId=%s&status=%s";

  TransactionState transactionState = TransactionState.success;
  BankFlowState bankFlowState = BankFlowState.bankNameFlow;
  final mobileNumberController = TextEditingController();

  final _finsightsRepository = FinsightsRepository();
  final _offerUpgradeRepository = OfferUpgradeRepository();

  final spendingSnapShotPageController =
      carouselSlider.CarouselSliderController();

  late JavaScriptWebEventChannel javaScriptWebEventChannel;

  _initWebViewChannel() {
    javaScriptWebEventChannel =
        JavaScriptWebEventChannel(webEventHandler: this);
  }

  void eventListenerCallBack(List<dynamic> args) {
    try {
      Map<String, dynamic> data = json.decode(args[0].toString());
      String event = data['event'] ?? '';
      String eventMessage = data['eventMessage'] ?? '';
      String eventCode = data['eventCode'] ?? '';
      logWebEvents(eventCode, eventMessage);
      javaScriptWebEventChannel.handleWebEvent(eventCode, eventMessage);
    } catch (e) {
      Get.log("Error parsing event data: $e");
    }
  }

  final List<String> introScreenFeedbackOptions = [
    "I don't want to track my finances",
    "I already track my finances",
    "I don't think this is useful for me",
    "I am not sure what this is about",
    "Others",
  ];

  final List<String> bankSelectionFeedbackOptions = [
    "I am unable to find my bank",
    "I don't think it's secure",
    "I don’t know which bank to select",
    "I am not comfortable to share my bank details",
    "Others",
  ];

  int _selectedOptionIndex = -1; //to ensure no item is selected when user is seeing list for first time

  int get selectedOptionIndex => _selectedOptionIndex;

  set selectedOptionIndex(int value) {
    _selectedOptionIndex = value;
    update();
  }

  bool _showTextField = false;

  bool get showTextField => _showTextField;

  set showTextField(bool value) {
    _showTextField = value;
    update();
  }

  final TextEditingController otherFeedbackController = TextEditingController();

  bool get isSubmitEnabled => _selectedOptionIndex != -1;

  void onOptionSelected(int? index) {
    if (index != null) {
      selectedOptionIndex = index;
      showTextField = finSightState == FinSightState.bankDetails
          ? bankSelectionFeedbackOptions[index] == "Others"
          : introScreenFeedbackOptions[index] == "Others";
    }
  }

  void submitFeedback() async {
    if (!isSubmitEnabled) return;

    String feedback;
    if (showTextField) {
      feedback = otherFeedbackController.text;
      finSightState == FinSightState.bankDetails
          ? logFeedbackBackClickedBankSelection(feedback)
          : logFeedbackBackClickedIntro(feedback);
    } else {
      feedback = _computeFeedbackOption(selectedOptionIndex);
    }
    Get.log("User submitted feedback: $feedback");

    Get.back();
    await Get.bottomSheet(const SuccessDialog(
      body:
          "We appreciate your input! Every suggestion helps us create a better experience for you.",
    ));
    Get.back();
  }

  _computeFeedbackOption(int index) {
    switch (finSightState) {
      case FinSightState.introScreen:
        logFeedbackBackClickedIntro(introScreenFeedbackOptions[index]);
        return introScreenFeedbackOptions[index];
      case FinSightState.bankDetails:
        logFeedbackBackClickedBankSelection(
            bankSelectionFeedbackOptions[index]);
        return bankSelectionFeedbackOptions[index];
    }
  }

  FinSightState _finSightState = FinSightState.loading;

  FinSightState _finSightPreviousState = FinSightState.loading;

  FinSightState get finSightState => _finSightState;

  set finSightState(FinSightState value) {
    _finSightState = value;
    _onFinsightsStateChanged();
    update();
  }

  bool isConsentApproved = false;

  bool _canDashboardPop = false;

  bool get canDashboardPop => _canDashboardPop;

  set canDashboardPop(bool value) {
    _canDashboardPop = value;
    update();
  }

  int _introScreenIndex = 0;

  int get introScreenIndex => _introScreenIndex;

  set introScreenIndex(int value) {
    _introScreenIndex = value;
    update([INTRO_SCREEN_ID]);
  }

  bool _getStartedCTALoading = false;

  bool get getStartedCTALoading => _getStartedCTALoading;

  set getStartedCTALoading(bool value) {
    _getStartedCTALoading = value;
    update([GET_STARTED_CTA_ID]);
  }

  bool _isMobileNumberCTAEnabled = true;

  bool get isMobileNumberCTAEnabled => _isMobileNumberCTAEnabled;

  set isMobileNumberCTAEnabled(bool value) {
    _isMobileNumberCTAEnabled = value;
    update([MOBILE_NUMBER_CTA_ID, MOBILE_NUMBER_CTA]);
  }

  bool _initiatingWebview = false;

  bool get initiatingWebview => _initiatingWebview;

  set initiatingWebview(bool value) {
    _initiatingWebview = value;
    update([BANK_DETAILS_WIDGET_KEY, MOBILE_FLOW]);
  }

  String get showMonths => _showMonths;

  set showMonths(String value) {
    _showMonths = value;
    currentChartData = chartDataMap[showMonths] ?? {};
    computeChartData();
    if (finSightsViewModel.threeMonths != null)
      _computeTotalAverageDebitAmount();
    update([SHOW_MONTHS, PIE_CHART, OVER_ALL_SPENDING]);
  }

  bool _isPageLoading = false;

  get isPageLoading => _isPageLoading;

  set isPageLoading(value) {
    _isPageLoading = value;
    update(['spending_snap_card', REFRESH_ERROR_KEY]);
  }

  bool _showData = false;

  bool get showData => _showData;

  set showData(bool value) {
    _showData = value;
    Get.log("showData - $showData");
    update([MASKWIDGET_KEY]);
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update([SNAP_SHOT_PAGE_INDICATOR]);
  }

  bool _showHideInformationWidget = true;

  bool get showHideInformationWidget => _showHideInformationWidget;

  set showHideInformationWidget(bool value) {
    _showHideInformationWidget = value;
    update([HIDE_INFORMATION_WIDGET_KEY]);
  }

  bool _last3MonthsSelected = true;

  bool get last3MonthsSelected => _last3MonthsSelected;

  set last3MonthsSelected(bool value) {
    _last3MonthsSelected = value;
    update([YOUR_FINANCE_WIDGET_KEY]);
  }

  int? _touchedBarGroupIndex;

  int? get touchedBarGroupIndex => _touchedBarGroupIndex;

  set touchedBarGroupIndex(int? value) {
    _touchedBarGroupIndex = value;
    update([YOUR_FINANCE_WIDGET_KEY]);
  }

  TopTranscationType _currentTopTransactionPillType = TopTranscationType.sent;

  TopTranscationType get currentTopTransactionPillType =>
      _currentTopTransactionPillType;

  set currentTopTransactionPillType(TopTranscationType value) {
    _currentTopTransactionPillType = value;
    if (finSightsViewModel.filterByMonthTransfers.isNotEmpty ||
        finSightsViewModel.filterByMonthReceived.isNotEmpty) {
      filterTransactionListByMonth();
    }
    update([MONTH_ID, TRANSACTION_LIST_KEY]);
  }

  @override
  String get knowMoreAppBarTitle =>
      _finSightPreviousState == FinSightState.dashboard
          ? "About FinSights"
          : "FinSights";


  ///pie chart sphere colors
  final pieChartColorList = [
    blue1600, // darkest
    blue1500,
    blue1300,
    blue1100,
    blue1000,
    blue900,
    blue800,
    blue700,
    blue600,
    blue500,
    blue400,
    blue300, //lightest
  ];

  late List<DateTime> nextSixMonths;

  List<DateTime> getSixTransactionMonths() {
    if (finSightsViewModel.topFundsTransferred.isEmpty) {
      return [];
    }
    int monthsToTake = finSightsViewModel.topFundsTransferred.length;
    if (monthsToTake > 6) {
      monthsToTake = 6;
    }
    nextSixMonths = List.generate(
      monthsToTake,
      (index) => finSightsViewModel.topFundsTransferred[index].monthYear!,
    );
    return nextSixMonths;
  }

  List<DateTime> getSixTransactionReceivedMonths() {
    if (finSightsViewModel.topFundsReceived.isEmpty) {
      return [];
    }
    int monthsToTake = finSightsViewModel.topFundsReceived.length;
    if (monthsToTake > 6) {
      monthsToTake = 6;
    }
    nextSixMonths = List.generate(
      monthsToTake,
      (index) => finSightsViewModel.topFundsReceived[index].monthYear!,
    );
    return nextSixMonths;
  }

  @override
  Widget get knowMoreBody => const KnowMoreBodyWidget();

  @override
  Widget get knowMoreButton => _finSightPreviousState == FinSightState.dashboard
      ? const SizedBox()
      : GetBuilder<FinSightsLogic>(
          id: GET_STARTED_CTA_ID,
          builder: (logic) {
            return GradientButton(
              isLoading: getStartedCTALoading,
              onPressed: onTapGetStarted,
              title: "Get Started",
            );
          },
        );

  @override
  FAQModel? get knowMoreFaqModel => finSightsFaq;

  @override
  String get knowMoreIllustration => Res.finsightsKnowMore;

  @override
  String get knowMoreMessage => "Money managed easily and securely";

  @override
  String get knowMoreTitle => "Finances, Simplified & Safe";

  @override
  String? get knowMoreBackground => null;

  @override
  Widget get consentWidget => const SizedBox();

  @override
  Widget get poweredByWidget => const SizedBox();

  @override
  void onKnowMoreBackPressed() {
    Get.back();
  }

  @override
  Widget? get backButton => _finSightPreviousState == FinSightState.dashboard
      ? const SizedBox(
          width: 32,
        )
      : null;

  @override
  Widget? get closeButton => _finSightPreviousState == FinSightState.dashboard
      ? null
      : const SizedBox.shrink();

  @override
  void onClosePressed() {
    finSightState = FinSightState.dashboard;
  }

  FinsightsArgument argument = Get.arguments;

  WebViewControllerPlus webViewControllerPlus = WebViewControllerPlus();

  void onAfterLayout() async {
    mobileNumberController.text = await AppAuthProvider.phoneNumber;
    _computeState();
    _initWebViewChannel();
  }

  _computeState() {
    final String finSightsModelTag = argument.finSightsModel.tag;

    switch (finSightsModelTag) {
      case "New Update":
        finSightState = FinSightState.newIntroScreen;
        return;
      case "Incomplete":
      case "New":
        finSightState = FinSightState.introScreen;
        return;
      case "":
        _computePollingStatus();
    }
  }

  void _computePollingStatus() {
    accountId = argument.finSightsModel.applicationDetails.accountId;
    switch (argument.finSightsModel.applicationDetails.pullStatus) {
      case "PENDING":
        finSightState = FinSightState.introScreen;
        return;
      case "DATA_FETCH_FAILURE":
        finSightState = FinSightState.waitScreen;
        _startBankReportPolling();
        return;
      default:
        finSightState = FinSightState.dashboardLoading;
        return;
    }
  }

  _navigateOnContinueClicked() async {
    FinsightsApplicationDetails applicationDetails =
        argument.finSightsModel.applicationDetails;
    switch (applicationDetails.pullStatus) {
      case "PENDING":
        accountId = applicationDetails.accountId;
        if (await AppAuthProvider.finsightsShowPolling) {
          await _showPollingScreen();
        } else {
          _showWaitScreen();
        }
        break;

      case "SUCCESS":
        finSightState = FinSightState.dashboardLoading;
        break;

      default:
        loadAbTest(expName: REMOVE_BANK_EXP_NAME);
        break;
    }
  }

  void _showWaitScreen() {
    finSightState = FinSightState.waitScreen;
    _startBankReportPolling();
  }

  Future<void> _showPollingScreen() async {
    finSightState = FinSightState.polling;
    await Future.delayed(const Duration(seconds: 10));

    if (bankReportPollingModel.status == "PENDING" ||
        bankReportPollingModel.status == "DATA_FETCH_FAILURE") {
      finSightState = FinSightState.waitScreen;
    }
  }

  void _onFinsightsStateChanged() async {
    switch (finSightState) {
      case FinSightState.introScreen:
        logFinsightsInfoPageLoaded("home_page");

        ///for the first time data should be unhidden
        showData = true;
        break;
      case FinSightState.knowMore:
        logFinsightsInfoPageLoaded("info_button");
        break;
      case FinSightState.bankDetails:
        logFinsightsBankSelectionLoaded();
        break;
      case FinSightState.aaWebView:
        break;
      case FinSightState.polling:
        logFinsightsLoadingInsightsScreen();

        ///for the first time data should be unhidden
        showData = true;
        _startBankReportPolling();
        break;
      case FinSightState.dashboardLoading:
        logFinsightsDataPageLoading();
        await getFinSightsOverview();
        break;
      case FinSightState.dashboard:
        logFinsightsDataLoaded();
        logFinsightsDataShowOption(showData);
        //  if (filteredList.isEmpty) logFinsightsGraphNoTransactions();   // will uncomment this if required in future
        break;
      case FinSightState.pollingFailure:
        logFinsightsAAFailedPage();
        break;
      case FinSightState.mobileInputScreen:
        logFinsightsMobileNumberInputLoaded();
        break;
      case FinSightState.loading:
        break;
    }
  }

  void _computeSelectedAmountList() {
    if (overviewModel.months.length == 6) {
      _selectLast3MonthsAmountList();
    } else {
      _selectLast6MonthsAmountList();
    }
  }

  void _selectLast3MonthsAmountList() {
    selectedCreditAmountList =
        overviewModel.creditTransactionPerMonthList.sublist(3, 6);
    selectedDebitAmountList =
        overviewModel.debitTransactionPerMonthList.sublist(3, 6);
  }

  Future _selectLast6MonthsAmountList() async {
    selectedCreditAmountList = overviewModel.creditTransactionPerMonthList;
    selectedDebitAmountList = overviewModel.debitTransactionPerMonthList;
  }

  _hideInformationLabelWidget() async {
    await Future.delayed(const Duration(seconds: 3));
    showHideInformationWidget = false;
  }

  void toggleDataVisibility() {
    showData = !showData;
    logFinsightsDataShowOption(showData);
  }

  String monthYearFormat(DateTime dateTime) {
    return DateFormat("MMM ‘yy").format(dateTime);
  }

  void onTapLast3Months() {
    logFinsightsDataYourFinances(3);
    if (!last3MonthsSelected) {
      _selectLast3MonthsAmountList();
      last3MonthsSelected = true;
    }
  }

  void onTapLast6Months() async {
    logFinsightsDataYourFinances(6);
    if (last3MonthsSelected) {
      await _selectLast6MonthsAmountList();
      last3MonthsSelected = false;
    }
  }

  int computeGraphLength() {
    if (overviewModel.months.length == 6) {
      return last3MonthsSelected ? 3 : 6;
    }
    return overviewModel.months.length;
  }

  String formatAmountForYAxis(double value) {
    String formatWithPrecision(double number) {
      return number % 1 == 0
          ? number.toStringAsFixed(0)
          : number.toStringAsFixed(1);
    }

    if (value >= 1e7) {
      // Convert to Crores
      return "${formatWithPrecision(value / 1e7)}Cr";
    } else if (value >= 1e5) {
      // Convert to Lakhs
      return "${formatWithPrecision(value / 1e5)}L";
    } else if (value >= 1e3) {
      // Convert to Thousands
      return "${formatWithPrecision(value / 1e3)}K";
    } else {
      // Return as is for smaller values
      return formatWithPrecision(value);
    }
  }

  void openMobileNumberBottomSheet(BanksModel banksModel) async {
    var result = await Get.bottomSheet(
      MobileNumberBottomSheet(
        flowType: "finsights",
      ),
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
    );
    if (result != null) {
      _initiateAASDK(result, banksModel: banksModel);
    }
  }

  onMobileScreenCTAClicked() {
    logFinsightsMobileNumberInputContinueClicked();
    bankFlowState = BankFlowState.mobileNumberFlow;
    _initiateAASDK(mobileNumberController.text);
  }

  void _initiateAASDK(String mobileNumber, {BanksModel? banksModel}) async {
    initiatingWebview = true;
    Map<String, dynamic> body = _computeBodyUsingAbTesting(banksModel, mobileNumber);

    BankReportInitiateModel model =
        await _offerUpgradeRepository.initiateBankReport(body, true,isFinsights: true);

    initiatingWebview = false;

    switch (model.apiResponse.state) {
      case ResponseState.success:
        accountId = model.reportId;
        _openAAWebView(mobileNumber, model as AAConsentModel);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          retry: () => _initiateAASDK(mobileNumber, banksModel: banksModel),
          screenName: FINSIGHTS_DASHBOARD_SCREEN,
        );
    }
  }

  Map<String, dynamic> _computeBodyUsingAbTesting(BanksModel? banksModel, String mobileNumber) {
    Map<String, dynamic> body = {
      "method": 'accountAggregator',
      "returnUrl": perfiosWebViewCallBackURL,
      "mobileNumber": mobileNumber,
      "vendor": "pirimid",
      "source": "finSights",
      "flow": "event"
    };

    // Only add these fields if the flow is 'bankNameFlow'
    if (bankFlowState == BankFlowState.bankNameFlow) {
      body.addAll({
        "bankName": banksModel?.perfiosBankName ?? "",
        "institutionId": banksModel?.perfiosInstitutionId ?? "",
        "fipIds": [banksModel?.pirimidBankId ?? ""],
      });
    }
    return body;
  }


  late String responseURL;
  List<String> _aaConsentIdList = [];
  String _phoneNumber = "";

  Future<void> _openAAWebView(
      String? mobileNumber, AAConsentModel model) async {
    String phoneNumber = mobileNumber ?? await AppAuthProvider.phoneNumber;
    _aaConsentIdList = model.consentId;
    _phoneNumber = phoneNumber;
    responseURL = model.responseURL;
    _toggleWebView(enableWebView: true);
  }

  _toggleWebView({required bool enableWebView}) {
    if (enableWebView) {
      finSightState = FinSightState.aaWebView;
    } else {
      computeBankFlowVariant(assignedGroup: assignedGroup);
    }
  }

  Future<bool> onWebViewBackPressed() async {
    var result = await Get.dialog(
      const WebViewCloseAlertDialog(),
    );
    if (result != null && result) {
      computeBankFlowVariant(assignedGroup: assignedGroup);
    }
    return false;
  }

  void onPerfiosWebViewCreated() {
    webViewControllerPlus
      ..loadHtmlString(perfiosInitiateHTMLSnippet)
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            onPerfiosWebViewCallbackTriggered(url);
          },
        ),
      );
  }

  void onPerfiosWebViewCallbackTriggered(String url) {
    Get.log("onPerfiosWebViewCallbackTriggered - $url");
    try {
      String perfiosBaseURL =
          AppFunctions().getBaseUrlFromString(perfiosWebViewCallBackURL);
      String callBackBaseURL = AppFunctions().getBaseUrlFromString(url);
      if (callBackBaseURL == perfiosBaseURL) {
        _computePerfiosStatus(url);
      }
    } catch (e) {
      Get.log("onPerfiosWebViewCallbackTriggered exception - ${e.toString()}");
    }
  }

  _computePerfiosStatus(String url) {
    if (_checkPerfiosStatusSuccess(url)) {
      onWebViewRedirectAsSuccess();
    } else {
      finSightState = FinSightState.polling;
    }
  }

  bool _checkPerfiosStatusSuccess(String urlString) {
    Uri uri = Uri.parse(urlString);
    return (uri.queryParameters['status'] ?? "").toLowerCase() == "true";
  }

  onWebViewRedirectAsSuccess() async {
    isConsentApproved = true;
    finSightState = FinSightState.polling;
    await Future.delayed(const Duration(seconds: 10));
    if (bankReportPollingModel.status == "PENDING" ||
        bankReportPollingModel.status == "DATA_FETCH_FAILURE") {
      finSightState = FinSightState.waitScreen;
      await AppAuthProvider.setFinsightsShowPolling(showPolling: false);
    }
  }

  _startBankReportPolling() {
    _pollingService.initAndStartPolling(
      pollOnStart: true,
      pollingInterval: 5,
      pollingFunction: () async {
        bankReportPollingModel =
            await _offerUpgradeRepository.bankReportPolling(accountId,isFinsights: true);
        switch (bankReportPollingModel.apiResponse.state) {
          case ResponseState.success:
            accountId = bankReportPollingModel.reportId;
            if (bankReportPollingModel.isCompleted) {
              _onBankReportPollingCompleted(bankReportPollingModel);
            }
            break;
          default:
            _pollingService.stopPolling();
            handleAPIError(
              bankReportPollingModel.apiResponse,
              screenName: FINSIGHTS_DASHBOARD_SCREEN,
              retry: _startBankReportPolling,
            );
        }
      },
    );
  }

  void _onBankReportPollingCompleted(BankReportPollingModel model) {
    _pollingService.stopPolling();
    switch (model.status) {
      case "SUCCESS":
        finSightState = FinSightState.dashboardLoading;
        break;
      case "FAILURE":
        finSightState = FinSightState.pollingFailure;
        break;
      case "DATA_FETCH_FAILURE":
        finSightState = FinSightState.waitScreen;
        break;
      default:
        finSightState = FinSightState.pollingFailure;
        break;
    }
  }

  onFailureRetryClicked() {
    computeBankFlowVariant(assignedGroup: assignedGroup);
  }

  @override
  void onClose() {
    _pollingService.stopPolling();
    super.onClose();
  }

  onTopBarInfoPressed() {
    _finSightPreviousState = FinSightState.dashboard;
    finSightState = FinSightState.knowMore;
  }

  void onTapClosingBalanceInfo() {
    logFinsightsDataClosingBalanceInfoClicked();
    Get.bottomSheet(
      BottomSheetWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Closing Balance").headingSMedium(
              color: appBarTitleColor,
            ),
            const VerticalSpacer(12),
            Text.rich(
              TextSpan(
                  text:
                      "Closing balance is the amount of money left in your account at the end of a specific period, like at the end of the day or month\n\n",
                  style: const TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 17 / 12,
                  ),
                  children: [
                    TextSpan(
                        text:
                            "Last updated: ${DateFormat("dd MMMM, yyyy").format(finSightsViewModel.closingBalanceDate)}",
                        style: const TextStyle(
                          color: darkBlueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 17 / 12,
                        ))
                  ]),
            ),
            const VerticalSpacer(16),
          ],
        ),
      ),
    );
  }

  onTapGetStarted() async {
    logFinsightsGetStartedClicked();
    showTextField = false;
    if (argument.finSightsModel.applicationDetails.dataPageViewed) {
      _navigateOnContinueClicked();
      return;
    }

    getStartedCTALoading = true;

    Map<String, dynamic> body = {
      "finSights": {
        "dataPageViewed": true,
      },
    };

    ApiResponse apiResponse =
        await _finsightsRepository.updateUserTracking(body: body);

    switch (apiResponse.state) {
      case ResponseState.success:
        getStartedCTALoading = true;
        _navigateOnContinueClicked();
        break;
      default:
        handleAPIError(
          apiResponse,
          screenName: FINSIGHTS_DASHBOARD_SCREEN,
          retry: onTapGetStarted,
        );
    }
  }

  onBankSelected(String bankName) {
    logFinsightsBankSelected();
  }

  onDashboardBackPressed() async {
    finSightsBackClicked("Finsights dashboard screen");
    try {
      await AppFunctions().showInAppReview(playStorePromptedFinsights);
    } catch (e) {
      Get.log("Exception while showing in app review - ${e.toString()}");
    } finally {
      canDashboardPop = true;
      Get.back();
    }
  }

  finSightsBackClicked(String pageName, {bool addFriction = false}) async {
    logBackButtonClicked(pageName);
    if (addFriction) {
      await Get.bottomSheet(
          FinsightsExitBottomSheet(
            title:
                "We are sorry that you don't want to continue exploring FinSights",
            selectionFeedbackOptions: introScreenFeedbackOptions,
          ),
          isDismissible: false,
          isScrollControlled: true);
    } else {
      Get.back();
    }
  }

  onFinSightsIntroScreenPopped() async {
    await Get.bottomSheet(
        FinsightsExitBottomSheet(
          title:
              "We are sorry that you don't want to continue exploring FinSights",
          selectionFeedbackOptions: introScreenFeedbackOptions,
        ),
        isDismissible: false,
        isScrollControlled: true);
    return false;
  }

  String computeIntroScreenCTAText() {
    return argument.finSightsModel.applicationDetails.dataPageViewed
        ? "Continue"
        : "Unlock insights";
  }

  late DateTime _selectedMonth;

  DateTime get selectedMonth => _selectedMonth;

  set selectedMonth(DateTime value) {
    _selectedMonth = value;
    filterTransactionListByMonth();
    update([MONTH_ID, TRANSACTION_LIST_KEY]);
  }

  bool _showLessData = true;

  bool get showLessData => _showLessData;

  set showLessData(bool value) {
    _showLessData = value;
    update([PIE_CHART]);
  }

  void computeChartData() {
    final Map<String, double> last3MonthsAnalysis =
    finSightsViewModel.categoryWiseLastThreeMonthsDebitAmount;
    final Map<String, double> last6MonthsAnalysis =
        finSightsViewModel.categoryWiseLastSixMonthsDebitAmount;
    chartDataMap = {
      'Last 3 months': last3MonthsAnalysis,
      'Last 6 months': last6MonthsAnalysis,
    };
  }

  void onCarouselPageChange(int index) {
    currentIndex = index;
  }

  getFinSightsOverview() async {
    isPageLoading = true;
    FinSightsViewModel model =
        await _finsightsRepository.getFinSightsOverView();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _onSuccess(model);
        break;
      default:
        _onApiFailed(model.apiResponse, "overview");
    }
  }

  String getMonthName(int year, int monthNumber) {
    final date = DateTime(year, monthNumber);
    return DateFormat.MMMM().format(date);
  }

  void _onSuccess(FinSightsViewModel model) {
    finSightsViewModel = model;
    overviewModel = finSightsViewModel.overviewModel;
    transactionState = TransactionState.success;

    if (finSightsViewModel.sixMonths != null) {
      totalDebitAmountLast6Months =
          finSightsViewModel.sixMonths!.totalDebitAmountLast6Months.toString();
      highestSpend = finSightsViewModel.sixMonths!.highestSpend!;
      lowestSpend = finSightsViewModel.sixMonths!.lowestSpend!;
      highestCategory = finSightsViewModel.sixMonths!.highestCatgeory!;
      if (totalDebitAmountLast6Months != "0.0") {
        _showCarouselList();
      }
    }

    if (finSightsViewModel.topFundsTransferred.isNotEmpty) {
      selectedMonth = getSixTransactionMonths().last;
    } else {
      selectedMonth = getSixTransactionReceivedMonths().last;
    }
    computeChartData();
    showMonths = "Last 3 months";
    update([SHOW_MONTHS, PIE_CHART, OVER_ALL_SPENDING]);
    _computeSelectedAmountList();
    isPageLoading = false;
    update(['spending_snap_card']);
    accountOverviewMonths = overviewModel.months.isNotEmpty
        ? "(${monthYearFormat(overviewModel.months.first)} - ${monthYearFormat(overviewModel.months.last)})"
        : "";
    //    _computeSelectedAmountList();
    finSightState = FinSightState.dashboard;
    _hideInformationLabelWidget();
  }

  void _showCarouselList() {
    carouselSlides = [
      SpendingSnapShotModel(
        img: Res.smartphone,
        title: AppFunctions.getIOFOAmount(double.parse(finSightsViewModel
            .sixMonths!.totalDebitAmountLast6Months
            .toString())),
        subTitle: RichText(
          text: TextSpan(
            style: AppTextStyles.bodySRegular(color: grey700),
            // Default style for the entire text
            children: <TextSpan>[
              TextSpan(
                  text: 'Spent in the ',
                  style: AppTextStyles.bodySRegular(color: grey700)),
              TextSpan(
                  text: 'last 6 months',
                  style: AppTextStyles.bodySSemiBold(color: grey700)),
              TextSpan(
                  text:
                      ' over ${finSightsViewModel.sixMonths!.totalDebitTxnLast6Months} transactions',
                  style: AppTextStyles.bodySRegular(color: grey700)),
            ],
          ),
        ),
      ),
      SpendingSnapShotModel(
          img: Res.spendingCalender,
          title: AppFunctions.getIOFOAmount(
              double.parse(highestSpend.amount.toString())),
          subTitle: RichText(
            // Use a subTitleWidget instead of subTitle string
            text: TextSpan(
              style: AppTextStyles.bodySRegular(color: grey700),
              children: <TextSpan>[
                TextSpan(
                    text: 'Highest spending was in ',
                    style: AppTextStyles.bodySRegular(color: grey700)),
                TextSpan(
                    text: highestSpend.fullMonth,
                    style: AppTextStyles.bodySSemiBold(color: grey700)),
              ],
            ),
          )),
      SpendingSnapShotModel(
          img: Res.spendingShopping,
          title: finSightsViewModel.sixMonths!.highestCatgeory!.category,
          subTitle: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySRegular(color: grey700),
              children: <TextSpan>[
                TextSpan(
                    text: 'Most money was spent on this ',
                    style: AppTextStyles.bodySRegular(color: grey700)),
                TextSpan(
                    text: 'category',
                    style: AppTextStyles.bodySSemiBold(color: grey700)),
              ],
            ),
          )),
    ];
  }


  void _computeTotalAverageDebitAmount() {
    if (showMonths == "Last 3 months") {
      totalDebitAmount =
          finSightsViewModel.threeMonths!.totalDebitAmountLast3Months!;
      averageTotalDebitAmount =
          finSightsViewModel.threeMonths!.totalDebitAmountLast3Months! / 3;
    } else {
      totalDebitAmount =
          finSightsViewModel.sixMonths!.totalDebitAmountLast6Months!;
      averageTotalDebitAmount =
          finSightsViewModel.sixMonths!.totalDebitAmountLast6Months! / 6;
    }
  }

  radioMonthWidget() async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: 'Filter',
        titleTextStyle: AppTextStyles.headingMedium(color: navyBlueColor),
        radioValues: selectMonthList,
        initialValue: showMonths,
        isCloseIconEnabled: true,
        childPadding: EdgeInsets.only(
          top: 0.h,
          left: 32.w,
          right: 32.w,
          bottom: 32.h,
        ),
      ),
      isDismissible: true,
      enableDrag: false,
    );

    if (result != null) {
      showMonths = result;
      update();
    }
  }

  filterTransactionListByMonth() {
    switch (currentTopTransactionPillType) {
      case TopTranscationType.sent:
        filteredList =
            finSightsViewModel.filterByMonthTransfers[selectedMonth] ?? [];
        break;
      case TopTranscationType.received:
        filteredList =
            finSightsViewModel.filterByMonthReceived[selectedMonth] ?? [];
        break;
    }
  }

  void sendReceiveOnTap(TopTranscationType topTranscationType) {
    currentTopTransactionPillType = topTranscationType;
  }

  String transactionListMonthYear(DateTime date) {
    String formattedDate = monthYearDateFormat.format(date);
    return formattedDate;
  }

  radioWidget() async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: 'Select a month',
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkBlueColor,
          height: 28 / 20,
        ),
        radioValues: nextSixMonths.reversed.map((dateTime) {
          return DateFormat('MMMM yyyy').format(dateTime);
        }).toList(),
        initialValue: dropDowndateText(),
        isCloseIconEnabled: true,
        childPadding: const EdgeInsets.only(
          top: 0,
          left: 32,
          right: 32,
          bottom: 32,
        ),
      ),
      isDismissible: true,
      enableDrag: false,
    );

    if (result != null) {
      selectedMonth = dropDownDateFormat.parse(result);
    }
  }

  String dropDowndateText() {
    String formattedDate = dropDownDateFormat.format(selectedMonth);
    return formattedDate;
  }

  late Map<String, String> categoryIcons = {
    'CASH Withdrawals': Res.category,
    'Credit Card Payment': Res.creditcardPayment,
    'EMIs': Res.emi_icon,
    'Rent': Res.cottage,
    'Shopping': Res.shoppingIconFinsights,
    'Transfer out': Res.transferTo,
    'Transfer in': Res.transfer_from,
    'Transportation': Res.local_taxi,
    'Utilities': Res.utility,
    'Loans': Res.utility,
    'Food': Res.lunch_dining,
    'Travel': Res.luggage,
    'Hotel': Res.bed,
    'Entertainment': Res.entertainment,
    'Investment': Res.investment,
    'Health Care': Res.cardiology,
    'Personal Care': Res.spa,
    'Education': Res.dictionary,
    'Others': Res.category,
  };

  String getCategorySvgPath(String categoryName) {
    final lowerCaseCategory = categoryName.toLowerCase();

    for (final entry in categoryIcons.entries) {
      if (lowerCaseCategory.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return getCategorySvgPath("Others");
  }

  String showSpendingPercentage(String categoryName) {
    final Map<String, double> percentageMap = showMonths == "Last 3 months"
        ? finSightsViewModel.categoryWiseLastThreeMonthsDebitPercentage
        : finSightsViewModel.categoryWiseLastSixMonthsDebitPercentage;

    final double percentage = percentageMap[categoryName] ?? 0.0;
    return '${percentage.toStringAsFixed(2)}%';
  }

  /// FinSightsIntroModel is a model with img and title
  List<FinSightsIntroModel> newIntroList = [
    FinSightsIntroModel(
        img: Res.ignosis_search,
        title: 'Spot spending trends with Spend Analyser'),
    FinSightsIntroModel(
        img: Res.electric_bolt, title: 'Faster data syncs from your bank'),
    FinSightsIntroModel(
        img: Res.finance, title: 'Insights with in-depth data analysis'),
  ];

  @override
  void handleWebViewFailure() {
    finSightState = FinSightState.polling;
  }

  @override
  void handleWebViewNotPending() {
    _toggleWebView(enableWebView: false);
    Fluttertoast.showToast(msg: "Please try again in sometime");
  }

  @override
  void onWebViewConsentApproved() {
    onWebViewRedirectAsSuccess();
  }

  @override
  void onWebViewConsentApprovedFailed() {
    finSightState = FinSightState.polling;
  }

  @override
  void onWebViewConsentRejected() {
    finSightState = FinSightState.polling;
  }

  @override
  void onWebViewConsentRejectedFailed() {
    finSightState = FinSightState.polling;
  }

  @override
  void onWebViewJourneyClosed() {
    onWebViewBackPressed();
  }

  @override
  void onWebviewNoAccountFoundJourneyClosed() {
    _toggleWebView(enableWebView: false);
  }

  _onApiFailed(ApiResponse apiResponse, String endpoint) async {
    logFinsightsDataPageLoadingError(endpoint);
    logErrorWithApiResponse(apiResponse);

    var result = await Get.bottomSheet(
      FinsightsFailureBottomSheet(),
      isDismissible: false,
    );

    if (result == null) return;

    if (result) {
      getFinSightsOverview();
      return;
    }

    Get.back();
  }

  Map<String, String> categoryData = {
    "EMIs":
        "Paying EMIs on time boosts your credit score. Set reminders to never miss a due date!",
    "Credit Card Payment":
        "Great job clearing your credit card bill! Paying in full saves you from interest charges.",
    "Transport":
        "Transport costs are climbing? Explore carpooling or public transport options to save more.",
    "Travel":
        "Travel expenses are up this month. Planning trips in advance can reduce last-minute costs.",
    "Utilities":
        "Utility bills consistent? Great! Sudden spikes may indicate leaks or extra usage.",
    "Investments":
        "Good going on your investments! Diversifying can lower risks and improve returns.",
  };

  Future<bool> onPopped() async {
    switch (finSightState) {
      case FinSightState.introScreen:
        await Get.bottomSheet(
            FinsightsExitBottomSheet(
              title:
                  "We are sorry that you don't want to continue exploring FinSights",
              selectionFeedbackOptions: introScreenFeedbackOptions,
            ),
            isDismissible: false,
            isScrollControlled: true);
        return false;
      case FinSightState.bankDetails:
        await Get.bottomSheet(
            FinsightsExitBottomSheet(
              title: "Are you sure you don’t want to track your accounts? ",
              selectionFeedbackOptions: bankSelectionFeedbackOptions,
            ),
            isDismissible: false,
            isScrollControlled: true);
        return false;
      default:
        return true;
    }
  }

  void loadAbTest({required String expName}) {
    getStartedCTALoading = true;
    computeAndFetchAbTesting(
      expName: expName,
      onSuccess: (assignedGroup) {
        assignedGroup = assignedGroup;
        getStartedCTALoading = false;
        computeBankFlowVariant(assignedGroup: assignedGroup);
      },
      onFailure: (response) {
        handleAPIError(
          response,
          screenName: "BANK_FLOW",
          retry: loadAbTest,
        );
      },
    );
  }

  void computeBankFlowVariant({String assignedGroup = ""}) {
    switch (assignedGroup) {
      case "intro_screen_2":
        finSightState = FinSightState.mobileInputScreen;
        break;
      default:
        finSightState = FinSightState.bankDetails;
        break;
    }
    update();
  }

  void onMobileNumberChanged() {
    isMobileNumberCTAEnabled =
        isFieldValid(validateMobileNumber(mobileNumberController.text));
    update([MOBILE_NUMBER_CTA, MOBILE_NUMBER_TEXT_FIELD]);
  }

  onPollingBackPress() async {
    if (isConsentApproved) {
      Fluttertoast.showToast(msg: "Please wait for sometime");
    } else {
      finSightsBackClicked("Finsights Polling screen");
    }
  }
}
