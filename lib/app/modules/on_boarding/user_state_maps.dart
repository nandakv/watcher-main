// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_view.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/widgets/emandate_polling_failure_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/widgets/emandate_success_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/set_up_e_mandate.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/e_mandate_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/eligibility_offer/eligibility_offer_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer/initial_offer_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer_polling/initial_offer_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/kfs/offer_and_kfs_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_screen_polling/offer_screen_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_polling/offer_upgrade_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/udyam/udyam_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/pdf_letter/pdf_letter_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/penny_testing_failure_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_widget.dart';

import '../../../res.dart';
import '../../common_widgets/exit_page.dart';
import '../../common_widgets/retry_page.dart';
import '../../common_widgets/success_widget.dart';
import '../additional_business_details/top_up_personal_details.dart';
import 'aa_stand_alone_journey/aa_stand_alone_screen_view.dart';
import 'widgets/bank_details/bank_details_screen.dart';
import 'widgets/business_details_polling/business_details_polling_view.dart';
import 'widgets/e-sign_agreement_screen.dart';
import 'widgets/ckyc_details/ckyc_details.dart';
import 'widgets/credit_line/credit_line_rejected_screen.dart';
import 'widgets/credit_line_approved/credit_line_approved.dart';
import 'widgets/employment_type/employment_type_screen.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_verification_view.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_success_screen.dart';
import 'widgets/pdf_letter/pdf_letter_view.dart';
import 'widgets/processing_bank_details/processing_application_view.dart';
import 'widgets/upl_withdrawal_loading/upl_withdrawal_loading_view.dart';

const PERSONAL_DETAILS = 0;
const EMPLOYEMENT_TYPE = 1;
const WORK_DETAILS = 2;
const VERIFY_BANK_DETAILS = 3;
const BANK_DETAILS = 4;
const PENNY_TESTING = 5;
const OFFER = 6;
const CKYC_DETAILS = 8;
const KYC_AADHAAR = 9;
const KYC_SELFIE = 10;
const KYC_POLLING = 11;
const KYC_SUCCESS = 12;
const CREDIT_LINE_APPROVED = 13;
const EMANDATE_DETAILS = 14;
const EMANDATE_SUCCESS = 15;
const ESIGN_DETAILS = 16;
const ESIGN_SUCCESS = 17;
const DISBURSAL_PROGRESS = 18;
const APP_FORM_REJECTED = 19;
const EMANDATE_FAILURE = 20;
const ESIGN_FAILURE = 21;
const BANK_VERIFICATION_FAILED = 22;
const CREDIT_LINE_REJECTED = 23;
const CREDIT_LINE_FAILED = 24;
const LOADING = 25;
const BUREAU_POLLING = 26;
const OFFER_POLLING = 27;
const SANCTION_LETTER = 28;
const LINE_AGREEMENT = 29;
const AA_BANK_SELECTION = 30;
const AA_POLLING = 31;
const VKYC = 33;
const ELIGIBILITY_POLLING = 34;
const ELIGIBILITY_OFFER = 35;
//the below states are for sbl web app
const BUSINESS_DETAILS = 36;
const APPLICANT_DETAILS = 37;
const BANKING_DETAILS = 38;
const LOAN_OFFER_POLLING = 39;
const LOAN_OFFER_DETAILS = 40;
const DOCUMENTS_UPLOAD = 41;
//app states continues
const EMANDATE_POLLING = 42;

// SBD - Small Business Direct Loans
const int PERSONAL_DETAILS_POLLING = 43;
const int LOAN_BUSINESS_DETAILS = 44;
const int CO_APPLICANT_DETAILS = 45;
const int BUSINESS_DETAILS_POLLING = 46;
const int LOAN_BANKING_DETAILS = 47;
const int INITIAL_OFFER_POLLING = 48;
const int INITIAL_OFFER_DETAILS = 49;
const int ADDITIONAL_BUSINESS_DETAILS = 50;
const int FINAL_OFFER_POLLING = 51;
const int UDYAM = 52;
const int STANDALONE_AA = 53;

const SERVICING_SCREENS = 100;

