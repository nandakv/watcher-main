import 'package:privo/app/data/repository/base_repository.dart';

import '../../../flavors.dart';
import '../../amplify/auth/amplify_auth.dart';
import '../../api/http_client.dart';
import '../../api/response_model.dart';
import 'ab_testing_model.dart';

class AbTestingRepository extends BaseRepository{
  Future<ABTestingModel> abtUtility({required String expName}) async {
    Map<String, dynamic> body = {
      "exp_name": expName,
      "entity_value": await AmplifyAuth.userID
    };
    ApiResponse apiResponse = await HttpClient.post(
        url: "${F.envVariables.privoBaseURL}/api/v1/abtUtility", body: body);
    return abUserModelFromJson(apiResponse);
  }
}