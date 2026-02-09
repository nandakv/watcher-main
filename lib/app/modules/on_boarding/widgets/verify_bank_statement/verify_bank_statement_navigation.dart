
import 'package:privo/app/modules/on_boarding/on_boarding_abstract_class.dart';

import '../../../../models/bank_details_base.dart';

abstract class OnBoardingVerifyBankStatementNavigation extends OnBoardingNavigationBase{

  onVerifyBankStatementFailed();

  navigateToBankDetails();

  onSurrogateOnBoarding();

  onNonSurrogateOnBoarding();

}