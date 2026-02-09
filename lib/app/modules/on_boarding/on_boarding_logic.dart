import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hypersnapsdk_flutter/hyper_snap_sdk.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_logic.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_navigation.dart';
import 'package:privo/app/modules/customer_feedback_widget/customer_feedback_view.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/lead_details.dart';
import 'package:privo/app/modules/on_boarding/aa_stand_alone_journey/on_boarding_aa_stand_alone_navigation.dart';
import 'package:privo/app/modules/on_boarding/analytics/e_mandate_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar/aadhaar_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar/aadhaar_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/business_details_polling/business_details_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/ckyc_details/ckyc_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/ckyc_details/ckyc_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line/credit_line_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line/credit_line_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/e_mandate_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/e_mandate_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/eligibility_offer/eligibility_offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/employment_type/employment_type_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/employment_type/employment_type_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer/initial_offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer_polling/initial_offer_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer_polling/initial_offer_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_screen_polling/offer_screen_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_screen_polling/offer_screen_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_polling/offer_upgrade_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/On_boarding_udyam_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/otp_udyam_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/upl_withdrawal_loading/upl_withdrawal_loading_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/webengage_event_mapper.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_navigation.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../flavors.dart';
import '../../common_widgets/gradient_button.dart';
import '../../data/provider/auth_provider.dart';
import '../../firebase/analytics.dart';
import '../../models/app_form_rejection_model.dart';
import '../../models/bank_details_base.dart';
import '../../models/penny_testing_data_transfer_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/snack_bar.dart';
import '../../utils/web_engage_constant.dart';
import 'aa_stand_alone_journey/aa_stand_alone_logic.dart';
import 'mixins/app_form_mixin.dart';
import 'model/privo_app_bar_model.dart';
import 'widgets/business_details_polling/business_details_polling_navigation.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_aadhaar_selfie_status_navigation.dart';
import 'widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';
import 'widgets/offer_upgrade_polling/offer_upgrade_polling_logic.dart';
import 'widgets/pdf_letter/pdf_letter_logic.dart';
import 'widgets/pdf_letter/pdf_letter_navigation.dart';
import 'widgets/upl_withdrawal_loading/upl_withdrawal_navigation.dart';

enum OnBoardingState { loading, success, error, initialized }

enum OnBoardingType { surrogate, nonSurrogate }

class OnBoardingLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, EMandateAnalyticsMixin
    implements
        OnboardingNavigationPersonalDetails,
        PersonalDetailsPollingNavigation,
        OnBoardingEmploymentTypeNavigation,
        OnboardingNavigationWorkDetails,
        OnBoardingInitialOfferPollingNavigation,
        OnBoardingVerifyBankStatementNavigation,
        OnboardingNavigationBankDetails,
        OnboardingNavigationProcessingBankDetails,
        OnBoardingCKYCDetailsNavigation,
        OnBoardingAadhaarNavigation,
        OnboardingNavigationAdditionalBusinessDetails,
        OnBoardingEMandateNavigation,
        OnBoardingCreditLineNavigation,
        OnBoardingESignNavigation,
        OnBoardingCreditLineApprovedNavigation,
        OnBoardingKycVerificationNavigation,
        OnBoardingAadhaarApiNavigation,
        OnBoardingOfferScreenPollingNavigation,
        OnBoardingPDFLetterNavigation,
        OnBoardingOfferNavigation,
        OnBoardingUPLWithdrawalNavigation,
        OnBoardingOfferUpgradeBankSelectionNavigation,
        OnBoardingOfferUpgradePollingNavigation,
        DigioDigilockerAadhaarNavigation,
        OnBoardingEMandatePollingNavigation,
        SBDBusinessDetailsNavigation,
        BusinessDetailsPollingNavigation,
        CoApplicantDetailsNavigation,
        FinalOfferPollingNavigation,
        OnBoardingUdyamNavigation,
        OnBoardingAAStandAloneNavigation{
  DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
  String? appFormid;

  get appForm => appFormid;

  ///this bool is to check the aadhaar is from
  ///ckyc or direct
  ///to skip unable to fetch ckyc state
  bool fromCKYC = false;

  LoanProductCode loanProductCode = LoanProductCode.clp;

  final String FO_APPROVED_UPGRADE_SCREEN = "FO_APPROVED_UPGRADE_SCREEN";

  String _privoAppBarTitle = "";
  String _privoAppBarSubTitle = "";

  late SequenceEngineModel sequenceEngineModel;

// int currentIndex = 0;
  late BankDetailsModel bankDetailsModel;
  AppFormRejectionModel appFormRejectionModel = AppFormRejectionModel(
    isRejected: true,
    errorTitle: '',
    errorBody: '',
    rejectionCode: '',
    rejectionType: RejectionType.general,
  );
  String retryTitle = "";
  String retryImage = "";

  String offerUpgradeScreenType = "";

  UserState _userState = UserState.loading;
  UserState _previoususerState = UserState.loading;

  bool _isPartnerFlow = false;

  UserState get currentUserState => _userState;

  set currentUserState(UserState state) {
    Get.log("current userState = $state");
    _userState = state;
    _computeAppBarVisibility(_userState);
    getOnBoardingState = OnBoardingState.success;
    update();
    logAppsFlyerEvent(state);
    logUserState(state);
    // update();
  }

  Map<UserState, bool> get getToggleAppBarVisibility => {
        UserState.uplDisbursalProgress: false,
        UserState.offerScreenPolling: false,
        UserState.bureauCheckPolling: false,
        UserState.offerUpgradePolling: false,
        UserState.eligibilityPolling: false,
        UserState.eMandatePolling: false,
        UserState.personalDetailsPolling: false,
        UserState.businessDetailsPolling: false,
        UserState.loanBankingDetails: false,
        UserState.initialOfferPolling: false,
        UserState.finalOfferPolling: false,
        UserState.processingApplication: false,
        UserState.appFormRejected: false,
      };

  _computeAppBarVisibility(UserState userState) {
    if (getToggleAppBarVisibility.keys.contains(userState)) {
      toggleAppBarVisibility(getToggleAppBarVisibility[userState]!);
    }
  }

  final String APP_BAR_TITLE_ID = "app_bar_title_id";

  String _privoAppBarTopTitle = "Upgrade Offer";

  String get privoAppBarTopTitle => _privoAppBarTopTitle;

  set privoAppBarTopTitle(String value) {
    _privoAppBarTopTitle = value;
    update([APP_BAR_TITLE_ID]);
  }

  bool _showAppBarTitle = true;

  bool get showAppBarTitle => _showAppBarTitle;

  set showAppBarTitle(bool value) {
    _showAppBarTitle = value;
    update([APP_BAR_TITLE_ID]);
  }

  bool _showAppBar = true;

  bool get showAppBar => _showAppBar;

  set showAppBar(bool value) {
    _showAppBar = value;
    update([APP_BAR_TITLE_ID]);
  }

  logUserState(UserState userState) {
    String? state;
    String event = "";
    switch (userState) {
      case UserState.personalDetails:
        state = "Personal Details";
        break;
      case UserState.workDetails:
        state = "Work Details";
        break;
      case UserState.bankDetails:
        state = "Bank Details Screen";
        // event = WebEngageConstants.addBankScreenLoaded;
        break;
      case UserState.processingApplication:
        state = "Penny Testing Screen";
        break;
      case UserState.offer:
        state = "Approved Offer Screen ";
        break;
      case UserState.selfie:
        state = "Selfie";
        event = WebEngageConstants.selfieScreenLoaded;
        break;
      case UserState.aadhaar:
        state = "Aadhar KYC";
        break;
      case UserState.creditLineApproved:
        state = "Credit Line Activation";
        break;
      case UserState.eMandateDetails:
        state = "Emandate Screen";
        event = WebEngageConstants.setUpAutoPayScreenLoaded;
        break;
      case UserState.showSanctionLetter:
        state = "Line Agreement";
        break;
      case UserState.eMandateSuccess:
        event = WebEngageConstants.eMandateSuccessScreenLoaded;
        break;
      case UserState.eMandateFailure:
        event = WebEngageConstants.eMandateFailureScreenLoaded;
        break;
      case UserState.offerScreenPolling:
        state = "Offer Polling state";
        break;
    }
    if (userState == UserState.appFormRejected) {
      AppAnalytics.trackWebEngageUser(
          userAttributeName: "AppformStatus", userAttributeValue: "Rejected");
      AppAnalytics.trackWebEngageUser(
          userAttributeName: "CustomerStatus", userAttributeValue: "Rejected");
    }
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "ApplicationState", userAttributeValue: state);
    AppAnalytics.trackWebEngageEventWithAttribute(eventName: event);
  }

  logAppsFlyerEvent(UserState state) {
    if (AppsFlyerConstants.userStateAppsFlyerMap.containsKey(state)) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.userStateAppsFlyerMap[state]);
    }
  }

  UserState get previousUserState => _previoususerState;

  set previousUserState(UserState state) {
    Get.log("Previous userState = $state");
    _previoususerState = state;
    update();
    // update();
  }

