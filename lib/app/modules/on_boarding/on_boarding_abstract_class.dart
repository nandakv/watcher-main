import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';

abstract class OnBoardingNavigationBase {
  ///AppformRejected to be written here
  onAppFormRejected({required AppFormRejectionModel model});

  toggleBack({required bool isBackDisabled});

  bool isPartnerFlow();

  toggleAppBarTitle(bool value);

  toggleAppBarVisibility(bool value);

  changeAppBarTopTitleText(String value);

  changeAppBarTitle(String title, String subTitle);

  navigateUserToAppStage({required SequenceEngineModel sequenceEngineModel});

//To fetch the sequence engine details for the next screen stage
  SequenceEngineModel getSequenceEngineDetails();

  //Compute request method type from the current sequence engine
  String computeMethodFromSequenceEngine();

  //Get the request/submitUrl from the current sequence engine
  String getRequestUrl();

  onPersonalDetailsPollSuccess();
}
