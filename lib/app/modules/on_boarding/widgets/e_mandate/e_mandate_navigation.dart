import 'package:privo/app/modules/on_boarding/on_boarding_abstract_class.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';

abstract class OnBoardingEMandateNavigation extends OnBoardingNavigationBase{
  onEMandateFinished();
  onEMandateFailed();
  onEMandateFailureTryAgainClicked();

  getEMandateState(EMandateState eMandateState);

}