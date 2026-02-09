import 'package:privo/app/models/co_applicant_list_model.dart';

abstract class AddCoApplicantHandler {
  onSavePressed(List<CoApplicantDetail> coApplicantDetailsList);

  onClosed();
}
