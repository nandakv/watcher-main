import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/html_code.dart';
import 'package:privo/app/data/repository/on_boarding_repository/emandate_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/aa_stand_alone_journey/aa_bank_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/aa_stand_alone_journey/aa_stand_alone_know_more_model.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../res.dart';
import '../../../api/api_error_mixin.dart';
import '../../../api/response_model.dart';
import '../../../common_widgets/java_script_web_event_channel.dart';
import '../../../common_widgets/web_view_close_alert_dialog.dart';
import '../../../components/mobile_number_bottom_sheet/mobile_number_bottom_sheet.dart';
import '../../../data/provider/auth_provider.dart';
import '../../../data/repository/on_boarding_repository/offer_upgrade_repository.dart';
import '../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../models/bank_details_model.dart';
import '../../../models/check_app_form_model.dart';
import '../../../models/e_mandate/e_mandate_bank_model.dart';
import '../../../models/offer_upgrade/aa_consent_model.dart';
import '../../../models/offer_upgrade/bank_report_initiate_model.dart';
import '../../../models/sequence_engine_model.dart';
import '../mixins/app_form_mixin.dart';
import '../mixins/on_boarding_mixin.dart';
import '../widgets/search_screen/bank_logo_mixin.dart';
import 'aa_stand_alone_bank_account_model.dart';
import 'aa_stand_alone_know_more_bottom_sheet.dart';
import 'aa_stand_alone_repository.dart';
import 'on_boarding_aa_stand_alone_navigation.dart';

enum AABankPageState {
  loading,
  bankAccountConsent,
  polling,
  webView,
  failure,
  success
}

