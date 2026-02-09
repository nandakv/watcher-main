import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/penny_status_model.dart';
import 'package:privo/app/models/penny_success_model_response_model.dart';
import 'package:privo/app/models/penny_testing_status_model.dart';

import '../../../../flavors.dart';
import '../../../api/http_client.dart';

class ProcessingBankDetailsRepository extends BaseRepository {
  Future<PennyStatusModel> checkPennyTestingStatus() async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "${F.envVariables.privoBaseURL}/api/v1/poll?app_form_id=$appFormId&type=penny_testing",
    );
    return pennyStatusModelFromJson(apiResponse);
  }

  Future<PennyStatusModel> startPennyTesting({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$baseUrl/appForm/$appFormId/pennyTesting", body: body);
    return pennyStatusModelFromJson(apiResponse);
  }

  Future<PennySuccessResponseModel> postPennyAsSuccess(
      {required String status}) async {
    ApiResponse apiResponse = await HttpClient.put(
        url: "${F.envVariables.scroogeBaseURL}/api/v1/appForm/$appFormId/pennyTest?status=$status",
        authType: AuthType.scrooge);
    return pennySuccessResponseModelFromJson(apiResponse);
  }
}
