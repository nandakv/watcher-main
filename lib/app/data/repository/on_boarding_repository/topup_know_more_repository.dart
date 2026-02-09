import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

import '../../../models/check_app_form_model.dart';

class TopUpKnowMoreRepository extends BaseRepository {
  Future<CheckAppFormModel> recordConsent(Map<dynamic, dynamic> body) async {
    ApiResponse response = await HttpClient.post(
      url: "$morpheusBaseUrl/appForm/$appFormId/record-consent",
      body: body,
    );
    return checkAppFormModelFromJson(response);
  }
}