class AAStandAloneLogic extends GetxController
    with
        BankLogoMixin,
        ApiErrorMixin,
        OnBoardingMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        AABankAnalyticsMixin
    implements WebEventHandler {
  OnBoardingAAStandAloneNavigation? onBoardingAAStandAloneNavigation;

  late JavaScriptWebEventChannel javaScriptWebEventChannel;

  _initWebViewChannel() {
    javaScriptWebEventChannel = JavaScriptWebEventChannel(webEventHandler: this);
  }

  AABankPageState _aaBankState = AABankPageState.loading;

  AABankPageState get aaBankState => _aaBankState;

  set aaBankState(AABankPageState aaBankState) {
    _aaBankState = aaBankState;
    update();
  }

  late SequenceEngineModel sequenceEngineModel;

  int retryCount = 0;
  int MAX_RETRY_COUNT = 2;
  bool isCLP = false;
  List<String> _aaConsentIdList = [];
  String _phoneNumber = "";
  late String responseURL;

  final String AA_BANK_FLOW = "aa_bank_flow";
  String perfiosWebViewCallBackURL = "https://privo.in?txnId=%s&status=%s";

  final aaStandAloneRepository = AAStandAloneRepository();
  final offerUpgradeRepository = OfferUpgradeRepository();

  late AAStandAloneBankReport aaStandAloneBankReport;

  void onAfterLayout() async {
    _fetchRetryCount();
    _initWebViewChannel();
    getAppForm(
      onApiError: _onGetAppFormError,
      onRejected: _onAppFormRejected,
      onSuccess: _onGetAppFormSuccess,
    );
  }

  _fetchRetryCount() async {
    retryCount = await AppAuthProvider.aaRetryCount;
  }

  _onGetAppFormError(ApiResponse apiResponse) {
    handleAPIError(apiResponse, screenName: AA_BANK_FLOW, retry: onAfterLayout);
  }

  _onAppFormRejected(CheckAppFormModel checkAppFormModel) {
    if (onBoardingAAStandAloneNavigation != null) {
      onBoardingAAStandAloneNavigation!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(AA_BANK_FLOW);
    }
  }

  void openMobileNumberBottomSheet() async {
    var result = await Get.bottomSheet(
      MobileNumberBottomSheet(flowType: "botf",),
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
    );
    if (result != null) {
      _initiateWebView(mobileNumber: result);
    }
  }

  // get bank details from emandateBank
  _getBankDetails() async {
    AAStandAloneBankAccountModel model = await aaStandAloneRepository.getAAStandAloneBank();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        aaStandAloneBankReport = model.aaStandAloneBankReport;
        logBotfScreenLoaded();
        aaBankState = AABankPageState.bankAccountConsent;
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: AA_BANK_FLOW,
          retry: _getBankDetails,
        );
    }
  }

  _onGetAppFormSuccess(AppForm appForm) {
    try {
      _getSequenceEngineModel();
      _getBankDetails();
    } on Exception catch (e) {
      handleAPIError(
          ApiResponse(
            state: ResponseState.failure,
            apiResponse: "",
            exception: e.toString(),
          ),
          screenName: AA_BANK_FLOW,
          retry: onAfterLayout);
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingAAStandAloneNavigation != null) {
      sequenceEngineModel =
          onBoardingAAStandAloneNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(AA_BANK_FLOW);
    }
  }

  void _toggleAppBarVisibility({required bool isVisible}) {
    if (onBoardingAAStandAloneNavigation != null) {
      onBoardingAAStandAloneNavigation!.toggleAppBarVisibility(isVisible);
    } else {
      onNavigationDetailsNull(AA_BANK_FLOW);
    }
  }

  //failure screen try again CTA clicked
  onTryAgainClicked() {
    aaBankState = AABankPageState.loading;
    logBotfTryAgainClicked();
    retryCount++;
    AppAuthProvider.setAARetryCount(retryCount);
    _toggleAppBarVisibility(isVisible: true);
    aaBankState = AABankPageState.bankAccountConsent;
    logBotfScreenLoaded();
  }

  _initiateWebView({String? mobileNumber}) async {
    _toggleAppBarVisibility(isVisible: false);
    aaBankState = AABankPageState.loading;
    Map<String, dynamic> body = {
      "bankName": aaStandAloneBankReport.bankName,
      "institutionId": aaStandAloneBankReport.perfiosInstitutionId,
      "method": "accountAggregator",
      "returnUrl": perfiosWebViewCallBackURL,
      "vendor": "pirimid",
      "fipIds": [aaStandAloneBankReport.pirimidBankId],
      "flow":"event",
      if (mobileNumber != null) "mobileNumber": mobileNumber
    };
    BankReportInitiateModel model =
        await offerUpgradeRepository.initiateBankReport(body, true);

    switch (model.apiResponse.state) {
      case ResponseState.success:
        _openAAWebView(mobileNumber, model as AAConsentModel);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: AA_BANK_FLOW,
          retry: () => _initiateWebView(mobileNumber: mobileNumber),
        );
    }
  }

  Future<void> _openAAWebView(
      String? mobileNumber, AAConsentModel model) async {
    String phoneNumber = mobileNumber ?? await AppAuthProvider.phoneNumber;
    _aaConsentIdList = model.consentId;
    _phoneNumber = phoneNumber;
    responseURL = model.responseURL;
    _toggleWebView(enableWebView: true);
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

  _toggleWebView({required bool enableWebView}) {
    if (enableWebView) {
      aaBankState = AABankPageState.webView;
    } else {
      _toggleAppBarVisibility(isVisible: true);
      aaBankState = AABankPageState.bankAccountConsent;
      logBotfScreenLoaded();
    }
  }

  postAccountAggregatorAction({bool isSkipNowClicked = false}) async {
    if (!isSkipNowClicked) {
      aaBankState = AABankPageState.polling;
      logBotfPollingScreen();
    }
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {
        "actionType": isSkipNowClicked ? "skip" : "success",
        "appFormId": AppAuthProvider.appFormID
      },
    );
    switch (model.apiResponse.state) {
      case ResponseState.success:
        if (!isSkipNowClicked) {
          aaBankState = AABankPageState.success;
          await Future.delayed(const Duration(seconds: 3));
          logBotfSuccessScreen();
        }
        _navigate(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          retry: postAccountAggregatorAction,
          screenName: AA_BANK_FLOW,
        );
    }
  }

  void _navigate(CheckAppFormModel appFormModel) {
    if (appFormModel.sequenceEngine != null) {
      onBoardingAAStandAloneNavigation!.navigateUserToAppStage(
          sequenceEngineModel: appFormModel.sequenceEngine!);
    } else {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "Issue in Sequence engine in account aggregator",
        ),
        screenName: AA_BANK_FLOW,
      );
    }
  }

  final List<AAStandAloneKnowMoreModel> knowMoreList = [
    AAStandAloneKnowMoreModel(
      icon: Res.loans,
      title: 'Eligible for higher loan limits for your future borrowing needs',
    ),
    AAStandAloneKnowMoreModel(
      icon: Res.finance,
      title:
          'Enjoy free alerts and real-time monitoring of your bank account, exclusively for our users',
    ),
    AAStandAloneKnowMoreModel(
      icon: Res.clock2,
      title: 'Get approved for future loans faster and with ease',
    ),
  ];

  @override
  void handleWebViewFailure() {
    logAABotfFailureScreen(failureReason: "IFRAME_FAILED");
    if (retryCount > 1) logBotfFailureScreenWithSkip();
    aaBankState = AABankPageState.failure;
  }

  @override
  void handleWebViewNotPending() {
    _toggleWebView(enableWebView: false);
    Fluttertoast.showToast(msg: "Please try again in sometime");
  }

  @override
  void onWebViewConsentApproved() {
    postAccountAggregatorAction();
  }

  @override
  void onWebViewConsentRejected() {
    logAABotfFailureScreen(failureReason: "CONSENT_REJECTED_SUCCESS");
    if (retryCount > 1) logBotfFailureScreenWithSkip();
    aaBankState = AABankPageState.failure;
  }

  @override
  void onWebviewNoAccountFoundJourneyClosed() {
    if (retryCount < MAX_RETRY_COUNT) {
      retryCount++;
      AppAuthProvider.setAARetryCount(retryCount);
      aaBankState = AABankPageState.bankAccountConsent;
    } else {
      logAABotfFailureScreen(failureReason: "NO_ACCOUNTS_FOUND_JOURNEY_CLOSED");
      aaBankState = AABankPageState.failure;
    }
  }

  @override
  void onWebViewJourneyClosed() {
    if (retryCount < MAX_RETRY_COUNT) {
      retryCount++;
      AppAuthProvider.setAARetryCount(retryCount);
      onWebViewBackPressed();
    } else {
      logAABotfFailureScreen(failureReason: "AAJOURNEY_CLOSED");
      aaBankState = AABankPageState.failure;
    }
  }

  onSkipClickedEvent() {
    logBotfSkipCtaClicked();
    postAccountAggregatorAction(isSkipNowClicked: true);
  }

  bool onCloseButtonClicked({required String screenName}) {
    Get.back();
    logCrossButtonClicked(screenName: screenName);
    return false;
  }

  onKnowMoreCTA() {
    Get.back();
    logBotfBenefitsKnowMoreContinueClicked();
    openMobileNumberBottomSheet();
  }

  onBankConsentContinueCTA() {
    logBotfScreenContinueClicked();
    openMobileNumberBottomSheet();
  }

  onAABotfBenefitsCrossClicked() {
    logAABotfBenefitsCrossClicked();
    Get.back();
  }

  @override
  void onWebViewConsentApprovedFailed() {
    logAABotfFailureScreen(failureReason: "CONSENT_APPROVED_FAILED");
    aaBankState = AABankPageState.failure;
  }

  @override
  void onWebViewConsentRejectedFailed() {
    logAABotfFailureScreen(failureReason: "CONSENT_REJECTED_FAILED");
    aaBankState = AABankPageState.failure;
  }


  void eventListenerCallBack(List<dynamic> args) {
    try {
      Map<String, dynamic> data = json.decode(args[0].toString());
      String event = data['event'] ?? '';
      String eventMessage = data['eventMessage'] ?? '';
      String eventCode = data['eventCode'] ?? '';

      javaScriptWebEventChannel.handleWebEvent(eventCode, eventMessage);
    } catch (e) {
      Get.log("Error parsing event data: $e");
    }
  }

  void onKnowMoreClicked() {
    logBotfBenefitsKnowMoreClicked();
    Get.bottomSheet(AAStandAloneKnowMoreBottomSheet(),
        isDismissible: false, isScrollControlled: true);
  }
}