Map<String, dynamic> userStageDetails = {
  "PERSONAL_DETAILS": UserState.personalDetails,
  "WORK_DETAILS": UserState.workDetails,
  "OFFER_UPGRADE": UserState.offerUpgradeBankSelection,
  "OFFER_UPGRADE_POLLING": UserState.offerUpgradePolling,
  "BUREAU_POLLING": UserState.offerScreenPolling,
  "OFFER_POLLING": UserState.offerScreenPolling,
  "OFFER_DETAILS": UserState.offer,
  "KYC_AADHAAR": UserState.aadhaar,
  "KYC_SELFIE": UserState.selfie,
  "KYC_POLLING": UserState.sitBack,
  "KYC_SUCCESS": UserState.kycSuccess,
  "AGREEMENT_DETAILS": UserState.showLineAgreement,
  "CREDIT_LINE": UserState.creditLineApproved,
  "BANK_DETAILS": UserState.bankDetails,
  "PENNY_TESTING": UserState.processingApplication,
  "EMANDATE_DETAILS": UserState.eMandateDetails,
  "ESIGN_DETAILS": UserState.eSignDetails,
  "VIDEO_KYC": UserState.vKYC,
  "PAYOUT_DETAILS": UserState.uplDisbursalProgress,
  "ELIGIBILITY_POLLING": UserState.offerScreenPolling,
  "ELIGIBILITY_OFFER": UserState.eligibilityOffer,
  "EMANDATE_POLLING": UserState.eMandatePolling,
  "PERSONAL_DETAILS_POLLING": UserState.personalDetailsPolling, // 43
  "LOAN_BUSINESS_DETAILS": UserState.loanBusinessDetails, // 44
  "LOAN_APPLICANT_DETAILS": UserState.coApplicantDetails, // 45
  "BUSINESS_DETAILS_POLLING": UserState.businessDetailsPolling, // 46
  "LOAN_BANKING_DETAILS": UserState.loanBankingDetails, // 47
  "INITIAL_OFFER_POLLING": UserState.initialOfferPolling, // 48
  "INITIAL_OFFER_DETAILS": UserState.initialOffer, // 49
  "ADDITIONAL_BUSINESS_DETAILS": UserState.additionalBusinessDetails, // 50
  "FINAL_OFFER_POLLING": UserState.finalOfferPolling, // 51
  "UDYAM": UserState.otpUdyamDetails, // 52
  "STAND_ALONE_AA": UserState.aaStandAloneBankSelection //53
};

///Please do not change the order of the states in the below enum
enum UserState {
  personalDetails, //0
  employmentType, //1
  workDetails, //2
  verifyBankDetails, //3
  bankDetails, //4
  processingApplication, //5
  offer, //6
  sitBackCKycDetails, //7
  cKycDetails, //8
  aadhaar, //9
  selfie, //10
  sitBack, //11
  kycSuccess, //12
  creditLineApproved, //13
  eMandateDetails, //14
  eMandateSuccess, //15
  eSignDetails, //16
  eSignSuccess, //17
  uplDisbursalProgress, //18
  appFormRejected, //19
  eMandateFailure, //20
  eSignFailure, //21
  bankVerifyFailed, //22
  creditLineRejected, //23
  creditLineFailed, //24
  loading, //25
  bureauCheckPolling, //26
  offerScreenPolling, //27
  showSanctionLetter, //28
  showLineAgreement, //29,
  offerUpgradeBankSelection, //30
  offerUpgradePolling, //31
  awaitingFullfillment, //32
  vKYC, //33
  eligibilityPolling, //34
  eligibilityOffer, //35
  businessDetails, //36
  applicantDetails, //37
  bankingDetails, //38
  loanOfferPolling, //39
  loanOfferDetails, //40
  documentsUpload, //41
  eMandatePolling, //42
  personalDetailsPolling, // 43
  loanBusinessDetails, // 44
  coApplicantDetails, // 45
  businessDetailsPolling, // 46
  loanBankingDetails, // 47
  initialOfferPolling, // 48
  initialOffer, // 49
  additionalBusinessDetails, // 50
  finalOfferPolling, // 51
  otpUdyamDetails, // 52
  aaStandAloneBankSelection //53
}

