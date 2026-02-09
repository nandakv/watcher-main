import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/emi_calculator/model/lpc_calculator_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/cross_sell_breakdown_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/browser_final_offer_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/final_offer_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/pldsa_offer_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/top_up_offer_widget.dart';
import 'package:privo/app/services/location_service/location_service.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/preprocessor_service/preprocessor_service.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/utils/firebase_constants.dart';
import 'package:privo/res.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../common_widgets/offer_banner_model.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../data/repository/app_parameter_repository.dart';
import '../../../../data/repository/on_boarding_repository/offer_repository.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../mixin/location_service_mixin.dart';
import '../../../../models/app_parameter_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/info_text_model.dart';
import '../../../../services/preprocessor_service/customer_device_details_service.dart';
import '../../../../utils/app_functions.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/app_form_mixin.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../../model/privo_app_bar_model.dart';
import '../privo_app_bar/privo_app_bar.dart';
import 'offer_navigation.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/pre_approval_offer_model.dart';
import '../../../../utils/apps_flyer_constants.dart';
import 'offer_ui_constant.dart';

enum ConsentState { optedIn, optedOut, notEligible }

enum KfsScreenState {
  offer,
  loading,
  topUpLoanBreakDown,
  consentOne,
  consentTwo,
}

enum OfferServiceType { insurance, healthcare, insuranceHealthcare, none }

class OfferLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        LocationServiceMixin,
        AppAnalyticsMixin,
        OfferAnalyticsMixin {
  OnBoardingOfferNavigation? onBoardingOfferNavigation;

  OfferLogic({this.onBoardingOfferNavigation});

  static const String OFFER_SCREEN = 'offer_screen';
  final String INSURANCE_CHECKBOX_KEY = 'insurance_check_box_key';
  final String HEALTHCARE_CHECKBOX_KEY = 'healthcare_check_box_key';
  final String INSURANCE_CHECKBOX = 'insurance_button';
  final String HEALTHCARE_CHECKBOX = 'healthcare_button';
  final String NET_DISBURSAL_ID = 'netDisbursalId';
  final String BUTTON_ID = 'button';

  String pdfDownloadURL = "";
  final String fileName = "FINAL_OFFER";

  String _consentPageTitle = "";

  String get consentPageTitle => _consentPageTitle;

  set consentPageTitle(String value) {
    _consentPageTitle = value;
  }

  LPCCardType lpcCardType =
      LPCService.instance.activeCard?.lpcCardType ?? LPCCardType.loan;

  OfferRepository offerRepository = OfferRepository();
  OfferServiceType offerServiceType = OfferServiceType.insurance;

  ConsentState _insuranceState = ConsentState.optedIn;

  ConsentState get insuranceState => _insuranceState;
  late LoanProductCode loanProductCode;

  String firstName = "";
  late List<InfoTextModel> infoTexts = [];

  set insuranceState(ConsentState value) {
    _insuranceState = value;
    update([
      INSURANCE_CHECKBOX,
      NET_DISBURSAL_ID,
      INSURANCE_CHECKBOX_KEY,
    ]);
  }

  ConsentState _healthcareState = ConsentState.optedIn;

  ConsentState get healthcareState => _healthcareState;

  set healthcareState(ConsentState value) {
    _healthcareState = value;
    update([
      HEALTHCARE_CHECKBOX,
      NET_DISBURSAL_ID,
      HEALTHCARE_CHECKBOX_KEY,
    ]);
  }

  KfsScreenState _kfsScreenState = KfsScreenState.offer;

  KfsScreenState get kfsScreenState => _kfsScreenState;

  set kfsScreenState(KfsScreenState value) {
    _kfsScreenState = value;
    update();
  }

  LocationService? locationService;
  int _webEngageLocationCounter = 0;

  late SequenceEngineModel sequenceEngineModel;

  ///error variable
  bool _isError = false;

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    update();
  }

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (onBoardingOfferNavigation != null) {
      onBoardingOfferNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID, INSURANCE_CHECKBOX, HEALTHCARE_CHECKBOX]);
    if (onBoardingOfferNavigation != null) {
      onBoardingOfferNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }

  bool _consentCheckBoxValue = false;

  bool get consentCheckBoxValue => _consentCheckBoxValue;

  set consentCheckBoxValue(bool value) {
    _consentCheckBoxValue = value;
    update(["checkBox", "button"]);
  }

  bool _toggleInsuranceChecked = true;

  bool get toggleInsuranceChecked => _toggleInsuranceChecked;

  set toggleInsuranceChecked(bool value) {
    _toggleInsuranceChecked = value;
    update([INSURANCE_CHECKBOX_KEY, INSURANCE_CHECKBOX, NET_DISBURSAL_ID]);
  }

  ///healthcare toggle
  bool _toggleHealthcareChecked = true;

  bool get toggleHealthcareChecked => _toggleHealthcareChecked;

  set toggleHealthcareChecked(bool value) {
    _toggleHealthcareChecked = value;
    update([HEALTHCARE_CHECKBOX_KEY, HEALTHCARE_CHECKBOX, NET_DISBURSAL_ID]);
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }

  void onPageSwiped(int index) {
    Get.log("onIndexChanged -> index = $index");
    currentIndex = index;
  }

  bool isLastPage() {
    return currentIndex == offerBannerList.length - 1;
  }

  final SwiperController swiperController = SwiperController();

  List<OfferBannerModel> offerBannerList = [
    OfferBannerModel(
        img: Res.borrowBanner, title: 'Interest on borrowed funds only'),
    OfferBannerModel(
        img: Res.spendBanner, title: 'Enjoy the freedom to spend on anything'),
    OfferBannerModel(
        img: Res.repayBanner, title: 'Withdraw funds anytime, anywhere'),
    OfferBannerModel(
        img: Res.reuseBanner, title: 'Embrace the Freedom of Flexible Tenure'),
  ];

  var isChecked = false;

  double netDisbursalAmountValue = 0;
  double finalNetDisbursalAmount = 0;

  ///toggles the check box value to true or false
  toggleIsChecked(bool val) {
    isChecked = val;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.kycConsentCheck,
        attributeName: {'Status': isChecked ? true : false});
    update([BUTTON_ID]);
  }

  late PreApprovalOfferModel responseModel;

  late PlatformType platformType;

  InsuranceDetails? insuranceDetails;
  VasDetails? vasDetails;

  ///Checks final offer in the final offer screen
  afterLayout() async {
    onBoardingOfferNavigation?.toggleAppBarVisibility(false);
    _computeLoanProductCode();
  }

  _computeLoanProductCode() async {
    isPageLoading = true;
    getAppForm(
      onSuccess: _onAppFormApiSuccess,
      onApiError: _onAppFormApiError,
      onRejected: _onAppFormRejectionNavigation,
    );
  }

  _onAppFormApiSuccess(AppForm appForm) {
    loanProductCode = appForm.loanProductCode;
    platformType = appForm.platformType;
    firstName = appForm.responseBody['applicant']?['firstName'] ?? "";
    _getSequenceEngineModel();
    getInfoTextList();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.offerDetailsLoaded);

    AppAnalytics.trackWebEngageUser(
        userAttributeName: "AppformStatus",
        userAttributeValue: "Offer Approved");
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    isPageLoading = false;
    handleAPIError(
      apiResponse,
      screenName: OFFER_SCREEN,
      retry: _computeLoanProductCode,
    );
  }

  void _onAppFormRejectionNavigation(CheckAppFormModel checkAppFormModel) {
    isPageLoading = false;
    if (onBoardingOfferNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycRejected);
      onBoardingOfferNavigation!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }

  _checkUplOfferDetails() async {
    isPageLoading = true;
    PreApprovalOfferModel preApprovalOfferModel =
        await offerRepository.fetchOfferDetails();
    switch (preApprovalOfferModel.apiResponse.state) {
      case ResponseState.success:
        computeSanctionLetterInfoSnackBar();
        responseModel = preApprovalOfferModel;
        _triggerWebEngageEventOnFetchOfferSuccess();
        insuranceDetails = responseModel.insuranceDetails;

        ///vasDetail is a list , currently we are only catering to 0th element .
        vasDetails = responseModel.vasDetailsList?[0];

        netDisbursalAmountValue =
            double.parse(responseModel.offerSection!.netDisbursalAmount);
        computeNetDisbursalAmount();
        _checkIfAppFormRejected();
        break;
      default:
        handleAPIError(preApprovalOfferModel.apiResponse,
            screenName: OFFER_SCREEN, retry: _checkUplOfferDetails);
    }
  }

  void _triggerWebEngageEventOnFetchOfferSuccess() {
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "ApprovedLimit",
        userAttributeValue: responseModel.offerSection!.limitAmount);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "Processing Fee",
        attributeName: {"value": responseModel.offerSection!.processingFee});
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "roi",
        attributeName: {"value": responseModel.offerSection!.interest});
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "RateOfInterest",
        userAttributeValue: responseModel.offerSection!.interest);
  }

  //compute the insurance enum
  computeInsuranceConsent(PreApprovalOfferModel preApprovalOfferModel) {
    if (insuranceDetails != null) {
      insuranceState =
          toggleInsuranceChecked ? ConsentState.optedIn : ConsentState.optedOut;
    } else {
      insuranceState = ConsentState.notEligible;
    }
    update([INSURANCE_CHECKBOX_KEY, INSURANCE_CHECKBOX, NET_DISBURSAL_ID]);
  }

  ///compute Healthcare enum
  computeHealthCareConsent(PreApprovalOfferModel preApprovalOfferModel) {
    if (vasDetails != null) {
      healthcareState = toggleHealthcareChecked
          ? ConsentState.optedIn
          : ConsentState.optedOut;
    } else {
      healthcareState = ConsentState.notEligible;
    }
    update([HEALTHCARE_CHECKBOX_KEY, HEALTHCARE_CHECKBOX, NET_DISBURSAL_ID]);
  }

  void onChangeInsuranceCheckBox(bool? boolValue) {
    if (boolValue != null) {
      toggleInsuranceChecked = boolValue;
      insuranceState =
          toggleInsuranceChecked ? ConsentState.optedIn : ConsentState.optedOut;
      insuranceDetails?.isChecked = toggleInsuranceChecked;
      computeNetDisbursalAmount();
    }
  }

  void onChangeHealthcareCheckBox(bool? boolValue) {
    if (boolValue != null) {
      toggleHealthcareChecked = boolValue;
      healthcareState = toggleHealthcareChecked
          ? ConsentState.optedIn
          : ConsentState.optedOut;

      vasDetails?.isChecked = toggleHealthcareChecked;
      computeNetDisbursalAmount();
    }
  }

  computeNetDisbursalAmount() {
    double insuranceAmount = insuranceDetails?.computeNetDisbursalAmount() ?? 0;
    double healthAmount = vasDetails?.computeNetDisbursalAmount() ?? 0;
    finalNetDisbursalAmount = netDisbursalAmountValue -
        computeOutStandingAmount() -
        (insuranceAmount + healthAmount);
    update([INSURANCE_CHECKBOX, HEALTHCARE_CHECKBOX, NET_DISBURSAL_ID]);
  }

  computeOutStandingAmount() {
    switch (lpcCardType) {
      case LPCCardType.loan:
        return 0;
      case LPCCardType.topUp:
        double outStandingAmount =
            responseModel.offerSection?.outStandingBalance ?? 0;
        return outStandingAmount;
    }
  }

  consentEligibleState(ConsentState consentState) {
    switch (consentState) {
      case ConsentState.optedIn:
        return "optedIn";
      case ConsentState.optedOut:
        return "optedOut";
      case ConsentState.notEligible:
        return "notEligible";
    }
  }

  void _showSanctionLetterInfoSnackBar() {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                Res.information_svg,
                height: 12,
                color: const Color(0xff161742),
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Text(
                  'You will receive the sanction letter on your e-mail and SMS',
                  style: TextStyle(
                    color: Color(0xff161742),
                    fontSize: 10,
                    letterSpacing: 0.16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xffFFF3EB),
      ),
    );
  }

  void _checkIfAppFormRejected() {
    if (responseModel.appFormRejectionModel.isRejected) {
      isButtonLoading = false;
      onBoardingOfferNavigation!
          .onAppFormRejected(model: responseModel.appFormRejectionModel);
    } else {
      _checkForOfferSectionNull();
    }
  }

  _checkForOfferSectionNull() async {
    if (responseModel.offerSection != null) {
      computeInsuranceConsent(responseModel);
      computeHealthCareConsent(responseModel);
      isPageLoading = false;
    } else {
      isPageLoading = false;
      handleAPIError(
          ApiResponse(
            apiResponse: "",
            state: ResponseState.jsonParsingError,
            exception: "Offersection null",
          ),
          screenName: OFFER_SCREEN);
    }
  }

  onKycProceed({OfferServiceType? offerServiceType}) async {
    isButtonLoading = true;
    onVasTickedBl({
      "insurance": insuranceDetails?.isChecked,
      "docOnline": vasDetails?.isChecked
    });
    String locationData = await AppAuthProvider.getUserLocationData;
    if (locationData.isNotEmpty || loanProductCode != LoanProductCode.clp) {
      CustomerDeviceDetailsService().postCustomerDeviceDetails();
      updateSanctionLetterConsentData("accept");
    } else {
      Get.closeAllSnackbars();
      _fetchLocation();
    }
  }

  _fetchLocation() async {
    await _initLocation();
    locationService?.fetchLocation();
  }

  _initLocation() async {
    if (locationService == null) {
      AppParameterModel appParameterModel =
          await AppParameterRepository().getAppParameters();
      switch (appParameterModel.apiResponse.state) {
        case ResponseState.success:
          _onAppParamFetchSuccess(appParameterModel);
          break;
        default:
          handleAPIError(
            appParameterModel.apiResponse,
            screenName: OFFER_SCREEN,
            retry: _initLocation,
          );
      }
    }
  }

  void _onAppParamFetchSuccess(AppParameterModel appParameterModel) {
    int locationRetryTime = appParameterModel.locationRetryTimer;
    int locationRetryCount = appParameterModel.locationRetryCount;
    locationService = LocationService(
        onLocationFetchSuccessful: _onLocationFetchSuccessFull,
        defaultLocationTimer: locationRetryTime,
        locationRetryCount: locationRetryCount,
        loanProductCode: loanProductCode,
        onLocationStatus: _onLocationStatus);
  }

  _onLocationFetchSuccessFull() async {
    _webEngageLocationCounter += 1;
    if (loanProductCode == LoanProductCode.clp) {
      updateSanctionLetterConsentData("accept");
    }
    CustomerDeviceDetailsService().postCustomerDeviceDetails();
    disposeLocationServiceOnRetry();
    locationService = null;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName:
          "${WebEngageConstants.offerLocationSuccessful} - $_webEngageLocationCounter",
    );
  }

  _onLocationStatus(
    LocationStatusType statusType,
  ) {
    switch (statusType) {
      case LocationStatusType.locationNotFound:
        Fluttertoast.showToast(
            msg: "Didn't get location data, Please try again");
        isButtonLoading = false;
        break;
      case LocationStatusType.locationDisabled:
        _onLocationDisabled();
        break;

      case LocationStatusType.retry:
        isButtonLoading = false;
        disposeLocationServiceOnRetry();
        _fetchLocation();
        break;

      case LocationStatusType.noPermission:
        _computeOnNoPermission();
        break;

      default:
    }
    locationService?.disposeLocationService();
  }

  void _computeOnNoPermission() {
    isButtonLoading = false;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.locationStatus,
        attributeName: {'reason': 'noPermission'});
    if (loanProductCode == LoanProductCode.clp) {
      onPermissionNotGranted();
    } else {
      _onLocationFetchSuccessFull();
    }
  }

  void _onLocationDisabled() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.locationStatus,
        attributeName: {'reason': 'disabled'});
    if (loanProductCode == LoanProductCode.clp) {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Please enable location services from quick settings",
        "to help us serve you better",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      isButtonLoading = false;
    } else {
      _onLocationFetchSuccessFull();
    }
  }

  disposeLocationServiceOnRetry() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.offerLocationDisposeOnRetry,
    );
    locationService?.disposeLocationService();
  }

  updateSanctionLetterConsentData(String actionType) async {
    isButtonLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.kfsFoConsentGiven);
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycStarted);
    await AppAnalytics.trackWebEngageUser(
        userAttributeName: "Offer approved date",
        userAttributeValue: AppAnalytics.dateTimeNow());
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.offerDetailsContinueCTA);
    if (onBoardingOfferNavigation != null) {
      _getSequenceEngineModel();
      CheckAppFormModel checkAppFormModel =
          await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
        body: _computeApiRequestBody(
          loanProductCode,
          actionType,

          ///for non clp, need to send only addons
          onlyAddons: true,
        ),
      );
      switch (checkAppFormModel.apiResponse.state) {
        case ResponseState.success:
          isButtonLoading = false;
          if (actionType == "accept") {
            _webEngageEventOnOfferAccept();
          }
          _onConsentSuccess(checkAppFormModel);
          break;
        default:
          isButtonLoading = false;
          handleAPIError(
            checkAppFormModel.apiResponse,
            screenName: OFFER_SCREEN,
            retry: () => updateSanctionLetterConsentData(actionType),
          );
      }
    }
  }

  void _webEngageEventOnOfferAccept() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.offerDetailsCompleted);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.creditLineSanctioned);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.sanctionedLineAccepted);
    AppAnalytics.logFirebaseEvents(eventName: FirebaseConstants.foSuccess);
  }

  Future getInfoTextList() async {
    isPageLoading = true;
    InfoTextListModel infoTextsData = await offerRepository.fetchInfoText();
    switch (infoTextsData.apiResponse.state) {
      case ResponseState.success:
        infoTexts = infoTextsData.infoTexts;
        _checkUplOfferDetails();
        break;
      default:
        handleAPIError(infoTextsData.apiResponse,
            screenName: OFFER_SCREEN, retry: getInfoTextList);
    }
  }

  void _onConsentSuccess(CheckAppFormModel checkAppFormModel) {
    if (onBoardingOfferNavigation != null) {
      _toggleAppBar(appBarStatus: true);
      onBoardingOfferNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }

  Map<LoanProductCode, Widget> offerWidgetData() {
    return {
      LoanProductCode.sbd: _computeSbdOfferPage(),
      LoanProductCode.sbl: PLDSAOfferWidget(),
      LoanProductCode.upl: PLDSAOfferWidget(),
      LoanProductCode.clp: FinalOfferWidget(),
    };
  }

  _computeSbdOfferPage() {
    switch (lpcCardType) {
      case LPCCardType.loan:
        return PLDSAOfferWidget();
      case LPCCardType.topUp:
        return TopUpOfferWidget();
    }
  }

  computeOfferWidget() {
    if (platformType == PlatformType.web) {
      return BrowserFinalOfferScreen();
    }
    return offerWidgetData()[loanProductCode];
  }

  String computeButtonTitle() {
    switch (loanProductCode) {
      case LoanProductCode.unknown:
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
        return "Continue to KYC";
      case LoanProductCode.sbd:
        return "Continue";
      case LoanProductCode.clp:
        return offerButtonText;
      default:
        return '';
    }
  }

  computeSanctionLetterInfoSnackBar() {
    switch (loanProductCode) {
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
        break;
      case LoanProductCode.clp:
        _showSanctionLetterInfoSnackBar();
        break;
    }
  }

  Map<LoanProductCode, TextStyle> bpiAprNoteData() {
    return {
      LoanProductCode.sbl: briTextStyle(fontWeight: FontWeight.w300),
      LoanProductCode.upl: briTextStyle(fontWeight: FontWeight.w300),
      LoanProductCode.clp: const TextStyle(
          fontWeight: FontWeight.w300, color: Color(0xff727272)),
    };
  }

  computeBriAprNote() {
    return bpiAprNoteData()[loanProductCode];
  }

  TextStyle briTextStyle({FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        color: const Color(0xff161742),
        fontSize: 11,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  Map<LoanProductCode, String> offerLoanProductCodeData() {
    return {
      LoanProductCode.sbl: "SBL",
      LoanProductCode.upl: "UPL",
      LoanProductCode.clp: "CLP",
    };
  }

  String computeLoanProductCode() {
    return offerLoanProductCodeData()[loanProductCode].toString();
  }

  Map<LoanProductCode, String> offerLoanProductMapData() {
    return {
      LoanProductCode.sbl: "Setup Business Loan",
      LoanProductCode.upl: "Setup Personal Loan",
      LoanProductCode.clp: "Setup Credit Line",
    };
  }

  getAppBarTitle() {
    return offerLoanProductMapData()[loanProductCode];
  }

  onOfferContinueButtonPress() {
    switch (loanProductCode) {
      case LoanProductCode.clp:
        onKycProceed();
        break;
      case LoanProductCode.upl:
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        if (LPCService.instance.isLpcCardTopUp) {
          _toggleAppBar(appBarStatus: true);
          kfsScreenState = KfsScreenState.topUpLoanBreakDown;
        } else {
          callRecordConsent();
        }
        break;
    }
  }

  callRecordConsent() async {
    isButtonLoading = true;
    CheckAppFormModel model = await OfferRepository().recordConsent(
      _computeApiRequestBody(loanProductCode, ""),
    );
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isButtonLoading = false;
        computeOfferService();
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: OFFER_SCREEN,
          retry: callRecordConsent,
        );
    }
  }

  void _toggleAppBar({required bool appBarStatus}) {
    if (onBoardingOfferNavigation != null) {
      onBoardingOfferNavigation!.toggleAppBarVisibility(appBarStatus);
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }


  computeOfferService(){
    bool isInsuranceChecked = insuranceDetails?.isChecked ?? false;
    bool isHealthCareChecked = vasDetails?.isChecked ?? false;
    offerServiceType = getOfferServiceType[
            "isInsuranceChecked == $isInsuranceChecked,isHealthCareChecked == $isHealthCareChecked"] ??
        OfferServiceType.none;
    switch (offerServiceType) {
      case OfferServiceType.insuranceHealthcare:
      case OfferServiceType.insurance:
      case OfferServiceType.healthcare:
      _toggleAppBar(appBarStatus: true);
      consentPageTitle = "Consent 1 of 2";
        kfsScreenState = KfsScreenState.consentOne;
        break;
      default:
        onContinuePressed();
        break;
    }
  }

  Map<String, OfferServiceType> get getOfferServiceType => {
        "isInsuranceChecked == true,isHealthCareChecked == true":
            OfferServiceType.insuranceHealthcare,
        "isInsuranceChecked == true,isHealthCareChecked == false":
            OfferServiceType.insurance,
        "isInsuranceChecked == false,isHealthCareChecked == true":
            OfferServiceType.healthcare,
        "isInsuranceChecked == false,isHealthCareChecked == false":
            OfferServiceType.none
      };

  onOfferKnowMorePress(OfferServiceType offerServiceType) {
    switch (loanProductCode) {
      case LoanProductCode.clp:
        break;
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
      case LoanProductCode.sbd:
        _computeKnowMoreBottomSheet(offerServiceType);
        break;
    }
  }

  _computeKnowMoreBottomSheet(OfferServiceType offerServiceType) {
    switch (offerServiceType) {
      case OfferServiceType.insurance:
        _showBottomSheet(
          child: insuranceDetails!.computeKnowMoreBottomSheetWidget(),
          onBottomSheetAgree: () {},
        );
        break;
      case OfferServiceType.healthcare:
        _showBottomSheet(
          child: vasDetails!.computeKnowMoreBottomSheetWidget(),
          onBottomSheetAgree: () {},
        );
        break;
    }
  }

  _showBottomSheet({
    required Widget child,
    required Function onBottomSheetAgree,
  }) async {
    var result = await Get.bottomSheet(
      child,
      isScrollControlled: true,
    );
    if (result != null && result) onBottomSheetAgree();
  }

  _getSequenceEngineModel() {
    if (onBoardingOfferNavigation != null) {
      sequenceEngineModel =
          onBoardingOfferNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(OFFER_SCREEN);
    }
  }

  Map _computeApiRequestBody(
    LoanProductCode loanProductCode,
    String actionType, {
    bool onlyAddons = false,
  }) {
    switch (loanProductCode) {
      case LoanProductCode.clp:
        return {
          "actionType": actionType,
        };
      case LoanProductCode.upl:
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
      case LoanProductCode.unknown:
        return onlyAddons
            ? _addOnsPayload()
            : {
                "consentType": "addOn",
                "consentStatus": "granted",
                "addOns": _addOnsPayload()
              };
      default:
        return {};
    }
  }

  Map<String, dynamic> _addOnsPayload() {
    return {
      "insuranceConsent": consentEligibleState(insuranceState),
      if (vasDetails != null)
        "vasDetail": [
          {
            "id": vasDetails!.vasId,
            "consent": consentEligibleState(healthcareState),
            "serviceProvider": vasDetails!.provider
          }
        ]
    };
  }

  onOfferUpgradePressed() async {
    _getSequenceEngineModel();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {"actionType": "upgrade"},
    );
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        if (onBoardingOfferNavigation != null &&
            checkAppFormModel.sequenceEngine != null) {
          onBoardingOfferNavigation!.navigateUserToAppStage(
              sequenceEngineModel: checkAppFormModel.sequenceEngine!);
        } else {
          onNavigationDetailsNull(OFFER_SCREEN);
        }
        break;
      default:
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: OFFER_SCREEN,
          retry: onOfferUpgradePressed,
        );
    }
  }

  void onPldsaOfferLoaded() {
    onJarvisLoanDetailsLoaded({
      "insurance": responseModel.insuranceDetails != null,
      "doconline": responseModel.vasDetailsList != null
    });
  }

  getPDFUrl() async {
    CheckAppFormModel model =
        await OfferRepository().getKfsStatementLetter(fileName);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        pdfDownloadURL = model.responseBody;
        _toggleAppBar(appBarStatus: true);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.kfsFoConsentLoaded);
        kfsScreenState = KfsScreenState.consentTwo;
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: OFFER_SCREEN, retry: getPDFUrl);
    }
  }

  void onContinuePressed() {
    _toggleAppBar(appBarStatus: false);
    kfsScreenState = KfsScreenState.loading;
    getPDFUrl();
  }

  void onconsentOneCtaClick() {
    consentPageTitle = "Consent 2 of 2";
    onContinuePressed();
  }

  fetchLoanAmount() {
    if (responseModel.offerSection != null) {
      String amount = responseModel.offerSection!.loanAmount;
      return AppFunctions().parseIntoCommaFormat(amount);
    }
    return "";
  }

  double fetchNetDisbursalAmount({bool removeAddons = false}) {
    double insuranceAmount = insuranceDetails?.computeNetDisbursalAmount() ?? 0;
    double healthAmount = vasDetails?.computeNetDisbursalAmount() ?? 0;
    finalNetDisbursalAmount = netDisbursalAmountValue -
        computeOutStandingAmount() -
        (insuranceAmount + healthAmount);
    return removeAddons
        ? finalNetDisbursalAmount + (insuranceAmount + healthAmount)
        : finalNetDisbursalAmount;
  }
}
