import 'package:get/get.dart';
import 'package:privo/app/modules/home_screen_module/home_page_state_maps.dart';

import '../../modules/on_boarding/mixins/app_form_mixin.dart';
import '../../modules/on_boarding/user_state_maps.dart';
import '../horizontal_timeline_step_widget.dart';

enum HomePageStepProgress {
  inactive,
  stepOneInProgress,
  stepTwoInProgress,
  stepThreeInProgress,
  stepThreeCompleted,
  stepThreeFailed,
}

class HomePageStepperLogic extends GetxController {
  HorizontalTimelineStepWidgetState stepOneState =
      HorizontalTimelineStepWidgetState.inActive;
  HorizontalTimelineStepWidgetState stepTwoState =
      HorizontalTimelineStepWidgetState.inActive;
  HorizontalTimelineStepWidgetState stepThreeState =
      HorizontalTimelineStepWidgetState.inActive;

  late String stepOneLabel;
  late String stepTwoLabel;
  late String stepThreeLabel;

  _computeStepState(HomePageStepProgress homePageStepProgress) {
    switch (homePageStepProgress) {
      case HomePageStepProgress.inactive:
        break;
      case HomePageStepProgress.stepOneInProgress:
        stepOneState = HorizontalTimelineStepWidgetState.active;
        break;
      case HomePageStepProgress.stepTwoInProgress:
        stepOneState = HorizontalTimelineStepWidgetState.success;
        stepTwoState = HorizontalTimelineStepWidgetState.active;
        break;
      case HomePageStepProgress.stepThreeInProgress:
        stepOneState = HorizontalTimelineStepWidgetState.success;
        stepTwoState = HorizontalTimelineStepWidgetState.success;
        stepThreeState = HorizontalTimelineStepWidgetState.active;
        break;
      case HomePageStepProgress.stepThreeCompleted:
        stepOneState = HorizontalTimelineStepWidgetState.success;
        stepTwoState = HorizontalTimelineStepWidgetState.success;
        stepThreeState = HorizontalTimelineStepWidgetState.success;
        break;
      case HomePageStepProgress.stepThreeFailed:
        stepOneState = HorizontalTimelineStepWidgetState.success;
        stepTwoState = HorizontalTimelineStepWidgetState.success;
        stepThreeState = HorizontalTimelineStepWidgetState.failure;
        break;
    }
  }

  final Map<int, HomePageStepProgress> _clpAppStepperStateMap = {
    PERSONAL_DETAILS: HomePageStepProgress.inactive,
    PERSONAL_DETAILS_POLLING: HomePageStepProgress.stepOneInProgress,
    WORK_DETAILS: HomePageStepProgress.stepOneInProgress,
    AA_BANK_SELECTION: HomePageStepProgress.stepOneInProgress,
    AA_POLLING: HomePageStepProgress.stepOneInProgress,
    OFFER_POLLING: HomePageStepProgress.stepOneInProgress,
    OFFER: HomePageStepProgress.stepTwoInProgress,
    KYC_AADHAAR: HomePageStepProgress.stepTwoInProgress,
    KYC_SELFIE: HomePageStepProgress.stepTwoInProgress,
    VKYC: HomePageStepProgress.stepTwoInProgress,
    KYC_POLLING: HomePageStepProgress.stepTwoInProgress,
    LINE_AGREEMENT: HomePageStepProgress.stepThreeInProgress,
    CREDIT_LINE_APPROVED: HomePageStepProgress.stepThreeInProgress,
    BANK_DETAILS: HomePageStepProgress.stepThreeInProgress,
    PENNY_TESTING: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_DETAILS: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_POLLING: HomePageStepProgress.stepThreeInProgress,
    DISBURSAL_PROGRESS: HomePageStepProgress.stepThreeCompleted,
    STANDALONE_AA: HomePageStepProgress.stepThreeInProgress,
  };

  final Map<int, HomePageStepProgress> _b2aAppStepperStateMap = {
    PERSONAL_DETAILS: HomePageStepProgress.inactive,
    PERSONAL_DETAILS_POLLING: HomePageStepProgress.stepOneInProgress,
    WORK_DETAILS: HomePageStepProgress.stepOneInProgress,
    AA_BANK_SELECTION: HomePageStepProgress.stepOneInProgress,
    AA_POLLING: HomePageStepProgress.stepOneInProgress,
    OFFER_POLLING: HomePageStepProgress.stepTwoInProgress,
    OFFER: HomePageStepProgress.stepThreeInProgress,
    KYC_AADHAAR: HomePageStepProgress.stepOneInProgress,
    KYC_SELFIE: HomePageStepProgress.stepOneInProgress,
    VKYC: HomePageStepProgress.stepOneInProgress,
    KYC_POLLING: HomePageStepProgress.stepOneInProgress,
    LINE_AGREEMENT: HomePageStepProgress.stepThreeInProgress,
    CREDIT_LINE_APPROVED: HomePageStepProgress.stepThreeInProgress,
    BANK_DETAILS: HomePageStepProgress.stepThreeInProgress,
    PENNY_TESTING: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_DETAILS: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_POLLING: HomePageStepProgress.stepThreeInProgress,
    DISBURSAL_PROGRESS: HomePageStepProgress.stepThreeCompleted,
    ELIGIBILITY_POLLING: HomePageStepProgress.stepOneInProgress,
    ELIGIBILITY_OFFER: HomePageStepProgress.stepOneInProgress,
    STANDALONE_AA: HomePageStepProgress.stepThreeInProgress,
  };