Map<UserState, Widget> get getUserStateWidget => {
      //loading state
      UserState.loading: const Center(
        child: CircularProgressIndicator(),
      ),
      //0
      UserState.personalDetails: const PersonalDetailsScreen(),
      //1
      UserState.employmentType: const EmploymentTypeScreen(),
      //2
      UserState.workDetails: const WorkDetailsWidget(),
      //3
      // UserState.verifyBankDetails: const VerifyBankStatementScreen(),
      //4
      UserState.bankDetails: const BankDetailsScreen(),
      //5
      UserState.processingApplication: const ProcessingApplicationView(),
      //6
      UserState.offer: const OfferAndKFSScreen(),
      //8
      UserState.cKycDetails: const CKYCDetails(),
      //9
      UserState.aadhaar:
         KycVerificationView(userState: KycVerificationState.aadhaar),
      //10
      UserState.selfie:
          KycVerificationView(userState: KycVerificationState.selfie),
      //33
      UserState.vKYC: KycVerificationView(userState: KycVerificationState.vKYC),
      //11
      UserState.sitBack:
          KycVerificationView(userState: KycVerificationState.polling),
      //12
      UserState.kycSuccess: KycSuccessScreen(),
      //13
      UserState.creditLineApproved: const CreditLineApproved(),
      //14
      UserState.eMandateDetails: const SetUpEMandateWidget(),
      //15
      UserState.eMandateSuccess: EMandateSuccessScreen(),
      //16
      UserState.eSignDetails: const ESignAgreementScreen(isRejected: false),
      // 17
      UserState.eSignSuccess: const SuccessRejectWidget(
        textMessage: "E - sign successful!",
        subTitle:
            "Loan agreement has been sent to your registered email and SMS",
        image: Res.verified_svg,
      ),
      //18
      UserState.uplDisbursalProgress: UPLWithdrawalPollingView(),
      //19
      UserState.appFormRejected: ExitPage(
        assetImage: Res.appform_rejected_svg,
        showButton: false,
      ),
      //20
      UserState.eMandateFailure: EmandateFailureScreen(),
      //21
      UserState.eSignFailure: RetryPageWidget(
        title: "Sorry, your E-sign failed",
        assetImage: Res.eSignImg,
        isSVG: true,
        userState: UserState.eSignFailure,
      ),
      // 22
      UserState.bankVerifyFailed: PennyTestingFailureWidget(),
      //23
      UserState.creditLineRejected: const CreditLineRejectedScreen(),
      //24
      UserState.creditLineFailed: RetryPageWidget(
          title:
              "Sorry, Something went wrong. Please contact our support team.",
          assetImage: Res.Rejected,
          userState: UserState.uplDisbursalProgress,
          isSVG: true),
      //26
      UserState.bureauCheckPolling: const OfferScreenPollingView(),
      //27
      UserState.offerScreenPolling: const OfferScreenPollingView(),
      //28
      UserState.showSanctionLetter:
          const PDFLetterPage(pdfLetterType: PDFLetterType.sanctionLetter),
      //29
      UserState.showLineAgreement:
          const PDFLetterPage(pdfLetterType: PDFLetterType.lineAgreement),
      //30
      UserState.offerUpgradeBankSelection:
          const OfferUpgradeBankSelectionView(),
      //31
      UserState.offerUpgradePolling: const OfferUpgradePollingView(),
      //34
      UserState.eligibilityPolling: const OfferScreenPollingView(),
      //35
      UserState.eligibilityOffer: const EligibilityOffer(),
      //intermediate states are for sbl web app
      //42
      UserState.eMandatePolling: EMandatePollingPage(),

      //43
      UserState.personalDetailsPolling: const PersonalDetailsPollingView(),
      //44
      UserState.loanBusinessDetails: const SBDBusinessDetailsView(),
      UserState.coApplicantDetails: const CoApplicantDetailsView(),
      UserState.businessDetailsPolling: const BusinessDetailsPollingView(),

      ///reusing [offerUpgradeBankSelection] screen
      UserState.loanBankingDetails: const OfferUpgradeBankSelectionView(),
      UserState.initialOfferPolling: const InitialOfferPollingView(),
      UserState.initialOffer: const InitialOfferScreen(),
      UserState.additionalBusinessDetails: VerifyPersonalDetails(),
      UserState.finalOfferPolling: FinalOfferPollingPage(),
      UserState.otpUdyamDetails: const UdyamScreen(),
      UserState.aaStandAloneBankSelection:  AAStandAloneScreenView(),
    };
