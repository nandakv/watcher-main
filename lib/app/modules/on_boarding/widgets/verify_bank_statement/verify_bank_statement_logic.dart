import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/data/repository/on_boarding_repository/verify_bank_statement_repository.dart';
import 'package:privo/app/models/bank_details_base.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_navigation.dart';

import '../../../../../flavors.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/blue_button.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/perfios_process_status_response_model.dart';
import '../../../../models/perfios_response_model.dart';
import '../../../../models/supported_banks_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_dialogs.dart';
import '../../on_boarding_logic.dart';

class VerifyBankStatementLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingVerifyBankStatementNavigation?
      onBoardingVerifyBankStatementNavigation;

  final verifyBankStatementRepository = VerifyBankStatementRepository();

  ///loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    if (onBoardingVerifyBankStatementNavigation != null) {
      onBoardingVerifyBankStatementNavigation!
          .toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(VERIFY_BANK_STATEMENT);
    }
  }

  late PreApprovalOfferModel initialResponseModel;

  static const String VERIFY_BANK_STATEMENT = 'verify_bank';

  VerifyBankStatementLogic({this.onBoardingVerifyBankStatementNavigation});

  var isVerifyBankStatementFilled = false;

  List<String> bankNames = [];
  bool? isPerfiosFailed = false;
  var getBankNames = OnBoardingState.loading;
  var perfiosState = OnBoardingState.loading;
  late BanksModel selectedBank;
  FocusNode bankNameFocus = FocusNode();
  List<BanksModel> banks = [];

  var isBankStatementLoading = false;

  //BankStatement Selector index
  var bankSelectorIndex = 0;

  get getbankSelectorIndex => bankSelectorIndex;
  var isBankSelectorEditing = false;

  TextEditingController bankNameController = TextEditingController();

  void verifyBankStatementChange() {
    if (bankNameController.text.isNotEmpty) {
      isVerifyBankStatementFilled = true;
      update(['top_section']);
    }
  }

  setbankSelectorIndex(var value) {
    if (isLoading == true) {
      Get.snackbar("Please wait", "Loading");
    } else {
      bankSelectorIndex = value;
      update(['net_banking_ic', 'upload_pdf_ic']);
      update();
    }
  }

  onVerifyBankStatementContinueTapped() {
    if (!isVerifyBankStatementFilled) {
      if (bankNameController.text.isNotEmpty) {
        // postDataToServer(4);
      }
    } else {
      startPerfiosModel();
    }
  }

  ///Gets the list of supported banks by both perfios and razorpay (emandate)
  getBanks() async {
    getBankNames = OnBoardingState.loading;
    update(['bank_names']);
    SupportedBanksModel requestModel =
        await VerifyBankStatementRepository().getBanks();

    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        banks = requestModel.supportedBanks;
        for (var element in banks) {
          bankNames.add(element.perfiosBankName);
        }
        await checkInitialOffer();
        break;
      default:
        isBankStatementLoading = false;
        getBankNames = OnBoardingState.error;
        handleAPIError(requestModel.apiResponse,
            screenName: VERIFY_BANK_STATEMENT, retry: getBanks);
    }
    update(['bank_names']);
  }

  ///Initiates the perfios check and starts the process for perfios via netbanking or the emandate
  startPerfiosModel() async {
    perfiosState = OnBoardingState.loading;
    isLoading = true;
    isBankStatementLoading = true;
    update(['top_section']);
    // String emailId = await AppAuthProvider.userEmail;
    PerfiosResponseModel requestModel =
        await verifyBankStatementRepository.startPerfiosProcess(body: {
      // "emailId": emailId,
      "appId": await AppAuthProvider.appFormID,
      "partnerId": "CS",
      "loanProductCode": "CLP",
      "institutionId": F.appFlavor == Flavor.prod
          ? selectedBank.perfiosInstitutionId
          : bankSelectorIndex == 1
              ? selectedBank.perfiosInstitutionId
              : 998,
      "method_banking": bankSelectorIndex == 1 ? "statement" : "netbanking",
      "returnUrl":
          "https://www.publicdomainpictures.net/pictures/30000/velka/plain-white-background.jpg",
      "bankName": bankNameController.text
    });
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        await onPerfiosResponseSuccess(
            payLoad: requestModel.payload, signature: requestModel.signature);
        break;
      default:
        isPerfiosFailed = true;
        isBankStatementLoading = false;
        isLoading = false;
        getBankNames = OnBoardingState.error;
        handleAPIError(requestModel.apiResponse,
            screenName: VERIFY_BANK_STATEMENT, retry: startPerfiosModel);
    }
  }

  onPerfiosResponseSuccess(
      {required String payLoad, required String signature}) async {
    String url = """<html>
    <body onload='document.autoform.submit();'>
        <form name='autoform' method='post' action='https://demo.perfios.com/KuberaVault/insights/start'>
            <input type='hidden' name='payload' value='${payLoad}'>
            <input type='hidden' name='signature' value='${signature}'>
        </form>
    </body>
</html>""";
    // bool? result = await NativeFunctions().openWebView(url: url, callBackUrl: "https://www.publicdomainpictures.net/pictures/30000/velka/plain-white-background.jpg");

    var result = await Get.toNamed(Routes.PERFIOS_WEB_VIEW,
        arguments: [payLoad, signature]);
    Get.log("Perfios web view result = $result");
    if (result != null && result) {
      isLoading = true;
      isBankStatementLoading = true;
      // currentIndex = 5;
      // update(['body']);
      checkPerfiosStatus();
    } else {
      isPerfiosFailed = true;
      isBankStatementLoading = false;
      bankNameController.clear();
      bankSelectorIndex = 0;
      isVerifyBankStatementFilled = false;
      isBankSelectorEditing = false;
      isLoading = false;
      update(['top_section']);
    }
  }

  ///Check perfios status after perfios request has been sent
  checkPerfiosStatus() async {
    PerfiosProcessStatus requestModel =
        await verifyBankStatementRepository.getPerfiosReportStatus();
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        await onPerfiosStatusSuccess(requestModel);
        break;
      default:
        isPerfiosFailed = true;
        isBankStatementLoading = false;
        isLoading = false;
        getBankNames = OnBoardingState.error;
        update(['top_section']);
        handleAPIError(requestModel.apiResponse,
            screenName: VERIFY_BANK_STATEMENT, retry: checkPerfiosStatus);
    }
  }

  Future<void> onPerfiosStatusSuccess(PerfiosProcessStatus requestModel) async {
    if (requestModel.status.contains("SUCCESS")) {
      await _navigateUserToBankDetailsPage();
      isBankStatementLoading = false;
      isLoading = false;
      update(['top_section']);
    } else if (requestModel.status.contains("PENDING")) {
      await Future.delayed(const Duration(seconds: 2));
      checkPerfiosStatus();
    } else {
      isPerfiosFailed = true;
      isBankStatementLoading = false;
      bankNameController.clear();
      bankSelectorIndex = 0;
      isVerifyBankStatementFilled = false;
      isBankSelectorEditing = false;
      isLoading = false;
      update(['top_section']);
    }
  }

  ///always take the user to bankDetails page
  _navigateUserToBankDetailsPage() async {
    await Future.delayed(const Duration(seconds: 6));
    if (onBoardingVerifyBankStatementNavigation != null) {
      _resetFields();
      onBoardingVerifyBankStatementNavigation!.navigateToBankDetails();
    } else {
      onNavigationDetailsNull(VERIFY_BANK_STATEMENT);
    }
  }

  checkInitialOffer() async {
    Get.log(await AppAuthProvider.appFormID);
    isLoading = true;
    PreApprovalOfferModel requestModel =
        await verifyBankStatementRepository.checkInitialOfferPost();
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        _initialOfferOnSuccess(requestModel);
        break;
      default:
        isPerfiosFailed = true;
        isBankStatementLoading = false;
        isLoading = false;
        getBankNames = OnBoardingState.error;
        update(['top_section']);
        handleAPIError(requestModel.apiResponse,
            screenName: VERIFY_BANK_STATEMENT, retry: checkInitialOffer);
    }
  }

  _initialOfferOnSuccess(PreApprovalOfferModel initialOfferModel) {
    if (initialOfferModel.appFormRejectionModel.isRejected) {
      isLoading = false;
      onBoardingVerifyBankStatementNavigation!
          .onAppFormRejected(model: initialOfferModel.appFormRejectionModel);
    } else {
      _checkForOfferSectionNull(initialOfferModel);
    }
  }

  _checkForOfferSectionNull(PreApprovalOfferModel initialOfferModel) {
    if (initialOfferModel.offerSection != null &&
        initialOfferModel.offerSection!.interest != 0) {
      initialResponseModel = initialOfferModel;
      isBankStatementLoading = false;
      isLoading = false;
      _toggleSuccessState();
      update(['top_section', 'bank_names']);
    } else {
      isBankStatementLoading = false;
      isLoading = false;
      getBankNames = OnBoardingState.error;
      update(['top_section', 'bank_names']);
    }
  }

  _toggleSuccessState() {
    getBankNames = OnBoardingState.success;
    isBankStatementLoading = false;
    isLoading = false;
    update(['top_section', 'bank_names']);
  }

  bool onVerifyBankStatementBackPressed() {
    if (bankNameController.text.isNotEmpty) {
      bankSelectorIndex = 0;
      bankNameController.text = "";
      isVerifyBankStatementFilled = false;
      isBankSelectorEditing = false;
      update(['top_section']);
      return false;
    } else {
      return true;
    }
  }

  ///logic to display initial and final offer
  ///the amount should be in (* lakh) if limit amount is above 100000
  ///else it should be in comma separated thousand
  String getIOFOAmount(double limitAmount) {
    return "₹ ${NumberFormat.currency(
      symbol: '',
      locale: "HI",
      decimalDigits: 0,
    ).format(limitAmount.toInt())}";
  }

  void onAfterFirstLayout() {
    getBanks();
  }

  configureWidgetAlignment() {
    if (selectedBank != null) {
      bool data =
          selectedBank.statementSupported || selectedBank.netbankingSupported;
      return data ? MainAxisAlignment.center : MainAxisAlignment.spaceAround;
    }
  }

  onSurrogateButtonPressed() {
    if (onBoardingVerifyBankStatementNavigation != null) {
      onBoardingVerifyBankStatementNavigation!.navigateToBankDetails();
    } else {
      onNavigationDetailsNull(VERIFY_BANK_STATEMENT);
    }
  }

  _resetFields() {
    isPerfiosFailed = true;
    isBankStatementLoading = false;
    bankNameController.clear();
    bankSelectorIndex = 0;
    isVerifyBankStatementFilled = false;
    isBankSelectorEditing = false;
    isLoading = false;
    update(['top_section']);
  }
}
