import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/models/karza_employee_search_model.dart';

import '../../../api/response_model.dart';
import '../../../models/check_app_form_model.dart';
import '../base_repository.dart';

class WorkDetailsRepository extends BaseRepository {
  Future<CheckAppFormModel> updateWorkDetails(Map body,String url) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: url,
      body: body,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<KarzaEmployeeSearchModel> searchEmployeer(Map body) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$karzaUrl/employer-search",
      body: body,
      authType: AuthType.karza,
    );
    return karzaEmployeeSearchModelFromJson(apiResponse);
  }
}
