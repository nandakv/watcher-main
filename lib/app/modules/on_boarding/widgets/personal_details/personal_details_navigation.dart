import 'package:privo/app/modules/know_more_and_get_started/model/lead_details.dart';

import '../../mixins/app_form_mixin.dart';
import '../../on_boarding_abstract_class.dart';

abstract class OnboardingNavigationPersonalDetails
    extends OnBoardingNavigationBase {
  ///Called if personal details are accepted and can be moved to next screen (Employment selector)
  onOnBoardingPersonalDetailsFinished();

  LeadDetails? getLeadDetails();

  setLoanProductCode(LoanProductCode lpc);

}
