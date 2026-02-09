import 'package:privo/app/api/http_client.dart';

import '../../../../flavors.dart';
import '../../../api/response_model.dart';
import '../../../models/check_app_form_model.dart';
import '../base_repository.dart';

class EmploymentTypeRepository extends BaseRepository {
   Future<CheckAppFormModel> updateEmploymentType( Map body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$baseUrl/appForm/$appFormId/employmentType", body: body);
    return checkAppFormModelFromJson(apiResponse);
  }
}
