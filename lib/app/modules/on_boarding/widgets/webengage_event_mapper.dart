import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../firebase/analytics.dart';
import '../../../mixin/app_analytics_mixin.dart';
import '../user_state_maps.dart';

class WebEngageEventMapper with AppAnalyticsMixin,
          PersonalDetailsPollingAnalyticsMixin {
  Map<UserState, String> get getBackPressEvent => {
        UserState.personalDetails: WebEngageConstants.personalDetailBackButton,
        UserState.personalDetailsPolling: pdPollingFullScreenClosed,
        UserState.workDetails: WebEngageConstants.employmentDetailsBackButton,
        UserState.showLineAgreement: WebEngageConstants.lineAgreementBackButton,
        UserState.selfie: WebEngageConstants.selfieScreenBackButton,
        UserState.creditLineApproved:
            WebEngageConstants.lineActivationBackButton,
        UserState.bankDetails: WebEngageConstants.addBankScreenBackButton,
        UserState.eMandateDetails:
            WebEngageConstants.setUpAutoPayBackScreenClicked,
        UserState.eMandateSuccess:
            WebEngageConstants.eMandateSuccessScreenBackButtonClicked,
        UserState.eMandateFailure:
            WebEngageConstants.eMandateFailureScreenBackButtonClicked,
        UserState.processingApplication:
            WebEngageConstants.pennyTestWaitBackScreenClicked,
        UserState.aaStandAloneBankSelection:
            WebEngageConstants.aaBotfInitiationCrossButtonClicked,
      };

  onBackPressEventTrigger(UserState userState) {
    if (doesEventExists(userState)) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: getBackPressEvent[userState]!);
    }
  }

  doesEventExists(UserState userState) {
    return getBackPressEvent.keys.contains(userState);
  }
}
