import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/user_consent_response_model.dart';

import '../../../../flavors.dart';
import '../../provider/auth_provider.dart';

class CompleteKycRepository extends BaseRepository {
  Future<CheckAppFormModel> checkPreApprovalOfferPost() async {
    ApiResponse apiResponse = await HttpClient.post(
      url:
          "${F.envVariables.privoBaseURL}/api/v1/poll?app_form_id=$appFormId&type=bureau_and_offer",
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<UserConsentResponseModel> updateUserConsent() async {
    ApiResponse apiResponse = await HttpClient.put(
        url: "$shieldBaseUrl/appForm/$appFormId/consent/CKYC");
    return userConsentResponseModelFromJson(apiResponse);
  }

  Future postUserState(int appState) async {
    await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/update",
      body: {
        "app_state": "$appState",
      },
    );
  }
}
