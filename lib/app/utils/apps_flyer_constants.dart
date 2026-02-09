import 'package:privo/app/modules/on_boarding/user_state_maps.dart';

class AppsFlyerConstants {
  static const String signUp = "Signup";

  static const String permissionGranted = "Permissions";

  ///personal Details
  static const String personalDetails = "PD complete";
  static const String personalDetailsLoaded = "PD Loaded";
  static const String cpcOverAllApproved = "CPC Overall Approved";

  ///Employment details
  static const String employmentDetails = "ED complete";
  static const String employmentDetailsLoaded = "ED loaded";
  static const String edCompleteSalaried = "ed completed Salaried";
  static const String edCompleteSelfEmployed = "ed completed self employed";

  ///Machine trigger
  static const String machineTriggerRun = "Machine Trigger Run";

  ///Bureau
  static const String bureauRetry = "Bureau retry";
  static const String bureauSuccess = "Bureau Approved";
  static const String bureauReject = "Bureau Rejected";

  ///sanctionletter
  static const String creditLineSanctioned = "CreditLine Sanctioned";
  static const String sanctionLetterLoaded = "Sanction Letter loaded";
  static const String creditLineSanctionAccepted = "Sanctioned line accepted";

  ///Line agreement
  static const String agreementLoaded = "Agreement loaded";
  static const String lineAgreementAccepted = "Agreement accepted";

  static const String creditLineActive = "Creditline activated";

  static const String offerApproved = "FO Approved";
  static const String offerejected = "FO Rejected";

  ///kyc
  static const String kycStarted = "KYC Started";
  static const String aadharLoaded = "Aadhar verification loaded";
  static const String aadharEntered = "Aadhar entered";
  static const String aadharOTPEntered = "Aadhar OTP entered";
  static const String selfieLoaded = "Selfie loaded";
  static const String selfieUploaded = "Selfie uploaded";
  static const String selfieCompleted = "Selfie completed";
  static const String kycRejected = "KYC rejected";
  static const String kycCompleted = "KYC Completed";
  static const String kycApproved = "KYC approved";

  static const String bankDetailsLoaded = "BD loaded";
  static const String pennyDropStart = "Penny drop started";
  static const String pennyDropSuccess = "Penny drop succes";
  static const String pennyDropFailed = "Penny drop failed";
  static const String pennyDropRejected = "Penny drop rejected";
  static const String bankDetailsCompleted = "BD Completed";

  static const String autoPayLoaded = "Autopay loaded";
  static const String autoPayStarted = "Autopay started";
  static const String autoPaySuccess = "Autopay succes";

  static const String withdrawalScreenLoaded = "Withdrawl screen loaded";
  static const String tenureSelected = "Tenure selected";
  static const String amountSelected = "Amount selected";
  static const String purposeSelected = "Purpose selected";
  static const String withdrawalStarted = "Withdrawl started";
  static const String withdrawalSuccess = "Withdrawal success";

  static const Map userStateAppsFlyerMap = {
    UserState.aadhaar: aadharLoaded,
    UserState.selfie: selfieLoaded,
    UserState.workDetails: employmentDetailsLoaded,
    UserState.personalDetails: personalDetailsLoaded
  };
}
