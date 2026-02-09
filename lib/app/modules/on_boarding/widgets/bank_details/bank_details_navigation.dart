import 'package:privo/app/models/penny_testing_data_transfer_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';

import '../../on_boarding_abstract_class.dart';

abstract class OnboardingNavigationBankDetails
    extends OnBoardingNavigationBase {
  onOnBoardingBankDetailsFinished();

  goBackToVerifyBankStatementSelector();

  OnBoardingType onBoardingType();

  setPennyTestingData(PennyTestingDataTransferModel pennyTestingData);
}