// var currentUserState = UserState.loading.obs;

  OnBoardingState getOnBoardingState = OnBoardingState.initialized;

  String maskedAccountNumber = "";
  String maskedIFSCCode = "";

  var arguments = Get.arguments;
  var loanId = "";

  ///Form filled values for  details screen
  var isFormFilled = false.obs;

  bool enableKycPolling = true;

  bool enableBureauCheckPolling = true;

  OnBoardingType _onBoardingType = OnBoardingType.nonSurrogate;

  String _bankName = "";

  bool isFeedbackPopUpShown = false;

  final String FEEDBACK_SUBMITTED = "isFeedBackSubmitted";

  PennyTestingDataTransferModel? pennyTestingData;

  late EMandateState _currentEMandateState = EMandateState.loading;

  @override
  void onInit() {
    super.onInit();

    var personalDetailsLogic = Get.find<PersonalDetailsLogic>();
    personalDetailsLogic.navigationPersonalDetails = this;

    var personalDetailsPollingLogic = Get.find<PersonalDetailsPollingLogic>();
    personalDetailsPollingLogic.personalDetailsPollingNavigation = this;

    var employmentTypeLogic = Get.find<EmploymentTypeLogic>();
    employmentTypeLogic.employmentSelectorNavigation = this;

    var workDetailsLogic = Get.find<WorkDetailsLogic>();
    workDetailsLogic.navigationWorkDetails = this;

    var verifybankStatementLogic = Get.find<VerifyBankStatementLogic>();
    verifybankStatementLogic.onBoardingVerifyBankStatementNavigation = this;

    var bankDetailsLogic = Get.find<BankDetailsLogic>();
    bankDetailsLogic.onboardingNavigationBankDetails = this;

    var processingBankDetailsLogic = Get.find<ProcessingBankDetailsLogic>();
    processingBankDetailsLogic.onboardingNavigationProcessingBankDetails = this;

    var eMandateLogic = Get.find<EMandateLogic>();
    eMandateLogic.onBoardingEMandateNavigation = this;

    var creditLineLogic = Get.find<CreditLineLogic>();
    creditLineLogic.onBoardingCreditLineNavigation = this;

    var cKYCDetailsLogic = Get.find<CKYCDetailsLogic>();
    cKYCDetailsLogic.onBoardingCKYCDetailsNavigation = this;

    var aadhaarLogic = Get.find<AadhaarLogic>();
    aadhaarLogic.onBoardingAadhaarNavigation = this;

    var additionalBusinessDetailsLogic =
        Get.find<AdditionalBusinessDetailsLogic>();
    additionalBusinessDetailsLogic
        .onBoardingAdditionalBusinessDetailsNavigation = this;

    var eSignLogic = Get.find<ESignLogic>();
    eSignLogic.onBoardingESignNavigation = this;

    var creditLineApprovedLogic = Get.find<CreditLineApprovedLogic>();
    creditLineApprovedLogic.onBoardingCreditLineApprovedNavigation = this;

    var kycPollingLogic = Get.find<KycVerificationLogic>();
    kycPollingLogic.kycVerificationNavigation = this;

    var aadhaarApiLogic = Get.find<AadhaarApiLogic>();
    aadhaarApiLogic.onBoardingAadhaarApiNavigation = this;

    var offerScreenPollingLogic = Get.find<OfferScreenPollingLogic>();
    offerScreenPollingLogic.onBoardingOfferScreenPollingNavigation = this;

    var initialOfferPollingLogic = Get.find<InitialOfferPollingLogic>();
    initialOfferPollingLogic.onBoardingInitialOfferPollingNavigation = this;

    var pdfLetterLogic = Get.find<PDFLetterLogic>();
    pdfLetterLogic.pdfLetterNavigation = this;

    var offerLogic = Get.find<OfferLogic>();
    offerLogic.onBoardingOfferNavigation = this;

    var initialOfferLogic = Get.find<InitialOfferLogic>();
    initialOfferLogic.onBoardingOfferNavigation = this;

    var eligibilityOfferLogic = Get.find<EligibilityOfferLogic>();
    eligibilityOfferLogic.onBoardingEligibilityOfferNavigation = this;

    var uplWithdrawalProgressLogic = Get.find<UPLWithdrawalLoadingLogic>();
    uplWithdrawalProgressLogic.onBoardingUPLWithdrawalNavigation = this;

    var offerUpgradeBankSelectionLogic =
        Get.find<OfferUpgradeBankSelectionLogic>();
    offerUpgradeBankSelectionLogic.onBoardingAABankSelectionNavigation = this;

    var aaPollingLogic = Get.find<OfferUpgradePollingLogic>();
    aaPollingLogic.onBoardingOfferUpgradePollingNavigation = this;

    var digioDigilockerLogic = Get.find<DigioDigilockerAadhaarLogic>();
    digioDigilockerLogic.digilockerAadhaarNavigation = this;

    var eMandatePollingLogic = Get.find<EMandatePollingLogic>();
    eMandatePollingLogic.navigation = this;

    final sbdBusinessDetailsLogic = Get.find<SBDBusinessDetailsLogic>();
    sbdBusinessDetailsLogic.navigation = this;

    final coApplicantDetailsLogic = Get.find<CoApplicantDetailsLogic>();
    coApplicantDetailsLogic.navigation = this;

    final businessDetailsPollingLogic = Get.find<BusinessDetailsPollingLogic>();
    businessDetailsPollingLogic.navigation = this;

    final finalOfferPollingLogic = Get.find<FinalOfferPollingLogic>();
    finalOfferPollingLogic.navigation = this;

    var otpUdyamLogic = Get.find<OtpUdyamLogic>();
    otpUdyamLogic.onBoardingUdyamNavigation = this;

    var aaBankInitiationLogic = Get.find<AAStandAloneLogic>();
    aaBankInitiationLogic.onBoardingAAStandAloneNavigation = this;

    initHyperSnapSDK();
  }

  @override
  void onClose() {
    enableKycPolling = false;
    enableBureauCheckPolling = false;
    PrivoPlatform.platformService.turnOffScreenProtection();
    super.onClose();
  }

  ///initiate the hyperverge SDK
  void initHyperSnapSDK() async {
    HyperSnapSDK.initialize(
      F.envVariables.hypervergeKeys.appId,
      F.envVariables.hypervergeKeys.appKey,
      Region.india,
    );
  }

  String _computePersonalDetailsTitle() {
    if (_isPartnerFlow) {
      return "Personal Details";
    } else {
      return "Add Personal Details";
    }
  }

  String _computePersonalDetailsSubTitle() {
    if (_isPartnerFlow) {
      return "Verify your information";
    } else {
      return "Tell us about yourself";
    }
  }

  String _computeWorkDetailsTitle() {
    if (_isPartnerFlow) {
      return "Work Details";
    } else {
      return "Add Work Details";
    }
  }

  String _computeWorkDetailsSubTitle() {
    if (_isPartnerFlow) {
      return "Validate your";
    } else {
      return "Tell us about yourself";
    }
  }

  final Map<UserState, String> _sbdTitleMap = {
    UserState.personalDetails: "Basic Details",
    UserState.loanBusinessDetails: "Basic Details",
    UserState.coApplicantDetails: "Basic Details",
    UserState.loanBankingDetails: "Basic Details",
    UserState.aadhaar: "Get Final Offer",
    UserState.selfie: "Get Final Offer",
    UserState.offer: _getSbdofferTitle(),
    UserState.vKYC: "Get Final Offer",
    UserState.sitBack: "Get Final Offer",
    UserState.additionalBusinessDetails: _getSBDAdditionalBDTitle(),
    UserState.bankDetails: "Disbursal",
    UserState.eMandateDetails: "Disbursal",
    UserState.eMandatePolling: "Disbursal",
    UserState.eMandateFailure: "Disbursal",
    UserState.eSignDetails: "Disbursal",
    UserState.eSignFailure: "Disbursal",
    UserState.finalOfferPolling: "Additional Details",
    UserState.aaStandAloneBankSelection: "Disbursal",
  };

  static _getSBDAdditionalBDTitle() {
    return LPCService.instance.isLpcCardTopUp
        ? "Verify Address Details"
        : "Get Final Offer";
  }

  static String _getSbdofferTitle() {
    return LPCService.instance.isLpcCardTopUp
        ? "New Loan Details"
        : "Setup Business Loan";
  }

  PrivoAppBarModel updateTimeLine(UserState state) {
    AppAnalytics.logOnBoardingFlow(state.index, state.name);
    switch (loanProductCode) {
      case LoanProductCode.clp:
        return PrivoAppBarModel(
          title: "Setup Credit Line",
          appBarText: "Setup Credit Line",
          progress: 0.0,
          onClosePressed: _onClosePressed,
          subTitle: _computePersonalDetailsSubTitle(),
        );
      case LoanProductCode.upl:
        return PrivoAppBarModel(
          title: "Setup Personal Loan",
          appBarText: "Setup Personal Loan",
          progress: 0.0,
          onClosePressed: _onClosePressed,
          subTitle: _computePersonalDetailsSubTitle(),
        );
      case LoanProductCode.sbl:
        return PrivoAppBarModel(
          title: "Setup Business Loan",
          appBarText: "Setup Business Loan",
          progress: 0.0,
          subTitle: _computePersonalDetailsSubTitle(),
          onClosePressed: _onClosePressed,
        );
      case LoanProductCode.sbd:
        return PrivoAppBarModel(
          title: _sbdTitleMap[state] ?? "Basic Details",
          appBarText: _sbdTitleMap[state] ?? "Basic Details",
          progress: 0.0,
          subTitle: _computePersonalDetailsSubTitle(),
          onClosePressed: _onClosePressed,
        );
      case LoanProductCode.fcl:
      case LoanProductCode.unknown:
        return PrivoAppBarModel(
          title: "",
          progress: 0.0,
          onClosePressed: _onClosePressed,
          subTitle: _computePersonalDetailsSubTitle(),
        );
    }

    if (loanProductCode == LoanProductCode.sbd) {
      return PrivoAppBarModel(
        title: _sbdTitleMap[state] ?? "Basic Details",
        progress: 0.0,
        subTitle: _computePersonalDetailsSubTitle(),
      );
    } else {
      return PrivoAppBarModel(
        title: "",
        progress: 0.0,
        subTitle: _computePersonalDetailsSubTitle(),
      );
    }

    // switch (state) {
    //   case UserState.personalDetails:
    //     return PrivoAppBarModel(
    //       title: _computePersonalDetailsTitle(),
    //       progress: 0.0,
    //       subTitle: _computePersonalDetailsSubTitle(),
    //     );
    //   case UserState.employmentType:
    //     return PrivoAppBarModel(
    //       title: "Add Work Details",
    //       progress: 0.0,
    //     );
    //   case UserState.workDetails:
    //     return PrivoAppBarModel(
    //       title: _computeWorkDetailsTitle(),
    //       progress: 0.0,
    //       subTitle: _computeWorkDetailsSubTitle(),
    //     );
    //   case UserState.verifyBankDetails:
    //     return _computeTimeLineModelForInitialOffer();
    //   case UserState.bankDetails:
    //     return PrivoAppBarModel(
    //       title: _privoAppBarTitle,
    //       progress: 0.0,
    //       subTitle: _privoAppBarSubTitle,
    //     );
    //   case UserState.cKycDetails:
    //   case UserState.aadhaar:
    //   case UserState.selfie:
    //   case UserState.vKYC:
    //   case UserState.sitBack:
    //     return PrivoAppBarModel(
    //       title: "",
    //       progress: 0.0,
    //       isTitleVisible: true,
    //     );
    //   case UserState.eMandateDetails:
    //     return PrivoAppBarModel(
    //       title: _privoAppBarTitle.isNotEmpty
    //           ? _privoAppBarTitle
    //           : "Set up Auto-Pay",
    //       progress: 0.0,
    //       subTitle: _privoAppBarSubTitle.isNotEmpty
    //           ? _privoAppBarSubTitle
    //           : 'Link your bank account',
    //       onClosePressed: _onEMandateScreenClosePressed,
    //     );
    //   case UserState.eSignDetails:
    //     return PrivoAppBarModel(
    //         title: "",
    //         progress: 0.0,
    //         isTitleVisible: false,
    //         isAppBarVisible: false);
    //   case UserState.showLineAgreement:
    //     return PrivoAppBarModel(
    //         title: computeShowLineAgreement(), progress: 0.0, subTitle: ' ');
    //   case UserState.eMandateFailure:
    //     return PrivoAppBarModel(
    //         title: "",
    //         progress: 0.0,
    //         isAppBarVisible: true,
    //         isTitleVisible: true);
    //   case UserState.offerUpgradeBankSelection:
    //     return PrivoAppBarModel(
    //       title: "Provide Bank Statement",
    //       subTitle: "Verify Bank statement",
    //       progress: 0.0,
    //       appBarText: privoAppBarTopTitle,
    //       onClosePressed: onBankStatementClosePressed,
    //     );
    //   case UserState.kycSuccess:
    //   case UserState.creditLineApproved:
    //   case UserState.eMandateSuccess:
    //   case UserState.eSignSuccess:
    //   case UserState.eSignFailure:
    //   case UserState.uplDisbursalProgress:
    //   case UserState.creditLineRejected:
    //   case UserState.creditLineFailed:
    //   case UserState.appFormRejected:
    //   case UserState.loading:
    //   case UserState.processingApplication:
    //   case UserState.bankVerifyFailed:
    //   case UserState.offerUpgradePolling:
    //   case UserState.offerScreenPolling:
    //   case UserState.offer:
    //   case UserState.eligibilityPolling:
    //   case UserState.eligibilityOffer:
    //   case UserState.initialOfferPolling:
    //   case UserState.initialOffer:
    //     return PrivoAppBarModel(
    //         title: "",
    //         progress: 0.0,
    //         isAppBarVisible: false,
    //         isTitleVisible: false);
    //   case UserState.sitBackCKycDetails:
    //     return PrivoAppBarModel(title: "", progress: 0.0);
    //   default:
    //     return PrivoAppBarModel(title: "", progress: 0.0);
    // }
  }

  _onClosePressed() async {
    if (await onWillPop()) {
      Get.back();
    }
  }

  final aadhaarApiLogic = Get.find<AadhaarApiLogic>();
  final aaStandAloneLogic = Get.find<AAStandAloneLogic>();

  Future<bool> onWillPop() async {
    if (getOnBoardingState == OnBoardingState.loading) {
      AppSnackBar.successBar(title: 'Loading', message: 'Please Wait');
      return false;
    }

    switch (currentUserState) {
      case UserState.aadhaar:
        return aadhaarApiLogic.onBackPressed();
      case UserState.eMandateSuccess:
        return false;
      default:
        WebEngageEventMapper().onBackPressEventTrigger(currentUserState);
        return true;
    }
  }

  _onEMandateScreenClosePressed() {
    switch (_currentEMandateState) {
      case EMandateState.loading:
        break;
      case EMandateState.idle:
        logSetupAutopayScreenClosed();
        Get.back();
        break;
      case EMandateState.jusPay:
        logSetupAutopayMainScreenClosed();
        Get.back();
        break;
    }
  }

  PrivoAppBarModel _computeTimeLineModelForInitialOffer() {
    switch (_onBoardingType) {
      case OnBoardingType.surrogate:
        return PrivoAppBarModel(title: "", progress: 0.0);
      case OnBoardingType.nonSurrogate:
        return PrivoAppBarModel(
            title: "Verify your bank statement", progress: 0.0);
    }
  }

  void onInitial() async {
    appFormid = await AppAuthProvider.appFormID;
    loanProductCode = arguments['loanProductCodeType'];
    sequenceEngineModel = arguments['sequenceEngineModel'];

    if (arguments['isRejected']) {
      appFormRejectionModel.errorTitle = arguments['errorTitle'];
      appFormRejectionModel.errorBody = arguments['errorBody'];
      appFormRejectionModel.rejectionCode = arguments['errorCode'];
      currentUserState = UserState.appFormRejected;
    } else {
      try {
        _onBoardingType = arguments['is_surrogate']
            ? OnBoardingType.surrogate
            : OnBoardingType.nonSurrogate;
        currentUserState = UserState.loading;
        _isPartnerFlow = arguments['isPartnerFlow'];
        currentUserState = UserState.values[int.parse('${arguments['state']}')];
      } catch (e) {
        currentUserState = UserState.appFormRejected;
      }
    }
  }

  @override
  onOnBoardingPersonalDetailsFinished() {
    currentUserState = UserState.workDetails;
  }

  @override
  onAppFormRejected({required AppFormRejectionModel model}) {
    toggleBack(isBackDisabled: false);
    toggleAppBarVisibility(false);
    appFormRejectionModel = model;
    currentUserState = UserState.appFormRejected;
  }

  @override
  setPennyTestingData(PennyTestingDataTransferModel pennyTestingData) {
    this.pennyTestingData = pennyTestingData;
  }

  @override
  PennyTestingDataTransferModel? getPennyTestingData() {
    return pennyTestingData;
  }

  @override
  bool isPartnerFlow() {
    return _isPartnerFlow;
  }

  @override
  LeadDetails? getLeadDetails() {
    return arguments['leadDetails'];
  }

  void showFeedBackScreen() async {
    if (!arguments[FEEDBACK_SUBMITTED] && !isFeedbackPopUpShown) {
      isFeedbackPopUpShown = true;
      await showModalBottomSheet(
          context: Get.context!,
          isDismissible: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return CustomerFeedbackView(
              onSuccess: () {},
            );
          });
      Get.back();
    } else {
      Get.back();
    }
  }

  @override
  onEmploymentTypeSuccess() {
    Get.log("Employment success triggered");
    currentUserState = UserState.workDetails;
  }

  @override
  toggleBack({required bool isBackDisabled}) {
    getOnBoardingState =
        isBackDisabled ? OnBoardingState.loading : OnBoardingState.success;
    update(['body']);
  }

  @override
  onSelectAadhaar({required bool fromCKYC}) {
    this.fromCKYC = fromCKYC;
    currentUserState = UserState.aadhaar;
  }

  @override
  bool checkFromCKYC() {
    return fromCKYC;
  }

  @override
  onSelectCKYC({required String imagePath}) {
    currentUserState = UserState.selfie;
  }

  @override
  onAadhaarSuccess({required String imagePath}) {
    currentUserState = UserState.selfie;
  }

  @override
  onGoToBankDetails() {
    currentUserState = UserState.bankDetails;
  }

  @override
  onESignFailure() {
    currentUserState = UserState.eSignFailure;
  }

  @override
  onESignSuccess() async {
    currentUserState = UserState.eSignSuccess;
    await Future.delayed(const Duration(seconds: 3));
    currentUserState = UserState.uplDisbursalProgress;
  }

  @override
  onCreditLineApproved() {
    currentUserState = UserState.bankDetails;
  }

  @override
  onOnBoardingWorkDetailsFinished() {
    currentUserState = UserState.offerScreenPolling;
  }

  @override
  OnBoardingType onBoardingType() {
    return _onBoardingType;
  }

  @override
  onSurrogateOnBoarding() {
    _onBoardingType = OnBoardingType.surrogate;
    currentUserState = UserState.loading;
    currentUserState = UserState.verifyBankDetails;
  }

  @override
  onNonSurrogateOnBoarding() {
    _onBoardingType = OnBoardingType.nonSurrogate;
  }

  @override
  navigateToBankDetails() {
    currentUserState = UserState.bankDetails;
  }

  @override
  onPersonalDetailsPollSuccess() {
    currentUserState = UserState.workDetails;
  }

  @override
  onOnBoardingBankDetailsFinished() {
    currentUserState = UserState.processingApplication;
  }

  @override
  onOnBoardingProcessingBankDetailsFailed() {
    currentUserState = UserState.bankVerifyFailed;
  }

  @override
  onOnBoardingProcessingBankDetailsFinished() {
    currentUserState = UserState.eMandateDetails;
  }

  @override
  BankDetailsModel bankDetailsForPennyTesting() {
    return bankDetailsModel;
  }

  @override
  goBackToVerifyBankStatementSelector() {
    currentUserState = UserState.verifyBankDetails;
  }

  @override
  onVerifyBankStatementFailed() {
    currentUserState = UserState.bankVerifyFailed;
  }

  @override
  onEMandateFailed() {
    currentUserState = UserState.eMandateFailure;
  }

  bool toggleBackButton = true;

  @override
  onEMandateFinished() async {
    currentUserState = UserState.eMandateSuccess;
    toggleBackButton = false;
    update(["backButtonId"]);
    await Future.delayed(const Duration(seconds: 3));
    Get.back();
    // _computeEMandateSuccessNavigation(eSignFlow);
  }

  _computeEMandateSuccessNavigation(ESignFlow eSignFlow) {
    switch (eSignFlow) {
      case ESignFlow.clp:
        Get.back();
        break;
      case ESignFlow.clickWrap:
        currentUserState = UserState.showLineAgreement;
        break;
      case ESignFlow.digio:
        currentUserState = UserState.eSignDetails;
        break;
    }
  }

  @override
  onCreditLineFailed() {
    currentUserState = UserState.creditLineFailed;
  }

  @override
  onCreditLineRejected() {
    currentUserState = UserState.creditLineRejected;
  }

  @override
  onCreditLineFinished() {
    Get.offNamed(Routes.WITHDRAWAL_SCREEN);
  }

  @override
  onKycPollingSuccess() async {
    currentUserState = UserState.kycSuccess;
    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  onBureauCheckPollingSuccess() {
    currentUserState = UserState.offerScreenPolling;
  }

  @override
  onAadhaarApiSuccess() {
    currentUserState = UserState.selfie;
  }

  ///go to will pop scope if the state is not in polling state
  void onHomeButtonPressed(BuildContext context) {
    if (currentUserState == UserState.appFormRejected &&
        !arguments[FEEDBACK_SUBMITTED]) {
      showFeedBackScreen();
    } else if (currentUserState == UserState.aadhaar) {
      final aadhaarApiLogic = Get.find<AadhaarApiLogic>();
      aadhaarApiLogic.onHomeBackPress();
      Get.back();
    } else if (getOnBoardingState != OnBoardingState.loading ||
        currentUserState == UserState.sitBack ||
        currentUserState == UserState.offerScreenPolling) {
      WebEngageEventMapper().onBackPressEventTrigger(currentUserState);
      Get.back();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  navigateToCreditLineScreen() {
    switch (loanProductCode) {
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
        currentUserState = UserState.uplDisbursalProgress;
        break;
      case LoanProductCode.clp:
        currentUserState = UserState.creditLineApproved;
        break;
    }
  }

  @override
  navigateToOfferScreen() {
    currentUserState = UserState.offer;
  }

  @override
  onOfferScreenPollSuccess() {
    currentUserState = UserState.offer;
  }

  @override
  onInitialOfferPollSuccess() {
    currentUserState = UserState.initialOffer;
  }

  @override
  onGoToBankDetailsClicked() {
    currentUserState = UserState.bankDetails;
  }

  @override
  navigateToUdyamScreen() {
    currentUserState = UserState.otpUdyamDetails;
  }

  @override
  navigateToAadhaarScreen() {
    currentUserState = UserState.aadhaar;
  }

  @override
  onUPLWithdrawClose() {
    Get.back();
  }

  @override
  onUPLWithdrawSuccess() {
    Get.back();
  }

  @override
  navigateOnAAPollingScreen() {
    currentUserState = UserState.offerUpgradePolling;
  }

  @override
  navigateToAASDK() {
    currentUserState = UserState.offerUpgradeBankSelection;
  }

  @override
  toggleAppBarTitle(bool value) {
    showAppBarTitle = value;
  }

  @override
  toggleAppBarVisibility(bool value) {
    showAppBar = value;
  }

  @override
  changeAppBarTopTitleText(String value) {
    privoAppBarTopTitle = value;
  }

  @override
  changeAppBarTitle(String title, String subTitle) {
    _privoAppBarTitle = title;
    _privoAppBarSubTitle = subTitle;
    update([APP_BAR_TITLE_ID]);
  }

  @override
  onEMandateFailureTryAgainClicked() {
    currentUserState = UserState.eMandateDetails;
  }

  Map<LoanProductCode, String> showLineAgreementTitleMapData() {
    return {
      LoanProductCode.sbl: "Loan Agreement",
      LoanProductCode.upl: "Loan Agreement",
      LoanProductCode.clp: "Line Agreement",
    };
  }

  computeShowLineAgreement() {
    return showLineAgreementTitleMapData()[loanProductCode];
  }

  @override
  navigateUserToAppStage({required SequenceEngineModel sequenceEngineModel}) {
    this.sequenceEngineModel = sequenceEngineModel;
    currentUserState =
        computeNextStage(sequenceEngineModel: sequenceEngineModel);
  }

  @override
  SequenceEngineModel getSequenceEngineDetails() {
    return sequenceEngineModel;
  }

  computeNextStage({required SequenceEngineModel sequenceEngineModel}) {
    if (userStageDetails[sequenceEngineModel.appStage] != null) {
      return userStageDetails[sequenceEngineModel.appStage];
    }
  }

  computeOnFailure({required SequenceEngineModel sequenceEngineModel}) {
    //ToDo: compute onFailure
  }

  computeOnReject() {
    //ToDo: compute onReject
  }

  computeOnFallBack() {
    //ToDo: compute onFallBack
  }

  @override
  String getRequestUrl() {
    if (sequenceEngineModel.onSubmit != null) {
      return sequenceEngineModel.onSubmit!.requestUrl;
    } else if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestUrl;
    }
    return '';
  }

  @override
  String computeMethodFromSequenceEngine() {
    if (sequenceEngineModel.onSubmit != null) {
      return sequenceEngineModel.onSubmit!.requestType;
    } else if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestType;
    }
    return '';
  }

  onBankStatementClosePressed() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aaAddBankScreenBackButtonClicked,
        attributeName:
            sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
                ? {"upgrade_flow_aa_perfios": "true"}
                : {"rejection_flow_aa_perfios": "true"});
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: "Leaving Early! Please tell us what went wrong ?",
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: darkBlueColor,
          fontSize: 14,
        ),
        radioValues: [
          "Finding Net Banking Details",
          "Technical glitch",
          "I’ll do it later",
          "My bank is not listed",
        ],
        enableOtherTextField: true,
        ctaButtonsBuilder: (BottomSheetRadioButtonLogic logic) => [
          GradientButton(
            onPressed: () {
              logic.onSubmitPressed(
                onSubmitPressed: (selectedValue) async {
                  ///todo: add webEngage event
                  _computeOnSubmitEvents(selectedValue);
                  await _computeScreenType();
                },
              );
            },
            title: "Submit",
          ),
          Center(
            child: TextButton(
              onPressed: () {
                AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: "Cancel_Clicked",
                    attributeName: sequenceEngineModel.screenType ==
                            FO_APPROVED_UPGRADE_SCREEN
                        ? {"upgrade_flow_aa_perfios": "true"}
                        : {"rejection_flow_aa_perfios": "true"});
                Get.back();
              },
              style: TextButton.styleFrom(
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: skyBlueColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
        onWillPop: (bool showSuccessScreen) {
          if (showSuccessScreen) {
            Get.back(
              result: {
                "close_parent": showSuccessScreen,
              },
            );
          }
          return true;
        },
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );

    Get.log("result - $result");

    if (result != null && result is Map) {
      if (result['close_parent']) {
        Get.back();
      }
    }
  }

  void _computeOnSubmitEvents(selectedValue) {
    String aaFlowTypeName =
        sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
            ? "upgrade_flow_aa_perfios"
            : "rejection_flow_aa_perfios";

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "feedback_selected",
        attributeName: {aaFlowTypeName: "true", "reason": selectedValue});

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "CTA_Submit_Clicked",
        attributeName: {aaFlowTypeName: "true"});
  }

  Future _computeScreenType() async {
    SequenceEngineModel sequenceEngineModel = getSequenceEngineDetails();
    if (sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN) {
      CheckAppFormModel checkAppFormModel =
          await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
        body: {
          "actionType": "opt_out",
        },
      );
      if (checkAppFormModel.apiResponse.state != ResponseState.success) {
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: "bank_statement_feedback", retry: _computeScreenType);
      }
    }
  }

  @override
  getEMandateState(EMandateState eMandateState) {
    _currentEMandateState = eMandateState;
  }

  @override
  setLoanProductCode(LoanProductCode lpc) {
    loanProductCode = lpc;
  }
}
