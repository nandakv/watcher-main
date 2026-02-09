import 'package:privo/app/models/bank_details_base.dart';
import 'package:privo/app/models/penny_testing_data_transfer_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';

import '../../on_boarding_abstract_class.dart';
import '../../on_boarding_logic.dart';

abstract class OnboardingNavigationProcessingBankDetails
    extends OnBoardingNavigationBase {
  ///Called if personal details are accepted and can be moved to next screen (Employment selector)
  onOnBoardingProcessingBankDetailsFinished();

  BankDetailsModel bankDetailsForPennyTesting();

  onOnBoardingProcessingBankDetailsFailed();

  onGoToBankDetailsClicked();

  OnBoardingType onBoardingType();

  PennyTestingDataTransferModel? getPennyTestingData();
}
