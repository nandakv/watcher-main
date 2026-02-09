import 'package:privo/app/services/lpc_service.dart';

import '../../../../mixin/app_analytics_mixin.dart';
import '../../mixins/app_form_mixin.dart';
import 'kyc_verification_logic.dart';

mixin KycAnalyticsMixin on AppAnalyticsMixin {
  late final String aadharOptionScreenLoaded = "Aadhar_Option_Screen_Loaded";
  late final String aadharOptionScreenCtaClick =
      "Aadhar_Option_Screen_CTA_Click";
  late final String aadharStepInfoClicked = "Aadhar_Step_Info_Clicked";

  late final String digilockerString = "digilocker";
  late final String aadhaarOTPString = "aadhar_otp";

  logKYCLoaded() {
    if (LPCService.instance.activeCard != null &&
        ["SBA", "SBD"]
            .contains(LPCService.instance.activeCard!.loanProductCode)) {
      logAppsFlyerEvent(eventName: "KYC_Loaded_SBD");
    }
  }

  logSelfieCompleted() {
    if (LPCService.instance.activeCard != null &&
        ["SBA", "SBD"]
            .contains(LPCService.instance.activeCard!.loanProductCode)) {
      logAppsFlyerEvent(eventName: "KYC_Completed_SBD");
    }
  }

  void logAadharOptionScreenLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: aadharOptionScreenLoaded,
    );
  }

  void logAadharOptionScreenCtaClick(String optionSelected) {
    trackWebEngageEventWithAttribute(
      eventName: aadharOptionScreenCtaClick,
      attributeName: {"option_selected": optionSelected},
    );
  }

  void logAadharOptionScreenStepInfoClick(
      KycVerificationState kycVerificationState) {
    String entryScreen = "";

    switch (kycVerificationState) {
      case KycVerificationState.aadharDetails:
        entryScreen = "otp_screen";
        break;
      case KycVerificationState.aadharMethodSelection:
        entryScreen = "method_selection";
        break;
      default:
    }

    trackWebEngageEventWithAttribute(
        eventName: aadharStepInfoClicked,
        attributeName: {
          "entry_screen": entryScreen,
        });
  }
}
