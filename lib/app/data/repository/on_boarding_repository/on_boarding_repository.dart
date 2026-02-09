import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';

import '../../../api/http_client.dart';

class OnBoardingRepository extends BaseRepository {
  Future<CheckAppFormModel> getAppFormStatus(
      {String sessionAppFormId = ""}) async {
    ApiResponse apiResponse = await HttpClient.get(
        url:
            "$morpheusBaseUrl/appForm/${sessionAppFormId.isEmpty ? await appFormId : sessionAppFormId}?complete=true");
    return checkAppFormModelFromJson(apiResponse);
  }

  Future postUserDataToServer({required Map body}) async {
    await HttpClient.post(url: "$baseUrl/user/data", body: body);
  }
}
