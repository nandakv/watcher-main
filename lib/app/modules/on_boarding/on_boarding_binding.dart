import 'package:get/get.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/modules/feedback/feedback_logic.dart';
import 'package:privo/app/modules/file_viewer_dialog/file_viewer_logic.dart';
import 'package:privo/app/modules/on_boarding/aa_stand_alone_journey/aa_stand_alone_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar/aadhaar_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/business_details_polling/business_details_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/ckyc_details/ckyc_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line/credit_line_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/e_mandate_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/eligibility_offer/eligibility_offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/employment_type/employment_type_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer/initial_offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/initial_offer_polling/initial_offer_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_screen_polling/offer_screen_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_polling/offer_upgrade_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/otp_udyam_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/upl_withdrawal_loading/upl_withdrawal_loading_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_logic.dart';
import 'on_boarding_logic.dart';
import 'widgets/final_offer_polling/final_offer_polling_logic.dart';
import 'widgets/kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'widgets/pdf_letter/pdf_letter_logic.dart';
import 'widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field_logic.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnBoardingLogic());

    Get.lazyPut(() => PersonalDetailsLogic());
    Get.lazyPut(() => PersonalDetailsPollingLogic());
    Get.lazyPut(() => PersonalDetailsDOBFieldLogic());
    Get.lazyPut(() => EmploymentTypeLogic());
    Get.lazyPut(() => WorkDetailsLogic());
    Get.lazyPut(() => VerifyBankStatementLogic());
    Get.lazyPut(() => BankDetailsLogic());
    Get.lazyPut(() => ProcessingBankDetailsLogic());
    Get.lazyPut(() => EMandateLogic());

    Get.lazyPut(() => CKYCDetailsLogic());

    Get.lazyPut(() => CreditLineLogic());

    Get.lazyPut(() => AadhaarLogic());

    Get.lazyPut(() => AdditionalBusinessDetailsLogic());

    Get.lazyPut(() => CreditLineApprovedLogic());

    Get.lazyPut(() => ESignLogic());

    // Get.lazyPut(() => SelfieLogic());

    // Get.lazyPut(() => KycPollingLogic());
    Get.lazyPut(() => InitialOfferPollingLogic());
    Get.lazyPut(() => InitialOfferLogic());

    Get.lazyPut(() => AadhaarApiLogic());
    Get.lazyPut(() => OfferScreenPollingLogic());
    Get.lazyPut(() => PDFLetterLogic());
    Get.lazyPut(() => OfferLogic());
    Get.lazyPut(() => EligibilityOfferLogic());
    Get.lazyPut(() => UPLWithdrawalLoadingLogic());
    Get.lazyPut(() => KycVerificationLogic());
    Get.lazyPut(() => DigioDigilockerAadhaarLogic());
    Get.lazyPut(() => OfferUpgradeBankSelectionLogic());
    Get.lazyPut(() => OfferUpgradePollingLogic());
    Get.lazyPut(() => DigioDigilockerAadhaarLogic());
    Get.lazyPut(() => FeedbackLogic());
    Get.lazyPut(() => EMandatePollingLogic());
    Get.lazyPut(() => FinalOfferPollingLogic());
    Get.lazyPut(() => OtpUdyamLogic());
    Get.lazyPut(() => AAStandAloneLogic());

    ///SBD Logics
    Get.lazyPut(() => SBDBusinessDetailsLogic());
    Get.lazyPut(() => BusinessDetailsPollingLogic());
    Get.lazyPut(() => CoApplicantDetailsLogic());
  }
}
