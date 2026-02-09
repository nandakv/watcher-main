import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/data/repository/on_boarding_repository/offer_upgrade_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/bank_details_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/penny_testing/penny_testing_bank_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/models/installed_app_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_screen_logic.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../data/repository/app_parameter_repository.dart';
import '../../../../models/app_parameter_model.dart';
import '../../../../models/bank_details_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/penny_testing_data_transfer_model.dart';
import '../../../../models/supported_banks_model.dart';
import '../../../../utils/native_channels.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../on_boarding_logic.dart';
import '../../mixins/on_boarding_mixin.dart';
import 'package:get/get.dart';

import 'bank_details_analytics.dart';
import 'bank_details_field_validator.dart';
import 'widgets/upi_apps_popup_widget.dart';

///
enum PennyTestingType { reverse, forward }

enum BankDetailsState { loading, form, prefilled }

class BankDetailsLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        BankDetailsAnalytics,
        BaseFieldValidators,
        BankDetailsFieldValidator{
  OnboardingNavigationBankDetails? onboardingNavigationBankDetails;

  BankDetailsState _bankDetailsState = BankDetailsState.loading;

  BankDetailsState get bankDetailsState => _bankDetailsState;

  set bankDetailsState(BankDetailsState value) {
    _bankDetailsState = value;
    if (bankDetailsState == BankDetailsState.prefilled) {
      onboardingNavigationBankDetails!.toggleAppBarVisibility(true);
    }
    update();
  }

  ///to fix the bank name search field non-editable for highTicketSize
  ///and editable for both lowTicket and CLP
  bool isHighTicketSize = false;

  late SequenceEngineModel sequenceEngineModel;

  bool ifscMasked = false;
  bool accountNumberMasked = false;
  bool confirmAccountNumberMasked = false;

  bool isBankNameFilled = true;
  bool isUserSalaried = false;

  late bool isReversePennyDropEnabled;

  List<InstalledAppModel> _installedUpiApps = [];

  List<InstalledAppModel> get installedUpiApps => _installedUpiApps;

  ///acc agg variables
  // bool bankDetailsPrefill = false;
  // String offerUpgradeType = "";
  late String OFFER_UPGRADE_TYPE_PERFIOS = "perfios";

  FocusNode accNumberFocusNode = FocusNode();
  bool showAccNo = false;

  BankDetailsRepository bankDetailsRepository = BankDetailsRepository();

  final String IFSC_ERROR_INVALID = "Enter a valid IFSC";
  final String IFSC_FIELD_ID = "ifsc_field_id";
  final String IFSC = "ifsc";

  final String VERIFICATION_TYPE_ID = "verification_type";
  final String INFO_TEXT_ID = "info_text";

  late final String ACCOUNT_NUMBER_TEXT_FIELD_ID =
      "ACCOUNT_NUMBER_TEXT_FIELD_ID";
  late final String CONFIRM_ACCOUNT_NUMBER_TEXT_FIELD_ID =
      "CONFIRM_ACCOUNT_NUMBER_TEXT_FIELD_ID";
  late final String IFSC_TEXT_FIELD_ID = "IFSC_TEXT_FIELD_ID";

  ///bank details widget variables
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccController = TextEditingController();
  TextEditingController addBankNameController = TextEditingController();

  // OnBoardingState getOnBoardingState = OnBoardingState.initialized;

  String bankName = "";

  //creating new variable to store bankName
  //cuz [bankName] variable will be reset before starting RPD
  String bankNameForToast = "";
  List<BanksModel> banks = [];
  BanksModel? userSelectedBank;

  PennyTestingType _userSelectedPennyTestingType = PennyTestingType.reverse;

  PennyTestingType get userSelectedPennyTestingType =>
      _userSelectedPennyTestingType;

  set userSelectedPennyTestingType(val) {
    _userSelectedPennyTestingType = val;
    update([INFO_TEXT_ID, VERIFICATION_TYPE_ID]);
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  final String SELECT_TEXT_KEY = "SELECT_TEXT_KEY";

  set isLoading(bool value) {
    _isLoading = value;
    update();
    if (onboardingNavigationBankDetails != null) {
      onboardingNavigationBankDetails!
          .toggleBack(isBackDisabled: isLoading || isButtonLoading);
    } else {
      onNavigationDetailsNull(BANK_DETAILS);
    }
  }

  String? _ifscErrorMessage;

  String? get ifscErrorMessage => _ifscErrorMessage;

  set ifscErrorMessage(String? value) {
    _ifscErrorMessage = value;
    update([IFSC_FIELD_ID]);
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update();
    if (onboardingNavigationBankDetails != null) {
      onboardingNavigationBankDetails!.toggleBack(
        isBackDisabled: isButtonLoading || isLoading,
      );
    } else {
      onNavigationDetailsNull(BANK_DETAILS);
    }
  }

  EmploymentType _employmentType = EmploymentType.none;

  EmploymentType get employmentType => _employmentType;

  set employmentType(EmploymentType value) {
    _employmentType = value;
    update([SELECT_TEXT_KEY]);
  }

  static const String BANK_DETAILS = 'bank_details';

  BankDetailsLogic({this.onboardingNavigationBankDetails});

  final bankDetailsFormKey = GlobalKey<FormState>();
  var isBankDetailsFormFilled = false;

  bool get isBankSelected {
    return bankNameController.text.isNotEmpty;
  }

  OnBoardingType onBoardingType = OnBoardingType.nonSurrogate;

  String lpc = "";

  @override
  onInit() {
    ifscNameController.text = "";
    accountNumberController.text = "";
    confirmAccController.text = "";
    bankNameController.text = "";
    accNumberFocusNode.addListener(() {
      if (accNumberFocusNode.hasFocus) {
        showAccNo = true;
        update();
      } else {
        showAccNo = false;
        update();
      }
    });
    addBankNameController.text = "";
    super.onInit();
  }

  onAfterLayout() async {
    _getPennyTestingBankDetails();
  }

  _getPennyTestingBankDetails() async {
    isLoading = true;
    PennyTestingBankModel model =
        await bankDetailsRepository.getPennyTestingBank();

    switch (model.apiResponse.state) {
      case ResponseState.success:
        _computePennyTestingBankDetails(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: BANK_DETAILS,
          retry: _getPennyTestingBankDetails,
        );
    }
  }

  String computeMessage() {
    if(LPCService.instance.isLpcCardTopUp){
      return "We will be proceeding with the following bank account to process your loan. Kindly verfiy the same for a secure deposit";
    } 
    return  "Verify your bank account details for\na secured deposit";
  }

  _computePennyTestingBankDetails(PennyTestingBankModel model) async {
    lpc = model.lpc;
    await _getAllInstalledUPIApps();
    await _checkAppParamAndComputeBankDetailsState();
    _checkEmploymentType(model);
    _getBankDetails(model);
  }

  void _checkEmploymentType(PennyTestingBankModel model) {
    switch (model.employmentType) {
      ///Salaried Index
      case "6":
        employmentType = EmploymentType.salaried;
        break;
      case "8":
        employmentType = EmploymentType.selfEmployed;
        break;
      default:
        employmentType = EmploymentType.none;
    }
  }

  Future _getBankDetails(PennyTestingBankModel model) async {
    isLoading = true;
    ifscMasked = true;
    accountNumberMasked = true;
    confirmAccountNumberMasked = true;
    isBankNameFilled = true;

    SupportedBanksModel requestModel =
        model.bankAccount != null && model.bankAccount!.vendor.isNotEmpty
            ? await OfferUpgradeRepository().getBanks(model.lpc)
            : await bankDetailsRepository.getBanks(model.lpc);

    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.bankDetailsLoaded);
        _computeSupportBankList(requestModel, model);
        break;
      default:
        isLoading = false;
        handleAPIError(
          requestModel.apiResponse,
          screenName: BANK_DETAILS,
          retry: () => _getBankDetails(model),
        );
    }
  }

  Future<void> _computeSupportBankList(
      SupportedBanksModel requestModel, PennyTestingBankModel model) async {
    banks = requestModel.supportedBanks;

    if (!model.isBankAccountAvailable) {
      isHighTicketSize = false;
      _setBankDetailsStateToForm();
      computeBankDetailsAppBarTitle();
      onboardingNavigationBankDetails?.toggleAppBarTitle(true);
      isLoading = false;
      return;
    }

    if (model.bankAccount == null) {
      handleAPIError(
        model.apiResponse
          ..exception = "Bank Details is null in penny testing Bank",
        screenName: BANK_DETAILS,
      );
      return;
    }

    if (model.bankAccount!.isAccountNumberMasked) {
      _prefillBankDetails(model.bankAccount!);
      _setBankDetialsFromBankList(model);
      _setBankDetailsStateToForm();
      computeBankDetailsAppBarTitle();
      onboardingNavigationBankDetails?.toggleAppBarTitle(true);
      isLoading = false;
      bankDetailsState = BankDetailsState.form;
      bankDetailsOnChange();
      return;
    }

    try {
      _prefillBankDetails(model.bankAccount!);
      _setBankDetialsFromBankList(model);

      bankDetailsState = BankDetailsState.prefilled;
      bankDetailsOnChange();
    } catch (e) {
      handleAPIError(
        model.apiResponse
          ..exception = "Bank Name doesn't match the supported bank list",
        screenName: BANK_DETAILS,
      );
    }

    computeBankDetailsAppBarTitle();
    onboardingNavigationBankDetails?.toggleAppBarTitle(true);
    isLoading = false;
  }

  void _setBankDetialsFromBankList(PennyTestingBankModel model) {
    userSelectedBank = banks.singleWhere((element) =>
        _computeBankName(element, model.bankAccount!).toLowerCase() ==
        model.bankAccount!.bankName.toString().toLowerCase());
  }

  void _prefillBankDetails(BankAccount bankAccount) {
    bankName = bankAccount.bankName;
    bankNameController.text = bankName;
    bankNameForToast = bankName;
    accountNumberController.text = bankAccount.accountNumber;
    if (!bankAccount.isAccountNumberMasked) {
      confirmAccController.text = bankAccount.accountNumber;
    }
    ifscNameController.text = bankAccount.ifscCode;
    ifscMasked = bankAccount.ifscCode.isEmpty;
    isHighTicketSize = true;
    accountNumberMasked = !bankAccount.isAccountNumberMasked;
    confirmAccountNumberMasked = bankAccount.isAccountNumberMasked;
    isBankNameFilled = true;
    showAccNo = true;
  }

  void _setBankDetailsStateToForm() {
    onboardingNavigationBankDetails?.toggleAppBarVisibility(true);
    onboardingNavigationBankDetails?.toggleAppBarTitle(true);
    bankDetailsState = BankDetailsState.form;
  }

  String _computeBankName(BanksModel element, BankAccount bankAccount) =>
      bankAccount.vendor.isEmpty
          ? element.perfiosBankName
          : bankAccount.vendor == OFFER_UPGRADE_TYPE_PERFIOS
              ? element.perfiosBankName
              : element.pirimidBankName;

  computeBankDetailsAppBarTitle() {
    switch (lpc) {
      case "UPL":
        onboardingNavigationBankDetails!.changeAppBarTitle(
            isHighTicketSize ? "Check your Bank Details" : "Add Bank Details",
            isHighTicketSize ? "Bank account" : "Link your bank account");
        break;
      case "CLP":
        onboardingNavigationBankDetails!
            .changeAppBarTitle("Bank Verification", "Link your bank account");
        break;
      case "SBL":
        onboardingNavigationBankDetails!
            .changeAppBarTitle("Check your Bank Details", "Bank account");
        break;
    }
  }

  String computeSelectText() {
    switch (employmentType) {
      case EmploymentType.salaried:
        return "Select Your Salary Bank";
      case EmploymentType.selfEmployed:
        return "Select Your Primary Bank";
      default:
        return "Select Your Bank";
    }
  }

  onVerificationTypeSelection(PennyTestingType type) {
    userSelectedPennyTestingType = type;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: getWebEngageEventName(type),
    );
  }

  String getWebEngageEventName(PennyTestingType type) {
    if (type == PennyTestingType.forward) {
      return WebEngageConstants.withBankDetailsSelected;
    } else {
      return WebEngageConstants.upiVerificationSelected;
    }
  }

  onManualContinue() async {
    if ((bankDetailsState == BankDetailsState.form &&
            bankDetailsFormKey.currentState!.validate() &&
            bankName.isNotEmpty &&
            userSelectedBank != null) ||
        bankDetailsState == BankDetailsState.prefilled) {
      await _initiatePennyTesting();
    } else {
      bankName.isEmpty ? isBankNameFilled = false : isBankNameFilled = true;
    }
  }

  _getSequenceEngineModel() {
    if (onboardingNavigationBankDetails != null) {
      sequenceEngineModel =
          onboardingNavigationBankDetails!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(BANK_DETAILS);
    }
  }

  Future<void> _getAllInstalledUPIApps() async {
    try {
      /// This intent url is used to fetch the upi apps present in phone not to make any real transaction
      const String dummyIntentUrl =
          "upi://pay?pa=test@ybl&pn=test&am=1.00&tr=1210374251828217008&tn=Getupiapps&cu=INR&mode=04";
      // "smsto:12346556";
      List nativeResponse =
          await NativeFunctions().getAllUPIAppsList(intentUrl: dummyIntentUrl);
      _computeUPIApps(appsList: nativeResponse);
    } catch (e) {
      Get.log("Error in _getAllUPIApps. Error:$e");
    }
  }

  onPennyTestingTypeContinue() async {
    sendWebEngageEventonContiue();
    if (_userSelectedPennyTestingType == PennyTestingType.reverse) {
      _showUPIApps();
    } else {
      onboardingNavigationBankDetails!.toggleAppBarVisibility(true);
      update();
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.addBankScreenLoaded);
    }
  }

  sendWebEngageEventonContiue() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.pennyTestingFinalSPSelected,
        attributeName: {
          "selected": _userSelectedPennyTestingType == PennyTestingType.reverse
              ? "upi"
              : "bank_details"
        });
    logPennyDropVerifyClicked();
  }

  _computeUPIApps({required List appsList}) {
    List<InstalledAppModel> apps = [];
    for (var element in appsList) {
      apps.add(InstalledAppModel.fromMap(element as Map));
    }
    _installedUpiApps = apps;

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.rpdPennyDropAppList,
        attributeName: {
          "upiApps": _installedUpiApps.map((app) => app.name).toList()
        });
  }

  _showUPIApps() {
    Get.bottomSheet(
      UpiAppsPopupWidget(),
      isDismissible: false,
      persistent: false,
    );
  }

  startReversePennyDrop(InstalledAppModel app) async {
    try {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.rpdChoosenApp,
          attributeName: {
            "selected_app": app.name,
          });

      CheckAppFormModel checkAppFormModel = await _initiatePennyTesting();
      if (checkAppFormModel.apiResponse.state != ResponseState.success) {
        return;
      }

      String upiIntentUrl =
          checkAppFormModel.responseBody["pennyTesting"]["upiLink"];

      isButtonLoading = true;

      Fluttertoast.showToast(
        msg: "Please complete the transaction via $bankNameForToast",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
      );

      NativeFunctions().startReversePennyDrop(
          packageName: app.packageName, intentUrl: upiIntentUrl);
    } catch (e) {
      Get.log("An exception occured ${e.toString()}");

      handleAPIError(
          ApiResponse(
            state: ResponseState.jsonParsingError,
            apiResponse: "",
            exception: e.toString(),
          ),
          screenName: BANK_DETAILS,
          retry: onPennyTestingTypeContinue);
    }
    isButtonLoading = false;
  }

  Map _getPostPennyTestingBody() {
    var body = {};
    if (userSelectedBank != null) {
      body.addAll(BanksModel.toJson(userSelectedBank!));
      if (_userSelectedPennyTestingType == PennyTestingType.forward) {
        body.addAll({
          "accountNumber": confirmAccController.text,
          "ifsc": ifscNameController.text,
          "serviceProvider": 1,
        });
      } else {
        body['serviceProvider'] = 2;
      }
    }
    return body;
  }

  ///Function to start penny testing flow
  Future<CheckAppFormModel> _initiatePennyTesting() async {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
    isButtonLoading = true;
    ifscErrorMessage = null;

    Map pennyTestingBody = _getPostPennyTestingBody();
    _getSequenceEngineModel();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: pennyTestingBody,
    );

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _computeIfscErrorMessage(checkAppFormModel);
        break;
      default:
        isButtonLoading = false;
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: BANK_DETAILS, retry: _initiatePennyTesting);
    }
    return checkAppFormModel;
  }

  void _computeIfscErrorMessage(CheckAppFormModel checkAppformModel) {
    if (checkAppformModel.error != null) {
      for (var element in checkAppformModel.error!.errorBody.fieldErrors) {
        if (element.fieldName == IFSC) {
          ifscErrorMessage = element.message;
        }
        isButtonLoading = false;
      }
    } else {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.pennyDropStart);
      _sendPennyTestingDataToOnBoarding(checkAppformModel);
      _onPennyPostSuccess(checkAppformModel);
      _sendWebengageEvents();
    }
  }

  _sendWebengageEvents() {
    if (userSelectedPennyTestingType == PennyTestingType.forward) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.accountNumberEntered);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.confirmAccountNumberEntered);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.ifscCodeEntered);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.addBankContinueCta);
    }
  }

  void _onPennyPostSuccess(CheckAppFormModel checkAppFormModel) {
    isButtonLoading = false;
    _resetFields();
    if (onboardingNavigationBankDetails != null &&
        checkAppFormModel.sequenceEngine != null) {
      onboardingNavigationBankDetails!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(BANK_DETAILS);
    }
  }

  void _sendPennyTestingDataToOnBoarding(CheckAppFormModel checkAppFormModel) {
    if (onboardingNavigationBankDetails != null) {
      DateTime currentTimestamp =
          checkAppFormModel.currentTimestamp ?? DateTime.now();

      DateTime? validUptoTime;

      if (userSelectedPennyTestingType == PennyTestingType.reverse) {
        try {
          String rawValidUptoTime =
              checkAppFormModel.responseBody["pennyTesting"]["validUpto"];

          validUptoTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
              .parse(rawValidUptoTime, true)
              .toLocal();
        } catch (e) {
          handleAPIError(checkAppFormModel.apiResponse,
              screenName: BANK_DETAILS, retry: _initiatePennyTesting);
        }
      }

      PennyTestingDataTransferModel pennyTestingDataTransferModel =
          PennyTestingDataTransferModel(
              pennyTestingType: userSelectedPennyTestingType,
              currentTime: currentTimestamp,
              validUpto: validUptoTime);
      onboardingNavigationBankDetails!
          .setPennyTestingData(pennyTestingDataTransferModel);
    }
  }

  ///this is to compare the user typed ifsc code is in
  ///match with user selected bank from supported banks
  bool isIFSCMatching() {
    if (ifscNameController.text.isNotEmpty &&
        userSelectedBank != null &&
        userSelectedBank!.ifscCode.isNotEmpty) {
      return isIfscValid(userSelectedBank!);
    }
    return false;
  }

  bool isIfscValid(BanksModel userSelectedBank) {
    int userSelectedBankLength = userSelectedBank.ifscCode.length;
    int typedIfscLength =
        min(userSelectedBankLength, ifscNameController.text.length);
    String maskedIfsc = userSelectedBank.ifscCode.substring(0, typedIfscLength);
    String typedIfsc = ifscNameController.text.substring(0, typedIfscLength);
    return typedIfsc.toLowerCase() == maskedIfsc.toLowerCase();
  }

  void bankDetailsOnChange() {
    isBankDetailsFormFilled = isFieldValid(validateIfscCode(
            ifscNameController.text,
            userSelectedBank: userSelectedBank,
            isIFSCMatching: isIFSCMatching())) &&
        ifscNameController.text.length == 11 &&
        isFieldValid(aaAccountNumberValidation(
            confirmAccController.text,
            accountNumberController)) &&
        isFieldValid(accountNumberValidator(
            accountNumberController.text)) &&
        _computeAccNoValidationForAAFlow() &&
        bankName.isNotEmpty &&
        userSelectedBank != null &&

        ///if ifsc code is null from supported banks
        ///the button should be enabled by validating
        ///user typed ifsc code
        (userSelectedBank!.ifscCode.isEmpty || isIFSCMatching());
    ifscErrorMessage = null;
    bankName.isEmpty ? isBankNameFilled = false : isBankNameFilled = true;
    update();
  }

  bool _computeAccNoValidationForAAFlow() {
    if (bankDetailsState == BankDetailsState.form) {
      return aaAccountNumberValidation(
              confirmAccController.text,
              accountNumberController) == null;
    }
    return accountNumberController.text == confirmAccController.text;
  }

  bool enableTextField(bool isMasked) {
    return !(!isMasked || isLoading || isButtonLoading);
  }

  bool isAccountNumberFieldEnabled() {
    return enableTextField(accountNumberMasked) && bankName.isNotEmpty;
  }

  bool isConfirmAccountNumberFieldEnabled() {
    return enableTextField(confirmAccountNumberMasked) && bankName.isNotEmpty;
  }

  bool isIFSCFieldEnabled() {
    return enableTextField(ifscMasked) && bankName.isNotEmpty;
  }

  Color configureButtonColor() {
    return isBankDetailsFormFilled ? activeButtonColor : inactiveButtonColor;
  }

  _resetFields() {
    bankName = "";
    userSelectedBank = null;
    banks = [];
    isBankDetailsFormFilled = false;
    ifscNameController.text = "";
    accountNumberController.text = "";
    confirmAccController.text = "";
    bankNameController.text = "";
  }

  void onEditBankNameWidget() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.bankEditButtonClicked);
    onTapBankNameWidget();
  }

  void onTapBankNameWidget() async {
    if (!isHighTicketSize) {
      Get.focusScope!.unfocus();
      var result = await Get.toNamed(Routes.SEARCH_SCREEN, arguments: {
        'search_type': SearchType.bankDetails,
        'bank_list': banks,
        'sub_title_for_bank': _computeBankSubtitle(),
      });
      if (result != null) {
        result as BanksModel;
        bankName = result.perfiosBankName;
        bankNameForToast = result.perfiosBankName;
        bankNameController.text = bankName;
        userSelectedBank = result;
        userSelectedBank != null
            ? AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: WebEngageConstants.bankSelected)
            : "";
        bankDetailsOnChange();
      }
    }
  }

  String _computeBankSubtitle() {
    return isUserSalaried
        ? "Choose the bank where salary is credited"
        : "Choose your Primary Bank Account";
  }

  computeBankCtaTitle() {
    if (userSelectedPennyTestingType == PennyTestingType.reverse) {
      return "Continue";
    }
    return "Verify";
  }

  computeInfoText() {
    if (userSelectedPennyTestingType == PennyTestingType.reverse) {
      return "To verify, complete a payment of ₹1 using your UPI-linked bank account, and it will be reversed within 24 hours.";
    }
    return "Verify using Bank account number and IFSC code.";
  }

  Future<void> _checkAppParamAndComputeBankDetailsState() async {
    AppParameterModel appParameterModel =
        await AppParameterRepository().getAppParameters();
    switch (appParameterModel.apiResponse.state) {
      case ResponseState.success:
        _computeBankDetailsState(appParameterModel);
        break;
      default:
        handleAPIError(appParameterModel.apiResponse,
            screenName: BANK_DETAILS,
            retry: _checkAppParamAndComputeBankDetailsState);
    }
  }

  void _computeBankDetailsState(AppParameterModel appParameterModel) async {
    isReversePennyDropEnabled = !appParameterModel.disableUpiBankTransfer;
    if (lpc != "CLP" ||
        !isReversePennyDropEnabled ||
        _installedUpiApps.isEmpty) {
      userSelectedPennyTestingType = PennyTestingType.forward;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.addBankScreenLoaded);
    } else {
      logPennyDropLoaded();
      userSelectedPennyTestingType = PennyTestingType.reverse;
      onboardingNavigationBankDetails!.toggleAppBarVisibility(true);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.pennyTestingChoiseScreenLoaded);
    }

    if (_installedUpiApps.isEmpty) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.rpdPennyDropSkipped);
    }
  }

  computeOnBackPress() {
    if (lpc == "CLP" &&
        (isReversePennyDropEnabled && _installedUpiApps.isNotEmpty)) {
      userSelectedPennyTestingType = PennyTestingType.reverse;
      onboardingNavigationBankDetails!.toggleAppBarVisibility(true);
      update();
    } else {
      Get.back();
    }
  }

  String computeBankDetailsHeading() {
    switch (lpc) {
      case "UPL":
      case "SBL":
        return "Verify Bank Details";
      case "CLP":
        return "Bank Details";
      default:
        return '';
    }
  }
}
