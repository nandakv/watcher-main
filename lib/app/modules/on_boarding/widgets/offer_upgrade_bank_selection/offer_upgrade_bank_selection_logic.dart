import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/common_widgets/blue_border_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/offer_upgrade/aa_consent_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_initiate_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_polling_model.dart';
import 'package:privo/app/models/offer_upgrade/perfios_bank_statement_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import 'package:privo/app/modules/fin_sights/finsights_carousel_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_analytics.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/widgets/add_second_bank_alert_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/widgets/sbd_bank_consent_bottom_sheet.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/widgets/select_bank_bottom_sheet.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../common_widgets/web_view_close_alert_dialog.dart';
import '../../../../components/mobile_number_bottom_sheet/mobile_number_bottom_sheet.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../data/repository/feedback_repository.dart';
import '../../../../data/repository/on_boarding_repository/offer_upgrade_repository.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/app_form_rejection_model.dart';
import '../../../../models/supported_banks_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/polling_service.dart';
import '../../../../utils/apps_flyer_constants.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../search_screen/search_screen_logic.dart';

import 'offer_upgrade_bank_selection_navigation.dart';
import 'offer_upgrade_bank_selection_view.dart';
import 'widgets/mobile_edit_bottom_sheet_widget.dart';

enum OfferUpgradePageState { loading, bankList, polling, webView, failure }

enum BankStatementUploadOption {
  aa(type: "accountAggregator"),
  netBanking(type: "netbanking"),
  uploadPDF(type: "statement");

  final String type;

  const BankStatementUploadOption({required this.type});
}

enum SBDAddedBankState {
  zeroBankAdded,
  oneBankAdded,
  twoBanksAdded,
  threeBanksAdded,
}

class OfferUpgradeBankSelectionLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        OfferUpgradeBankSelectionAnalytics,
        BaseFieldValidators,
        SignInFieldValidator,
        FinSightsCarouselMixin {
  TextEditingController selectedBankController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  final String BANK_SELECTION_WIDGET_ID = "BANK_SELECTION_WIDGET_ID";
  final String FO_APPROVED_UPGRADE_SCREEN = "FO_APPROVED_UPGRADE_SCREEN";

  BankStatementUploadOption _bankStatementUploadOption =
      BankStatementUploadOption.aa;

  BankStatementUploadOption get selectedBankStatementUploadOption =>
      _bankStatementUploadOption;

  set selectedBankStatementUploadOption(BankStatementUploadOption value) {
    _bankStatementUploadOption = value;
    update([BANK_SELECTION_WIDGET_ID]);
  }

  BankStatementUploadCombination? bankStatementUploadCombination;

  ///callback values we get from aa sdk
  static const int _USER_APPROVED_CALLBACK = 0;
  static const int _USER_CANCEL_CALLBACK = 1;
  static const int _MOBILE_NUMBER_EDIT_CALLBACK = 2;
  static const int _BANK_EDIT_CALLBACK = 3;
  static const int _CANCEL_CONSENT_CALLBACK = 4;

  ///webview callbacks
  static const String NO_ACCOUNTS_FOUND = "NO_ACCOUNTS_FOUND";
  static const String CONSENT_APPROVED_SUCCESS = "CONSENT_APPROVED_SUCCESS";
  static const String CONSENT_REJECTED_SUCCESS = "CONSENT_REJECTED_SUCCESS";
  static const String IFRAME_FAILED = "IFRAME_FAILED";
  static const String CONSENT_NOT_IN_PENDING_STATE =
      "CONSENT_NOT_IN_PENDING_STATE";
  static const String MOBILE_NUMBER_EDIT_REQUEST = "MOBILE_NUMBER_EDIT_REQUEST";
  static const String BANK_EDIT_REQUEST = "BANK_EDIT_REQUEST";
  static const String AAJOURNEY_CLOSED = "AAJOURNEY_CLOSED";
  static const String TNC_CLICKED = "TNC_CLICKED";
  final String CONSENT_CTA_ID = "CONSENT_CTA_ID";

  final bankValidationKey = GlobalKey<FormState>();

  final _offerUpgradeRepository = OfferUpgradeRepository();

  final String CONTINUE_BUTTON_ID = "CONTINUE_BUTTON_ID";
  final String BANK_TEXT_FIELD_ID = "BANK_TEXT_FIELD_ID";
  final String MOBILE_TEXT_FIELD_ID = 'MOBILE_TEXT_FIELD_ID';
  final String MOBILE_BUTTON_ID = 'MOBILE_BUTTON_ID';
  final String MOBILE_CHECK_BOX_ID = 'MOBILE_CHECK_BOX_ID';
  final String MOBILE_CONTINUE_BUTTON_ID = 'MOBILE_CONTINUE_BUTTON_ID';

  final String OFFER_UPGRADE_BANK_DETIALS = "aa_bank_details";
  final String ACTION_TYPE_INITIATE = "initiate";
  final String ACTION_TYPE_OPT_OUT = "opt_out";

  String perfiosInitiateHTMLSnippet = "";

  String perfiosWebViewCallBackURL = "https://privo.in?txnId=%s&status=%s";

  List<String> _aaConsentIdList = [];

  String _phoneNumber = "";

  List<BanksModel> banks = [];

  late BanksModel _selectedBank;

  late SequenceEngineModel sequenceEngineModel;

  late BankReportPollingModel bankReportPollingModel;

  OnBoardingOfferUpgradeBankSelectionNavigation?
      onBoardingAABankSelectionNavigation;

  final double SALARIED_INDEX = 6.0;

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([CONTINUE_BUTTON_ID]);
  }

  bool _isButtonEnable = true;

  bool get isButtonEnable => _isButtonEnable;

  set isButtonEnable(bool value) {
    _isButtonEnable = value;
    update([MOBILE_TEXT_FIELD_ID, MOBILE_CONTINUE_BUTTON_ID]);
  }

  bool isUserSalaried = false;

  bool showUpgradeOfferInfoScreen = false;

  OfferUpgradePageState _offerUpgradePageState = OfferUpgradePageState.loading;

  OfferUpgradePageState get offerUpgradePageState => _offerUpgradePageState;

  set offerUpgradePageState(OfferUpgradePageState value) {
    _offerUpgradePageState = value;
    bool showAppBar;
    bool isBackDisabled;

    switch (value) {
      case OfferUpgradePageState.loading:
        showAppBar = true;
        isBackDisabled = true;
        break;
      case OfferUpgradePageState.bankList:
        showAppBar = true;
        isBackDisabled = false;
        break;
      case OfferUpgradePageState.polling:
      case OfferUpgradePageState.webView:
      case OfferUpgradePageState.failure:
        showAppBar = false;
        isBackDisabled = false;
        break;
    }

    _toggleAppBarVisibility(showAppBar: showAppBar);
    onBoardingAABankSelectionNavigation?.toggleBack(
        isBackDisabled: isBackDisabled);

    update();
  }

  String? _bankTextFieldError;

  String? get bankTextFieldError => _bankTextFieldError;

  set bankTextFieldError(String? value) {
    _bankTextFieldError = value;
    update([BANK_TEXT_FIELD_ID]);
  }

  set setNumber(String value) {
    mobileErrorText = null;
    isNumber = value.length == 10;
    isButtonEnable = isNumber &&
        isFieldValid(validateMobileNumber(mobileNumberController.text));
    update([MOBILE_TEXT_FIELD_ID, MOBILE_CONTINUE_BUTTON_ID]);
  }

  ///This variable is set to true when the text entered by user is a valid number
  ///and to enable the continue button
  bool _isNumber = false;

  bool get isNumber => _isNumber;

  set isNumber(bool value) {
    _isNumber = value;
    update([MOBILE_BUTTON_ID, MOBILE_TEXT_FIELD_ID, MOBILE_CONTINUE_BUTTON_ID]);
    _checkButtonEnable();
  }

  String? _mobileErrorText;

  String? get mobileErrorText => _mobileErrorText;

  set mobileErrorText(String? errorText) {
    _mobileErrorText = errorText;
    update([MOBILE_TEXT_FIELD_ID, MOBILE_CONTINUE_BUTTON_ID]);
  }

  bool _isMobileButtonEnabled = false;

  bool get isMobileButtonEnabled => _isMobileButtonEnabled;

  set isMobileButtonEnabled(bool value) {
    _isMobileButtonEnabled = value;
    update([MOBILE_BUTTON_ID]);
  }

  bool _mobileConsentCheckBoxValue = false;

  bool get mobileConsentCheckBoxValue => _mobileConsentCheckBoxValue;

  set mobileConsentCheckBoxValue(bool value) {
    _mobileConsentCheckBoxValue = value;
    update([MOBILE_CHECK_BOX_ID, MOBILE_BUTTON_ID]);
    _checkButtonEnable();
  }

  bool _consentCTALoading = false;

  bool get consentCTALoading => _consentCTALoading;

  set consentCTALoading(bool value) {
    _consentCTALoading = value;
    update([CONSENT_CTA_ID]);
  }


  bool isUploadPDFCallbackTriggered = false;

  final _pollingService = PollingService();

  _checkButtonEnable() {
    isMobileButtonEnabled = isNumber && mobileConsentCheckBoxValue;
  }

  _getSequenceModel() {
    if (onBoardingAABankSelectionNavigation != null) {
      sequenceEngineModel =
          onBoardingAABankSelectionNavigation!.getSequenceEngineDetails();
    }
  }

  WebViewControllerPlus webviewControllerPlus = WebViewControllerPlus();

  late BankReportModel bankReportModel;
  String reportId = "";
  SBDAddedBankState sbdAddedBankState = SBDAddedBankState.zeroBankAdded;

  bool isCLP = false;
  bool isSBD = false;
  String lpcString = "";

  void onAfterLayout() {
    offerUpgradePageState = OfferUpgradePageState.loading;
    _toggleAppBarVisibility(showAppBar: false);
    _getSequenceModel();
    getAppForm(
      onApiError: _onGetAppFormError,
      onRejected: _onAppFormRejected,
      onSuccess: _onGetAppFormSuccess,
    );
  }

  onFailureCtaPressed() {
    offerUpgradePageState = OfferUpgradePageState.bankList;
  }

  _onGetAppFormError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: OFFER_UPGRADE_BANK_DETIALS, retry: onAfterLayout);
  }

  _onAppFormRejected(CheckAppFormModel checkAppFormModel) {}

  ///compute text label for salaried or primary bank
  _onGetAppFormSuccess(AppForm appForm) {
    try {
      isCLP = appForm.loanProductCode == LoanProductCode.clp;
      isSBD = appForm.loanProductCode == LoanProductCode.sbd;
      if (!LPCService.instance.isLpcCardTopUp) {
        _checkConsent(appForm);
      }
      _computeUpgradeOfferInfoScreenVisibility();
      _computeAppBarTopTitleText();
      _checkIsNameMatchRejected(appForm.responseBody);
      logBankDetailsScreenLoaded(isCLP);
      lpcString = appForm.lpcString;
      double type =
          double.parse("${appForm.responseBody['applicant']['type'] ?? 0}");

      isUserSalaried = type == SALARIED_INDEX;
      _getBankReports();
    } on Exception catch (e) {
      handleAPIError(
          ApiResponse(
            state: ResponseState.failure,
            apiResponse: "",
            exception: e.toString(),
          ),
          screenName: OFFER_UPGRADE_BANK_DETIALS,
          retry: onAfterLayout);
    }
  }

  void _checkConsent(AppForm appForm) {
    switch (appForm.loanProductCode) {
      case LoanProductCode.sbd:
        String? consent = appForm.responseBody['consent']?['sbd_bank_details'];
        if (consent == null) {
          _showConsentBottomSheet();
        }
        break;
      default:
        break;
    }
  }

  _showConsentBottomSheet() async {
    Get.bottomSheet(
      BottomSheetWidget(
        child: SBDBankConsentBottomSheet(),
        onCloseClicked: () {
          Get.back();
          Get.back();
        },
      ),
      isDismissible: false,
    );
  }

  submitConsent() async {
    consentCTALoading = true;
    ApiResponse apiResponse =
        await _offerUpgradeRepository.submitBankDetailsConsent();
    consentCTALoading = false;
    switch (apiResponse.state) {
      case ResponseState.success:
        Get.back();
        break;
      default:
        handleAPIError(
          apiResponse,
          screenName: OFFER_UPGRADE_BANK_DETIALS,
          retry: submitConsent,
        );
    }
  }

  void _computeUpgradeOfferInfoScreenVisibility() {
    showUpgradeOfferInfoScreen =
        sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN;
    _toggleAppBarVisibility(showAppBar: !showUpgradeOfferInfoScreen);
  }

  void _toggleAppBarVisibility({required bool showAppBar}) {
    if (onBoardingAABankSelectionNavigation != null) {
      onBoardingAABankSelectionNavigation!.toggleAppBarVisibility(showAppBar);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_BANK_DETIALS);
    }
  }

  _getBankReports() async {
    BankReportModel model = await _offerUpgradeRepository.getBankReports();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        bankReportModel = model;
        if (model.shouldPoll) {
          reportId = model.reportId;
          offerUpgradePageState = OfferUpgradePageState.polling;
          _startBankReportPolling();
        } else {
          _computeSBDBankWidgets();
          _getBanks();
        }
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: OFFER_UPGRADE_BANK_DETIALS,
          retry: _getBankReports,
        );
    }
  }

  _startBankReportPolling() {
    _pollingService.initAndStartPolling(
      pollingInterval: 5,
      pollingFunction: () async {
        bankReportPollingModel =
            await _offerUpgradeRepository.bankReportPolling(reportId);
        switch (bankReportPollingModel.apiResponse.state) {
          case ResponseState.success:
            reportId = bankReportPollingModel.reportId;
            if (bankReportPollingModel.isCompleted) {
              _onBankReportPollingCompleted(bankReportPollingModel);
            }
            break;
          default:
            _pollingService.stopPolling();
            handleAPIError(
              bankReportPollingModel.apiResponse,
              screenName: OFFER_UPGRADE_BANK_DETIALS,
            );
        }
      },
    );
  }

  void _onBankReportPollingCompleted(BankReportPollingModel model) {
    if (sbdAddedBankState == SBDAddedBankState.zeroBankAdded) {
      logPrimaryBankAdded(model.isSuccess);
    }
    if (model.isSuccess) {
      _onBankReportPollingSuccess();
    } else {
      _pollingService.stopPolling();
      offerUpgradePageState = OfferUpgradePageState.failure;
    }
  }

  void _onBankReportPollingSuccess() {
    _pollingService.stopPolling();
    onAfterLayout();
  }

  _getBanks() async {
    SupportedBanksModel model =
        await _offerUpgradeRepository.getBanks(lpcString);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _populateBanks(model);
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: OFFER_UPGRADE_BANK_DETIALS, retry: _getBanks);
    }
  }

  void _populateBanks(SupportedBanksModel model) {
    banks = model.supportedBanks;
    Get.log("bank list length - ${banks.length}");
    offerUpgradePageState = OfferUpgradePageState.bankList;
  }

  Future onTapBankTextField() async {
    var result = await Get.toNamed(
      Routes.SEARCH_SCREEN,
      arguments: {
        'search_type': SearchType.bankDetails,
        'bank_list': banks,
        'sub_title_for_bank': _computeBankSubtitle(),
      },
    );
    if (result != null) {
      result as BanksModel;
      _selectedBank = result;
      Get.log("result - ${_selectedBank.toString()}");
      bankTextFieldError = null;
      selectedBankController.text = result.perfiosBankName;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.aaBankSelected,
          attributeName:
              sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
                  ? {"upgrade_flow_aa_perfios": "true"}
                  : {"rejection_flow_aa_perfios": "true"});
      _computeBankStatementUploadOptions();
    }
  }

  String _computeBankSubtitle() {
    if (isUserSalaried) {
      return "Choose the bank where salary is credited";
    } else if (sbdAddedBankState == SBDAddedBankState.zeroBankAdded) {
      return "Choose your Primary Bank Account";
    } else {
      return "Choose your Secondary Bank Account";
    }
  }

  void _computeBankStatementUploadOptions() {
    bankStatementUploadCombination =
        _selectedBank.computeBankUploadOptionCombination();

    ///to initially select the uploadOption with priority
    switch (bankStatementUploadCombination) {
      case BankStatementUploadCombination.aa:
      case BankStatementUploadCombination.aaNB:
      case BankStatementUploadCombination.aaUP:
      case BankStatementUploadCombination.all:
        selectedBankStatementUploadOption = BankStatementUploadOption.aa;
        break;
      case BankStatementUploadCombination.nb:
      case BankStatementUploadCombination.nbUP:
        selectedBankStatementUploadOption =
            BankStatementUploadOption.netBanking;
        break;
      case BankStatementUploadCombination.up:
        selectedBankStatementUploadOption = BankStatementUploadOption.uploadPDF;
        break;
      default:
        selectedBankStatementUploadOption = BankStatementUploadOption.aa;
        break;
    }
    logBankingMethodSelected(selectedBankStatementUploadOption);
    update();
  }

  String? validateBankTextField(String? value) {
    if (value != null && value.isEmpty) return "Please Select a Bank";
    return null;
  }

  onBankSelectionContinuePressed(
      BankStatementUploadOption bankStatementUploadOption) async {
    void validateAndClose() {
      if (bankValidationKey.currentState!.validate()) {
        Get.back(result: true);
      }
    }

    switch (bankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        if (isSBD) {
          Get.back(result: true);
          openMobileNumberBottomSheet();
        } else {
          validateAndClose();
        }
        break;

      default:
        validateAndClose();
        break;
    }
  }

  _initiateWebView({String? mobileNumber}) async {
    offerUpgradePageState = OfferUpgradePageState.loading;
    Map<String, dynamic> body = {
      "bankName": _selectedBank.perfiosBankName,
      "institutionId": _selectedBank.perfiosInstitutionId,
      "method": selectedBankStatementUploadOption.type,
      "returnUrl": perfiosWebViewCallBackURL,
      if (mobileNumber != null) "mobileNumber": mobileNumber
    };

    if (_isCLPAccountAggregator) {
      body.addAll({
        "phoneNumber": mobileNumber,
        "fipIds": [_selectedBank.pirimidBankId]
      });
    }

    BankReportInitiateModel model =
        await _offerUpgradeRepository.initiateBankReport(
      body,
      _isCLPAccountAggregator,
    );

    switch (model.apiResponse.state) {
      case ResponseState.success:
        reportId = model.reportId;
        _computeLPCForWebViewInitiate(model, mobileNumber);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: OFFER_UPGRADE_BANK_DETIALS,
          retry: () => _initiateWebView(),
        );
    }
  }

  bool get _isCLPAccountAggregator =>
      isCLP &&
      selectedBankStatementUploadOption == BankStatementUploadOption.aa;

  void _computeLPCForWebViewInitiate(
    BankReportInitiateModel model,
    String? mobileNumber,
  ) async {
    if (_isCLPAccountAggregator) {
      _openAAWebView(mobileNumber, model as AAConsentModel);
    } else {
      _openPerfiosWebView(model as PerfiosBankStatementModel);
    }
  }

  Future<void> _openAAWebView(
      String? mobileNumber, AAConsentModel model) async {
    String phoneNumber = mobileNumber ?? await AppAuthProvider.phoneNumber;
    _aaConsentIdList = model.consentId;
    _phoneNumber = phoneNumber;
    _toggleWebView(enableWebView: true);
  }

  void _openPerfiosWebView(PerfiosBankStatementModel model) {
    perfiosInitiateHTMLSnippet = model.htmlSnippet;
    Get.log(model.htmlSnippet);
    _toggleWebView(enableWebView: true);
  }

  _toggleWebView({required bool enableWebView}) {
    if (enableWebView) {
      _initializeWebViewController();
      offerUpgradePageState = OfferUpgradePageState.webView;
      if (isCLP) {
        Fluttertoast.showToast(
          msg:
              "Please use your ${isUserSalaried ? "Salaried" : "Primary"} bank account.",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
        );
      }
    } else {
      offerUpgradePageState = OfferUpgradePageState.bankList;
    }
  }

  _initializeWebViewController() {
    switch (selectedBankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        if (isCLP) {
          onAAWebViewCreated();
          break;
        }
        onPerfiosWebViewCreated();
        break;
      case BankStatementUploadOption.netBanking:
        onPerfiosWebViewCreated();
        break;
      case BankStatementUploadOption.uploadPDF:

        break;
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) return "Enter mobile number";
    if (value.length != 10) return "Please Check mobile Number";
    return null;
  }

  onMobileContinueTapped() {
    String phoneNumber = mobileNumberController.text;
    mobileNumberController.text = "";
    Get.back(result: phoneNumber);
  }

  String computeLabelText() {
    return isUserSalaried
        ? "Select your Salaried Bank"
        : "Select your Primary Bank";
  }

  void _checkIsNameMatchRejected(Map<String, dynamic> responseBody) {
    if ((responseBody['preprocessor']?['account_agg'] ?? "") == "SUCCESS") {
      bankTextFieldError =
          "Please select the correct bank account linked to your mobile number";
    }
  }

  void onPerfiosWebViewCreated() {
    webviewControllerPlus = WebViewControllerPlus()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: onPerfiosWebViewCallbackTriggered,
      ))
      ..loadHtmlString(perfiosInitiateHTMLSnippet);
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
    _toggleWebView(enableWebView: false);
    onWebViewRedirectAsSuccess(ACTION_TYPE_INITIATE);
  }

  onWebViewRedirectAsSuccess(String actionType) async {
    offerUpgradePageState = OfferUpgradePageState.polling;
    _startBankReportPolling();
  }

  void onAAWebViewCreated() {
    String htmlString = _generateHTMLCode();
    Get.log(htmlString);
    webviewControllerPlus = WebViewControllerPlus()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("AAEvents",
          onMessageReceived: (JavaScriptMessage message) {
        Get.log("message - ${message.message}");
        List<String> events = message.message.split('|');
        String event = events.first;
        String errorMessage = events[1];
        String eventMessage = events.last;
        _trackAAWebEvents(
          eventName: event,
          eventMessage: eventMessage,
          errorMessage: errorMessage,
        );
        switch (event) {
          case IFRAME_FAILED:
          case CONSENT_NOT_IN_PENDING_STATE:
            _toggleWebView(enableWebView: false);
            Fluttertoast.showToast(msg: "Please try again in sometime");
            break;
          case MOBILE_NUMBER_EDIT_REQUEST:
            _onWebMobileNumberEdit();
            break;
          case BANK_EDIT_REQUEST:
          case NO_ACCOUNTS_FOUND:
            _onWebBankEdit();
            break;
          case CONSENT_APPROVED_SUCCESS:
            onWebViewRedirectAsSuccess(ACTION_TYPE_INITIATE);
            break;
          case CONSENT_REJECTED_SUCCESS:
            _toggleWebView(enableWebView: false);
            break;
          case AAJOURNEY_CLOSED:
            onWebViewBackPressed();
            break;
          case TNC_CLICKED:
            launchUrlString(
              eventMessage.trim(),
              mode: LaunchMode.externalApplication,
            );
            break;
          default:
            Get.log("event - $event");
        }
      })
      ..loadHtmlString(htmlString);
  }

  String _generateHTMLCode() {
    return """
    <!DOCTYPE html>
<html>
  <head>
    <meta
      name="viewport"
      content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width"
    />
    <style>
      html,
      body {
        overflow-x: hidden;
        overflow-y: hidden;
      }
    </style>
  </head>
  <body onload="sdkInitiate()" style="width: 100vw; height: 100vh; margin: 0">
    <script>
      window.addEventListener("message", (event) => {
        const { data } = event;
        //Data will shown in popup(event list provided seprately)
        console.log(data);
        console.log(data["eventCode"] + "|" + data["errorMessage"]);
        AAEvents.postMessage(data["eventCode"] + "|" + data["errorMessage"] + "|" + data["eventMessage"]);
      });
      function sdkInitiate() {
        let iframe = document.getElementById("websdk");
        //Parameters required for websdk
        const webSdkKeys = {
          organisationId: "${F.envVariables.aasdkCreds.organisationId}",
          fipId: "${_selectedBank.pirimidBankId}",
          consentHandle: ${_aaConsentIdList.map((e) => "\"$e\"").toList()},
          mobileNumber: "$_phoneNumber",
          bankName: "${_selectedBank.perfiosBankName}",
        };
        iframe.contentWindow.postMessage(webSdkKeys, "*");
      }
      //Event listener for callbacks
    </script>
    <!--    <button onClick="sdkInitiate()">Initiate SDK Flow</button>-->
    <iframe
      id="websdk"
      src="${F.envVariables.aasdkCreds.iFrameURL}"
      width="100%"
      height="100%"
    ></iframe>
  </body>
</html>
    """;
  }

  void _onWebMobileNumberEdit() async {
    _toggleWebView(enableWebView: false);
    var result = await Get.bottomSheet(
      MobileEditBottomSheetWidget(),
      enableDrag: false,
      isDismissible: false,
    );
    if (result != null) {
      Get.log("result - $result");
      _initiateWebView(
        mobileNumber: result,
      );
    } else {
      mobileNumberController.text = "";
    }
  }

  void _onWebBankEdit() {
    _toggleWebView(enableWebView: false);
    bankTextFieldError =
        "Please select the correct bank account linked to your mobile number";
  }

  void _trackAAWebEvents({
    required String eventName,
    required String eventMessage,
    required String errorMessage,
  }) {
    try {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "AA_WEB_$eventName",
        attributeName: {
          "eventMessage": eventMessage,
          "errorMessage": errorMessage,
        },
      );
    } catch (e) {
      ErrorLoggerMixin().logError(
        exception: e.toString(),
        requestBody: "objectData - $eventName",
        responseBody: "Error while parsing AA Callback",
        statusCode: "",
        url: "",
      );
    }
  }

  Future<bool> onWebViewBackPressed() async {
    var result = await Get.dialog(
      const WebViewCloseAlertDialog(),
    );
    if (result != null && result) {
      _toggleWebView(enableWebView: false);
    }
    return false;
  }

  onTapNoBanksFound() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: "AA_BANK_NOT_FOUND_CLICKED",
    );
    Get.bottomSheet(const NoBanksFoundWidget());
  }

  onTapBankStatementType(BankStatementUploadOption bankStatementUploadOption) {
    logBankingMethodSelected(bankStatementUploadOption);
    _computeBankStatementEvents(bankStatementUploadOption);
    selectedBankStatementUploadOption = bankStatementUploadOption;
  }

  String _computeUpgradeType() {
    switch (selectedBankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        return "account_aggregator";
      case BankStatementUploadOption.netBanking:
      case BankStatementUploadOption.uploadPDF:
        return "perfios";
    }
  }

  void onUpgradeInfoPageCloseClicked() async {
    offerUpgradePageState = OfferUpgradePageState.loading;
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {
        "actionType": "opt_out",
      },
    );
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        Get.back();
        break;
      default:
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: OFFER_UPGRADE_BANK_DETIALS,
            retry: onUpgradeInfoPageCloseClicked);
    }
  }

  onClickUpgradeNow() {
    showUpgradeOfferInfoScreen = false;
    _toggleAppBarVisibility(showAppBar: true);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aaCTAIntermediateUpgradeNowClicked,
        attributeName: {"upgrade_flow_aa_perfios": "true"});
    update();
  }

  void _computeAppBarTopTitleText() {
    if (sequenceEngineModel.screenType != FO_APPROVED_UPGRADE_SCREEN) {
      _changeAppBarTitle();
    }
  }

  void _changeAppBarTitle() {
    if (onBoardingAABankSelectionNavigation != null) {
      onBoardingAABankSelectionNavigation!
          .changeAppBarTopTitleText("Set up Credit Line");
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_BANK_DETIALS);
    }
  }

  void onInAppWebViewCreated(InAppWebViewController controller) {
    controller.loadData(data: perfiosInitiateHTMLSnippet);
  }

  Future<NavigationActionPolicy?> onUploadPDFCallbackTriggered(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    if (_isPerfiosCallbackURL(navigationAction)) {
      if (!isUploadPDFCallbackTriggered) {
        isUploadPDFCallbackTriggered = true;
        _computePerfiosStatus(navigationAction.request.url!.rawValue);
      }
    } else {
      isUploadPDFCallbackTriggered = false;
    }
    return NavigationActionPolicy.ALLOW;
  }

  bool _isPerfiosCallbackURL(NavigationAction navigationAction) {
    if (navigationAction.request.url == null) return false;
    try {
      Get.log("navigation url = ${navigationAction.request.url!.rawValue}");
      String baseURL =
          AppFunctions().getBaseUrlFromString(perfiosWebViewCallBackURL);
      String callBackBaseURL = AppFunctions()
          .getBaseUrlFromString(navigationAction.request.url!.rawValue);
      return callBackBaseURL == baseURL;
    } on Exception catch (e) {
      Get.log("onPerfiosWebViewCallbackTriggered exception - ${e.toString()}");
      return false;
    }
  }

  late String bankStatementMethodEventName;

  void _computeBankStatementEvents(
      BankStatementUploadOption bankStatementUploadOption) {
    switch (bankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        bankStatementMethodEventName =
            WebEngageConstants.aaBankStatementMethodVerifyViaOTP;
        break;
      case BankStatementUploadOption.netBanking:
        bankStatementMethodEventName =
            WebEngageConstants.aaBankStatementMethodNetBanking;
        break;
      case BankStatementUploadOption.uploadPDF:
        bankStatementMethodEventName =
            WebEngageConstants.aaBankStatementMethodUploadPDF;
        break;
    }
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: bankStatementMethodEventName,
        attributeName:
            sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
                ? {"upgrade_flow_aa_perfios": "true"}
                : {"rejection_flow_aa_perfios": "true"});
  }

  onTapAddBank(String bankPosition, {bool isTertiary = false}) async {
    if (isTertiary) {
      logAddMoreBanksCta();
    } else {
      logAddBankCta(bankPosition);
    }

    await onTapBankTextField();
    if (selectedBankController.text.isEmpty) {
      // If user dones't selects the bank then will not open SelectBankBottomSheet
      return;
    }
    logBankSelected();
    var result = await Get.bottomSheet(
      BottomSheetWidget(
        child: SelectBankBottomSheet(
          title: _computeBankSelectionBottomSheetTitle(),
        ),
      ),
      isScrollControlled: true,
    );
    if (result == null) {
      bankTextFieldError = null;
      selectedBankController.text = "";
      bankStatementUploadCombination = null;
      update();
    } else if (result) {
      _computeWebView(selectedBankStatementUploadOption);
    }
  }

  _computeWebView(BankStatementUploadOption bankStatementUploadOption) {
    switch (bankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        if (!isSBD) {
          _initiateWebView();
        }
        break;
      default:
        _initiateWebView();
        break;
    }
  }

  String _computeBankSelectionBottomSheetTitle() {
    switch (sbdAddedBankState) {
      case SBDAddedBankState.zeroBankAdded:
        return "Primary Bank";
      default:
        return "Secondary Bank";
    }
  }

  void _computeSBDBankWidgets() {
    if (bankReportModel.bankList.isEmpty) {
      sbdAddedBankState = SBDAddedBankState.zeroBankAdded;
    } else if (bankReportModel.bankList.length == 1) {
      sbdAddedBankState = SBDAddedBankState.oneBankAdded;
    } else if (bankReportModel.bankList.length == 2) {
      sbdAddedBankState = SBDAddedBankState.twoBanksAdded;
    } else {
      sbdAddedBankState = SBDAddedBankState.threeBanksAdded;
    }
  }

  onContinuePressed() async {
    logAllBanksAddedContinueCta(isCLP);
    if (isCLP || sbdAddedBankState != SBDAddedBankState.oneBankAdded) {
      _callSequenceEngine();
    } else {
      _showAlertToAddSecondBank();
    }
  }

  Future<void> _showAlertToAddSecondBank() async {
    var result = await Get.bottomSheet(
      const BottomSheetWidget(
        child: AddSecondBankAlertWidget(),
      ),
    );
    if (result == null) return;
    if (result) {
      logMissoutAddSecondBankCta();
      onTapAddBank('secondary');
    } else {
      logMissoutContinueWithoutAddingCta(isCLP);
      _callSequenceEngine();
    }
  }

  _callSequenceEngine() async {
    isButtonLoading = true;
    _getSequenceModel();
    Map<String, dynamic> body = {};
    if (isCLP) {
      body['actionType'] = "initiate";
      body['upgradeType'] = _computeUpgradeType();
    }
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: body,
    );
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _computeAppformRejected(model);
        break;
      default:
        isButtonLoading = false;
        handleAPIError(
          model.apiResponse,
          screenName: OFFER_UPGRADE_BANK_DETIALS,
          retry: _callSequenceEngine,
        );
    }
  }

  void _computeAppformRejected(CheckAppFormModel checkAppFormModel) {
    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      _onAppFormRejectionNavigation(checkAppFormModel.appFormRejectionModel);
    } else {
      _goToNextAppState(checkAppFormModel);
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (onBoardingAABankSelectionNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.offerejected);
      onBoardingAABankSelectionNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_BANK_DETIALS);
    }
  }

  void _goToNextAppState(CheckAppFormModel checkAppFormModel) {
    if (onBoardingAABankSelectionNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingAABankSelectionNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_BANK_DETIALS);
    }
  }

  onPollingClosePressed() {
    _pollingService.stopPolling();
    Get.back();
  }

  stopPolling() {
    _pollingService.stopPolling();
  }

  startPolling() {
    _startBankReportPolling();
  }

  void openMobileNumberBottomSheet() async {
    var result = await Get.bottomSheet(
      MobileNumberBottomSheet(
        flowType: 'underwriting',
      ),
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
    );
    if (result != null) {
      _initiateWebView(mobileNumber: result);
    }
  }
}
