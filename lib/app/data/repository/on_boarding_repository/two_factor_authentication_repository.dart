import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

import '../../../api/http_client.dart';
import '../../../models/pan_details_model.dart';
import '../../../models/pan_details_verify_model.dart';

class TwoFactorAuthenticationRepository extends BaseRepository {
  Future<PanDetailsModel> getPanDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrl/verify/panCard",
    );
    return panDetailsModelFromJson(apiResponse);
  }

  Future<PanDetailsVerifyModel> verifyPanDetails({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/verify/panCard",
      body: body,
    );
    return panDetailsVerifyModelFromJson(apiResponse);
  }
}