  final Map<int, HomePageStepProgress> _appStepperSBDStateMap = {
    PERSONAL_DETAILS_POLLING: HomePageStepProgress.stepOneInProgress,
    LOAN_BUSINESS_DETAILS: HomePageStepProgress.stepOneInProgress,
    BUSINESS_DETAILS_POLLING: HomePageStepProgress.stepOneInProgress,
    CO_APPLICANT_DETAILS: HomePageStepProgress.stepOneInProgress,
    LOAN_BANKING_DETAILS: HomePageStepProgress.stepOneInProgress,
    INITIAL_OFFER_POLLING: HomePageStepProgress.stepOneInProgress,
    INITIAL_OFFER_DETAILS: HomePageStepProgress.stepTwoInProgress,
    KYC_AADHAAR: HomePageStepProgress.stepTwoInProgress,
    KYC_SELFIE: HomePageStepProgress.stepTwoInProgress,
    VKYC: HomePageStepProgress.stepTwoInProgress,
    KYC_POLLING: HomePageStepProgress.stepTwoInProgress,
    ADDITIONAL_BUSINESS_DETAILS: HomePageStepProgress.stepTwoInProgress,
    FINAL_OFFER_POLLING: HomePageStepProgress.stepTwoInProgress,
    OFFER: HomePageStepProgress.stepThreeInProgress,
    BANK_DETAILS: HomePageStepProgress.stepThreeInProgress,
    PENNY_TESTING: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_DETAILS: HomePageStepProgress.stepThreeInProgress,
    EMANDATE_POLLING: HomePageStepProgress.stepThreeInProgress,
    LINE_AGREEMENT: HomePageStepProgress.stepThreeInProgress,
    ESIGN_DETAILS: HomePageStepProgress.stepThreeInProgress,
    DISBURSAL_PROGRESS: HomePageStepProgress.stepThreeInProgress,
    STANDALONE_AA: HomePageStepProgress.stepThreeInProgress,
  };

  final Map<int, HomePageStepProgress> _appStepperUPLStateMap = {
    OFFER: HomePageStepProgress.inactive,
    KYC_AADHAAR: HomePageStepProgress.stepOneInProgress,
    KYC_SELFIE: HomePageStepProgress.stepOneInProgress,
    VKYC: HomePageStepProgress.stepOneInProgress,
    KYC_POLLING: HomePageStepProgress.stepOneInProgress,
    BANK_DETAILS: HomePageStepProgress.stepTwoInProgress,
    PENNY_TESTING: HomePageStepProgress.stepTwoInProgress,
    EMANDATE_DETAILS: HomePageStepProgress.stepTwoInProgress,
    EMANDATE_POLLING: HomePageStepProgress.stepTwoInProgress,
    LINE_AGREEMENT: HomePageStepProgress.stepThreeInProgress,
    ESIGN_DETAILS: HomePageStepProgress.stepThreeInProgress,
    DISBURSAL_PROGRESS: HomePageStepProgress.stepThreeCompleted,
    UDYAM: HomePageStepProgress.stepOneInProgress,
    STANDALONE_AA: HomePageStepProgress.stepThreeInProgress,
  };

  _computeStepLabel(
      {required bool isBrowserToAppFlow, required LoanProductCode lpc}) {
    switch (lpc) {
      case LoanProductCode.sbd:
        stepOneLabel = "Basic Details";
        stepTwoLabel = "Final Offer";
        stepThreeLabel = "Disbursal";
        break;
      case LoanProductCode.upl:
      case LoanProductCode.sbl:
        stepOneLabel = "KYC";
        stepTwoLabel = "E-mandate";
        stepThreeLabel = "Disbursal";
        break;
      case LoanProductCode.clp:
        if (isBrowserToAppFlow) {
          stepOneLabel = "KYC";
          stepTwoLabel = "Get offer";
        } else {
          stepOneLabel = "Get offer";
          stepTwoLabel = "KYC";
        }
        stepThreeLabel = "Withdraw";
        break;
    }
  }

  void init({
    required int appState,
    required LoanProductCode loanProductCode,
    required bool isPartnerFlow,
    required bool isBrowserToAppFlow,
  }) {
    Map<int, HomePageStepProgress> currentStepperMap;
    if (isBrowserToAppFlow) {
      currentStepperMap = _b2aAppStepperStateMap;
    } else {
      switch (loanProductCode) {
        case LoanProductCode.sbd:
          currentStepperMap = _appStepperSBDStateMap;
          break;
        case LoanProductCode.upl:
        case LoanProductCode.sbl:
        case LoanProductCode.unknown:
          currentStepperMap = _appStepperUPLStateMap;
          break;
        case LoanProductCode.clp:
        case LoanProductCode.fcl:
          currentStepperMap = _clpAppStepperStateMap;
          break;
      }
    }

    _computeStepState(currentStepperMap[appState]!);
    _computeStepLabel(
        isBrowserToAppFlow: isBrowserToAppFlow, lpc: loanProductCode);
  }
}
