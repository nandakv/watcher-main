import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/app_stepper.dart';
import 'package:privo/app/common_widgets/onboarding_timeline_widget/onboarding_timeline_widget.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import '../../modules/on_boarding/user_state_maps.dart';

enum OnboardingTimelineWidgetState { loading, success, error }

class OnboardingTimelineWidgetLogic extends GetxController
    with AppFormMixin, ErrorLoggerMixin {
  OnboardingTimelineWidgetState _onboardingTimelineWidgetState =
      OnboardingTimelineWidgetState.loading;

  OnboardingTimelineWidgetState get onboardingTimelineWidgetState =>
      _onboardingTimelineWidgetState;

  ///stepper states
  static const double _NO_APPFORM = 0;
  static const double _TELL_US_ABOUT_URSELF = 1;
  static const double _AA_STATE = 1.5;
  static const double _OFFER_POLLING_STATE = 1.5;
  static const double _VERIFY_YOUR_IDENTIY = 2;
  static const double _CREDIT_LINE = 2.5;
  static const double _LINK_BANK_ACCOUNT = 3;
  static const double _TRANSFER_MONEY = 4;

  ///stepper state for upl
  static const double _OFFER_UPL = 0;
  static const double _VERIFY_YOUR_IDENTIY_UPL = 1;
  static const double _LINK_BANK_ACCOUNT_UPL = 2;
  static const double _TRANSFER_MONEY_UPL = 3;

  ///stepper state for sbl
  static const double _OFFER_SBL = 0;
  static const double _VERIFY_YOUR_IDENTIY_SBL = 1;
  static const double _LINK_BANK_ACCOUNT_SBL = 2;
  static const double _SET_UP_AUTO_PAY_SBL = 3;

  set onboardingTimelineWidgetState(OnboardingTimelineWidgetState value) {
    _onboardingTimelineWidgetState = value;
    update();
  }

  bool _isPartnerFlow = false;

  double _currentAppStepperState = 0;

  double get currentAppStepperState => _currentAppStepperState;

  set currentAppStepperState(double value) {
    _currentAppStepperState = value;
  }

  List<AppStep> stepList = [];

  void onAfterLayout(
    bool removeButtons, {
    int? appState,
    required LoanProductCode loanProductCode,
    required bool isPartnerFlow,
  }) async {
    _isPartnerFlow = isPartnerFlow;
    onboardingTimelineWidgetState = OnboardingTimelineWidgetState.loading;
    // await Future.delayed(const Duration(seconds: 1));
    Get.log("appstate = $appState");
    _computeSteps(removeButtons, loanProductCode);
    if (appState != null) {
      _computeAppStepperState(appState, loanProductCode);
    } else if ((AppAuthProvider.appFormID).isEmpty) {
      _computeAppStepperState(0, loanProductCode);
    } else {
      getAppForm(
        onApiError: _onGetAppFormError,
        onRejected: (appform) {},
        onSuccess: _onGetAppFormSuccess,
      );
    }
  }

  _onGetAppFormError(ApiResponse apiResponse) {
    logError(
      statusCode: apiResponse.statusCode.toString(),
      responseBody: apiResponse.apiResponse,
      requestBody: apiResponse.requestBody,
      exception: apiResponse.exception,
      url: apiResponse.url,
    );
    onboardingTimelineWidgetState = OnboardingTimelineWidgetState.error;
  }

  _onGetAppFormSuccess(AppForm appForm) {
    int appState = int.parse("${appForm.responseBody['app_state']}");
    Get.log("app state = $appState");
    _computeAppStepperState(
      appState,
      appForm.loanProductCode,
    );
  }

  final Map<int, double> _appStepperStateMap = {
    PERSONAL_DETAILS: _NO_APPFORM,
    WORK_DETAILS: _TELL_US_ABOUT_URSELF,
    AA_BANK_SELECTION: _AA_STATE,
    AA_POLLING: _AA_STATE,
    OFFER_POLLING: _OFFER_POLLING_STATE,
    OFFER: _VERIFY_YOUR_IDENTIY,
    KYC_AADHAAR: _VERIFY_YOUR_IDENTIY,
    KYC_SELFIE: _VERIFY_YOUR_IDENTIY,
    VKYC: _VERIFY_YOUR_IDENTIY,
    KYC_POLLING: _VERIFY_YOUR_IDENTIY,
    LINE_AGREEMENT: _CREDIT_LINE,
    CREDIT_LINE_APPROVED: _LINK_BANK_ACCOUNT,
    BANK_DETAILS: _LINK_BANK_ACCOUNT,
    PENNY_TESTING: _LINK_BANK_ACCOUNT,
    EMANDATE_DETAILS: _LINK_BANK_ACCOUNT,
    EMANDATE_POLLING: _LINK_BANK_ACCOUNT,
    DISBURSAL_PROGRESS: _TRANSFER_MONEY,
    ELIGIBILITY_POLLING: _OFFER_POLLING_STATE,
  };

  final Map<int, double> _appPartnerFlowStepperStateMap = {
    PERSONAL_DETAILS: _TELL_US_ABOUT_URSELF,
    WORK_DETAILS: _TELL_US_ABOUT_URSELF,
    AA_BANK_SELECTION: _AA_STATE,
    AA_POLLING: _AA_STATE,
    OFFER_POLLING: _OFFER_POLLING_STATE,
    OFFER: _VERIFY_YOUR_IDENTIY,
    KYC_AADHAAR: _VERIFY_YOUR_IDENTIY,
    KYC_SELFIE: _VERIFY_YOUR_IDENTIY,
    KYC_POLLING: _VERIFY_YOUR_IDENTIY,
    VKYC: _VERIFY_YOUR_IDENTIY,
    LINE_AGREEMENT: _CREDIT_LINE,
    CREDIT_LINE_APPROVED: _LINK_BANK_ACCOUNT,
    BANK_DETAILS: _LINK_BANK_ACCOUNT,
    PENNY_TESTING: _LINK_BANK_ACCOUNT,
    EMANDATE_DETAILS: _LINK_BANK_ACCOUNT,
    EMANDATE_POLLING: _LINK_BANK_ACCOUNT,
    DISBURSAL_PROGRESS: _TRANSFER_MONEY,
  };

  final Map<int, double> _appStepperUPLStateMap = {
    OFFER: _OFFER_UPL,
    KYC_AADHAAR: _VERIFY_YOUR_IDENTIY_UPL,
    KYC_SELFIE: _VERIFY_YOUR_IDENTIY_UPL,
    VKYC: _VERIFY_YOUR_IDENTIY_UPL,
    KYC_POLLING: _VERIFY_YOUR_IDENTIY_UPL,
    BANK_DETAILS: _LINK_BANK_ACCOUNT_UPL,
    PENNY_TESTING: _LINK_BANK_ACCOUNT_UPL,
    EMANDATE_DETAILS: _LINK_BANK_ACCOUNT_UPL,
    EMANDATE_POLLING: _LINK_BANK_ACCOUNT_UPL,
    LINE_AGREEMENT: _TRANSFER_MONEY_UPL,
    ESIGN_DETAILS: _TRANSFER_MONEY_UPL,
    DISBURSAL_PROGRESS: _TRANSFER_MONEY_UPL,
  };

  final Map<int, double> _appStepperSBLStateMap = {
    PERSONAL_DETAILS: _NO_APPFORM,
    OFFER: _OFFER_SBL,
    KYC_AADHAAR: _VERIFY_YOUR_IDENTIY_SBL,
    KYC_SELFIE: _VERIFY_YOUR_IDENTIY_SBL,
    VKYC: _VERIFY_YOUR_IDENTIY_SBL,
    KYC_POLLING: _VERIFY_YOUR_IDENTIY_SBL,
    BANK_DETAILS: _LINK_BANK_ACCOUNT_SBL,
    PENNY_TESTING: _LINK_BANK_ACCOUNT_SBL,
    EMANDATE_DETAILS: _SET_UP_AUTO_PAY_SBL,
    EMANDATE_POLLING: _SET_UP_AUTO_PAY_SBL,
    LINE_AGREEMENT: _TRANSFER_MONEY_UPL,
    ESIGN_DETAILS: _TRANSFER_MONEY_UPL,
    DISBURSAL_PROGRESS: _TRANSFER_MONEY_UPL,
  };

  _computeAppStepperState(int appState, LoanProductCode loanProductCode) {
    switch (loanProductCode) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        currentAppStepperState = _appStepperSBLStateMap[appState]!;
        break;
      case LoanProductCode.upl:
        currentAppStepperState = _appStepperUPLStateMap[appState]!;
        break;
      case LoanProductCode.clp:
        if (_isPartnerFlow) {
          currentAppStepperState = _appPartnerFlowStepperStateMap[appState]!;
        } else {
          currentAppStepperState = _appStepperStateMap[appState]!;
        }
        break;
    }
    Get.log("currentAppStepperState - $currentAppStepperState");
    onboardingTimelineWidgetState = OnboardingTimelineWidgetState.success;
  }

  StepWidget _sblBasicDetailStep({bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Basic Details",
      subSteps: const ["Personal details", "Business Details"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  StepWidget _sblBankOfferStep({bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Bank Info + Final Offer",
      subSteps: const ["Bank Details", "KYC", "Additional Business Details"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  StepWidget _sblDisbursalStep({bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Disbursal",
      subSteps: const ["Bank Verification", "Auto-Pay Setup", "E-Sign"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  StepWidget _clpBasicDetailStep({bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Basic Details",
      subSteps: const ["Personal details", "Work Details"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  StepWidget _clpEligibilityCheckStep(
      {bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Eligibility Check",
      subSteps: const ["Eligbility Check For Loan Offer"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  StepWidget _clpWithdrawalStep({bool isSuccess = false, inBetween = false}) {
    return StepWidget(
      "Withdraw",
      subSteps: const ["KYC", "Mandate Setup", "Withdraw"],
      isSuccess: isSuccess,
      inBetween: inBetween,
    );
  }

  void _computeSteps(bool removeButtons, LoanProductCode loanProductCode) {
    switch (loanProductCode) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        stepList = [
          AppStep(
            child: _sblBasicDetailStep(),
            successChild: _sblBasicDetailStep(isSuccess: true),
            inBetweenChild:
                _sblBasicDetailStep(isSuccess: true, inBetween: true),
            stepOvalPosition: AppStepOvalPosition.top,
          ),
          AppStep(
            child: _sblBankOfferStep(),
            successChild: _sblBankOfferStep(isSuccess: true),
            inBetweenChild: _sblBankOfferStep(isSuccess: true, inBetween: true),
          ),
          AppStep(
            child: _sblDisbursalStep(),
            successChild: _sblDisbursalStep(isSuccess: true),
            inBetweenChild: _sblDisbursalStep(isSuccess: true, inBetween: true),
          ),
        ];
        break;
      default:
        stepList = [
          AppStep(
            child: _clpBasicDetailStep(),
            successChild: _clpBasicDetailStep(isSuccess: true),
            inBetweenChild:
                _clpBasicDetailStep(isSuccess: true, inBetween: true),
            stepOvalPosition: AppStepOvalPosition.top,
          ),
          AppStep(
            child: _clpEligibilityCheckStep(),
            successChild: _clpEligibilityCheckStep(isSuccess: true),
            inBetweenChild:
                _clpEligibilityCheckStep(isSuccess: true, inBetween: true),
          ),
          AppStep(
            child: _clpWithdrawalStep(),
            successChild: _clpWithdrawalStep(isSuccess: true),
            inBetweenChild:
                _clpWithdrawalStep(isSuccess: true, inBetween: true),
          ),
        ];
    }

    // switch (loanProductCode) {
    //   case LoanProductCode.sbl:
    //     stepList = [
    //       AppStep(
    //         child: StepWidget(
    //           "Verify your identity",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Verify your identity",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //         inBetweenChild: StepWidget(
    //           "Verify your identity",
    //           "",
    //           isSuccess: true,
    //           inBetween: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Confirm bank details",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Confirm bank details",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Set up Auto Pay",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Set up Auto Pay",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //     ];
    //     break;
    //   case LoanProductCode.upl:
    //     stepList = [
    //       AppStep(
    //         child: StepWidget(
    //           "Verify your identity",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Verify your identity",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //         inBetweenChild: StepWidget(
    //           "Verify your identity",
    //           "",
    //           isSuccess: true,
    //           inBetween: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Link your bank account",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Link your bank account",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Accept and transfer",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Accept and transfer",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //     ];
    //     break;
    //   case LoanProductCode.clp:
    //     stepList = [
    //       AppStep(
    //         child: StepWidget(
    //           _computeCLPFirstStepTitle(),
    //           "Get Offer",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           _computeCLPFirstStepTitle(),
    //           "Get Offer",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //         inBetweenChild: StepWidget(
    //           _computeCLPFirstStepTitle(),
    //           "Get Offer",
    //           isSuccess: true,
    //           inBetween: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Verify your identity",
    //           "Set up credit line",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Verify your identity",
    //           "Set up credit line",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //         inBetweenChild: StepWidget(
    //           "Verify your identity",
    //           "Set up credit line",
    //           isSuccess: true,
    //           inBetween: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Link your bank account",
    //           "",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Link your bank account",
    //           "",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //       AppStep(
    //         child: StepWidget(
    //           "Withdraw your money",
    //           "Transfer money",
    //           removeButton: removeButtons,
    //         ),
    //         successChild: StepWidget(
    //           "Withdraw your money",
    //           "Transfer money",
    //           isSuccess: true,
    //           removeButton: removeButtons,
    //         ),
    //       ),
    //     ];
    //     break;
    // }
  }

  String _computeCLPFirstStepTitle() {
    if (_isPartnerFlow) {
      return "Verify your information";
    } else {
      return "Tell us about yourself";
    }
  }
}
