import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/emandate_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/e_mandate/e_mandate_bank_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_failure_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/emandate_error_messages.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../../flavors.dart';
import '../../../../common_widgets/web_view_close_alert_dialog.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/emandate_response_model.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../analytics/e_mandate_analytics_mixin.dart';

enum EMandateState { loading, idle, jusPay, jusPayWebView, razorPay, error }

enum ESignFlow { clp, clickWrap, digio }

enum JusPayMandateType { upi, eNach }

class EMandateLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, AppFormMixin, EMandateAnalyticsMixin {
  static const String EMANDATE_DETAILS = 'e_mandate_details';
  final String JUSPAY_CALLBACK_URL = "https://privo.in";
  late String title = "Set up Auto-Pay";

  OnBoardingEMandateNavigation? onBoardingEMandateNavigation;

  final eMandateRepository = EmandateRepository();

  EMandateLogic({this.onBoardingEMandateNavigation});

  late SequenceEngineModel sequenceEngineModel;

  late String MANDATE_TYPE_WIDGET_ID = "MANDATE_TYPE_WIDGET_ID";

  JusPayMandateType? _selectedMandateType;

  JusPayMandateType? get selectedMandateType => _selectedMandateType;

  set selectedMandateType(JusPayMandateType? value) {
    _selectedMandateType = value;
    _computeCTAStatus();
    update([MANDATE_TYPE_WIDGET_ID, BUTTON_KEY]);
  }

  JusPayMandateCombination jusPayMandateCombination =
      JusPayMandateCombination.all;

  final String BODY_KEY = 'body_key';
  final String BUTTON_KEY = 'button_key';
  final String UPI_TEXTFIELD__KEY = 'UPI_TEXTFIELD__KEY';

  bool isButtonEnabled = false;

  EMandateState _eMandateState = EMandateState.loading;

  EMandateState get eMandateState => _eMandateState;

