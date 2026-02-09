import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';

import '../../../../common_widgets/privo_text_editing_controller.dart';
import '../search_screen/search_result.dart';

class UserWorkDetails {
  PrivoTextEditingController companyNameController =
      PrivoTextEditingController();

  PrivoTextEditingController incomeController = PrivoTextEditingController();
  PrivoTextEditingController employmentTypeController =
      PrivoTextEditingController();

  EmploymentType employmentType = EmploymentType.none;
  int? selectedIncomeType;
  late SearchResult searchResult;

  bool isPartnerFlow = false;
}