  set eMandateState(EMandateState state) {
    _eMandateState = state;
    update([BODY_KEY]);
    _toggleBack(isBackDisabled: _eMandateState == EMandateState.loading);
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_KEY]);
    _toggleBack(isBackDisabled: _isButtonLoading);
  }

  _toggleBack({required bool isBackDisabled}) {
    if (onBoardingEMandateNavigation != null) {
      onBoardingEMandateNavigation!.getEMandateState(eMandateState);
      onBoardingEMandateNavigation!.toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(EMANDATE_DETAILS);
    }
  }

  void _toggleAppBarVisibility({required bool isVisible}) {
    if (onBoardingEMandateNavigation != null) {
      onBoardingEMandateNavigation!.toggleAppBarVisibility(isVisible);
    } else {
      onNavigationDetailsNull(EMANDATE_DETAILS);
    }
  }

  void _changeAppBarTitle({required String title, required String subTitle}) {
    if (onBoardingEMandateNavigation != null) {
      onBoardingEMandateNavigation!.changeAppBarTitle(title, subTitle);
    } else {
      onNavigationDetailsNull(EMANDATE_DETAILS);
    }
  }

  String ifscCode = "";
  String accountNumber = "";
  String bankName = "";

  final upiAddressController = TextEditingController();
  String _upiAddressErrorText = "";

  String get upiAddressErrorText => _upiAddressErrorText;

  set upiAddressErrorText(String value) {
    _upiAddressErrorText = value;
    _computeCTAStatus();
    update([UPI_TEXTFIELD__KEY, BUTTON_KEY]);
  }

  late Razorpay _razorpay;
  int razorPayTimeOutCode = 2;
  EmandateFailureModel failureMessage = EmandateFailureModel(
    title: "Uh-oh!",
    subTitle:
        "It seems like a temporary technical issue is preventing\nAuto-pay registration. Please try again later.",
  );

  String jusPayWebViewURL = "";

  WebViewControllerPlus webViewControllerPlus = WebViewControllerPlus();

  @override
  void onInit() {
    initializeRazorPay();
    super.onInit();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _postMandateAction();
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Get.log(response.toString());
    if (response.code == razorPayTimeOutCode && response.error != null) {
      failureMessage =
          emandateErrorMessages[response.error!['reason']] ?? failureMessage;
    }
    eMandateState = EMandateState.error;
  }

  void onAfterLayout() async {
    _toggleAppBarVisibility(isVisible: false);
    eMandateState = EMandateState.loading;
    _getSequenceEngine();
    _getBankDetails();
  }

  _getSequenceEngine() {
    if (onBoardingEMandateNavigation != null) {
      sequenceEngineModel =
          onBoardingEMandateNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(EMANDATE_DETAILS);
    }
  }

  _getBankDetails() async {
    EMandateBankModel model = await eMandateRepository.getEMandateBank();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _computeBankNameAndIfscCode(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: EMANDATE_DETAILS,
          retry: _getBankDetails,
        );
    }
  }

  _computeBankNameAndIfscCode(EMandateBankModel model) {
    try {
      _computeBankDetails(model);
      _getJusPayMandateType();
    } catch (e) {
      Get.log("parse exception - $e");
      _toggleBack(isBackDisabled: false);
      handleAPIError(
        ApiResponse(
          state: ResponseState.jsonParsingError,
          apiResponse: "",
          exception: e.toString(),
        ),
        screenName: EMANDATE_DETAILS,
      );
    }
  }

  _computeBankDetails(EMandateBankModel model) {
    accountNumber = model.bankAccount.accountNumber;
    ifscCode = model.bankAccount.ifscCode;
    bankName = model.bankAccount.bankName;
  }

  _getJusPayMandateType() async {
    BanksModel banksModel = await eMandateRepository.getJusPayMandateType();
    switch (banksModel.apiResponse.state) {
      case ResponseState.success:
        jusPayMandateCombination = banksModel.computeJusPayMandateType();
        _computeJusPayMandateType();
        isButtonLoading = false;
        eMandateState = EMandateState.idle;
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.autoPayLoaded);
        break;
      default:
        handleAPIError(
          banksModel.apiResponse,
          screenName: EMANDATE_DETAILS,
          retry: _getJusPayMandateType,
        );
    }
  }

  void _computeJusPayMandateType() {
    _toggleAppBarVisibility(isVisible: true);
    _computeTitleAndSubtitle();
    switch (jusPayMandateCombination) {
      case JusPayMandateCombination.all:
      case JusPayMandateCombination.upi:
        selectedMandateType = JusPayMandateType.upi;
        break;
      case JusPayMandateCombination.eNach:
        selectedMandateType = JusPayMandateType.eNach;
        break;
      default:
      //do nothing
    }
  }

  toggleToJusPayScreen() {
    logSetupAutopayLinkAccountCTA();
    _computeTitleAndSubtitle();
    isButtonLoading = false;
    if (jusPayMandateCombination == JusPayMandateCombination.eNach) {
      startEmandateProcess();
    } else {
      eMandateState = EMandateState.jusPay;
      logSetupAutopayMainScreenLoaded(jusPayMandateCombination);
    }
  }

  _computeTitleAndSubtitle() {
    if (jusPayMandateCombination == JusPayMandateCombination.eNach) {
      title = "Set up Auto-Pay";
    }
  }

  onSetupEMandateContinueTapped() async {
    isButtonLoading = true;

    ///CTA Button will get enabled only if [selectedMandateType] is not null
    ///so null check is already handled here
    logAutopayOptionCTAClicked(selectedMandateType!);
    if (selectedMandateType == JusPayMandateType.upi) {
      logUpiAddressEntered();
    }
    Get.focusScope?.unfocus();
    startEmandateProcess();
  }

  ///Initiates the emandate process
  startEmandateProcess() async {
    isButtonLoading = true;

    Map<String, dynamic> body = {
      "mandateMethod": _computeMandateMethod(),
      "callbackUrl": JUSPAY_CALLBACK_URL,
      if (selectedMandateType == JusPayMandateType.upi)
        "upiVpa": upiAddressController.text,
    };

    CheckAppFormModel requestModel =
        await EmandateRepository().startEmandatePost(body: body);
    final eMandateResponseModel =
        EMandateResponseModel.decodeResponse(requestModel.apiResponse);
    switch (eMandateResponseModel.apiResponse.state) {
      case ResponseState.success:
        if (eMandateResponseModel.isSuccess) {
          _postMandateAction();
        } else if (eMandateResponseModel.isJusPay) {
          jusPayWebViewURL = eMandateResponseModel.jusPayWebViewUrl;
          eMandateState = EMandateState.jusPayWebView;
          onJusPayWebViewCreated();
        } else {
          openRazorpay(
            customerId: eMandateResponseModel.customerId,
            orderId: eMandateResponseModel.orderId,
          );
          eMandateState = EMandateState.razorPay;
        }
        break;
      case ResponseState.badRequestError:
        _computeUPIValidationError(requestModel);
        isButtonLoading = false;
        eMandateState = EMandateState.jusPay;
        break;
      default:
        handleAPIError(
          eMandateResponseModel.apiResponse,
          retry: startEmandateProcess,
          screenName: EMANDATE_DETAILS,
        );
    }
  }

  void _computeUPIValidationError(CheckAppFormModel requestModel) {
    upiAddressErrorText = "Enter Valid UPI address";
    List<FieldError> fieldErrors =
        requestModel.error?.errorBody.fieldErrors ?? [];
    for (FieldError fieldError in fieldErrors) {
      if (fieldError.fieldName == "vpa") {
        upiAddressErrorText = fieldError.message;
        break;
      }
    }
  }

  void openRazorpay({
    required String orderId,
    required String customerId,
  }) async {
    var options = {
      'key': F.envVariables.razorPayEMandateKeys.apiKey,
      "order_id": orderId,
      "customer_id": customerId,
      'timeout': 300, // in seconds
      "recurring": "1",
      "name": "Credit Saison IN",
      "description": "Mandate payment for Credit Saison IN",
      "theme": {"color": "#004097"},
      "retry": false
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.log("Error opening sdk ${e.toString()}");
    }
  }

  void onJusPayWebViewCreated() {
    _toggleAppBarVisibility(isVisible: false);
    webViewControllerPlus
      ..loadRequest(Uri.parse(jusPayWebViewURL))
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: onJusPayWebViewNavigation,
      ));
  }

  FutureOr<NavigationDecision> onJusPayWebViewNavigation(
      NavigationRequest navigation) {
    String baseURL = AppFunctions().getBaseUrlFromString(navigation.url);
    if (JUSPAY_CALLBACK_URL == baseURL) {
      _toggleAppBarVisibility(isVisible: true);

      eMandateState = jusPayMandateCombination == JusPayMandateCombination.eNach
          ? EMandateState.idle
          : EMandateState.jusPay;

      String status = getMandateStatus(navigation.url);
      if (status.isNotEmpty && status != "CREATED") {
        _postMandateAction();
      } else {
        isButtonLoading = false;
      }
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  String getMandateStatus(String urlString) {
    Uri uri = Uri.parse(urlString);
    return uri.queryParameters['status'] ?? "";
  }

  _postMandateAction() async {
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {},
    );
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _navigate(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          retry: _postMandateAction,
          screenName: EMANDATE_DETAILS,
        );
    }
  }

  void _navigate(CheckAppFormModel appFormModel) {
    if (appFormModel.sequenceEngine != null) {
      onBoardingEMandateNavigation!.navigateUserToAppStage(
          sequenceEngineModel: appFormModel.sequenceEngine!);
    } else {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "Issue in Sequence engine in EMandate",
        ),
        screenName: EMANDATE_DETAILS,
      );
    }
  }

  String _computeMandateMethod() {
    ///added null check in parent
    switch (selectedMandateType!) {
      case JusPayMandateType.upi:
        return "upimandate";
      case JusPayMandateType.eNach:
        return "emandate";
    }
  }

  String computeJusPayScreenCTAText() {
    if (selectedMandateType == JusPayMandateType.upi) return "Send Request";
    return "Continue";
  }

  onTapJusPayTypeTile(JusPayMandateType jusPayMandateType) {
    selectedMandateType = jusPayMandateType;
    logAutopayOptionToggle(jusPayMandateType);
    switch (jusPayMandateType) {
      case JusPayMandateType.upi:
        break;
      case JusPayMandateType.eNach:
        if (upiAddressController.text.isEmpty) {
          upiAddressErrorText = "";
        }
        break;
    }
  }

  validateUpiAddressText() async {
    if (upiAddressController.text.isEmpty) {
      upiAddressErrorText = "Enter Valid UPI address";
    } else {
      upiAddressErrorText = "";
      final RegExp regex = RegExp(r'^.{3,40}@.*$');
      if (regex.hasMatch(upiAddressController.text)) {
        upiAddressErrorText = "";
      } else {
        upiAddressErrorText = "Enter Valid UPI address";
      }
    }
  }

  _computeCTAStatus() {
    if (selectedMandateType != null &&
        selectedMandateType == JusPayMandateType.upi) {
      isButtonEnabled =
          upiAddressController.text.isNotEmpty && upiAddressErrorText.isEmpty;
    } else {
      isButtonEnabled =
          selectedMandateType != null && upiAddressErrorText.isEmpty;
    }
  }

  Future<bool> onWebViewBackPressed() async {
    if (eMandateState == EMandateState.jusPayWebView) {
      var result = await Get.dialog(
        const WebViewCloseAlertDialog(),
      );
      if (result != null && result) {
        _toggleAppBarVisibility(isVisible: true);
        isButtonLoading = false;
        switch (jusPayMandateCombination) {
          case JusPayMandateCombination.all:
          case JusPayMandateCombination.upi:
            eMandateState = EMandateState.jusPay;
            break;
          case JusPayMandateCombination.eNach:
            eMandateState = EMandateState.idle;
            break;
        }
      }
      return false;
    }
    return true;
  }

  shouldShowHelpMessage() {
    String? loanProductCode = LPCService.instance.activeCard?.loanProductCode;
    if (loanProductCode != null &&
        !(AppFunctions().computeLoanProductCode(loanProductCode) ==
            LoanProductCode.clp)) {
      return true;
    }
    return false;
  }
}
