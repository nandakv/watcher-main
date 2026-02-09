import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';

import '../../../models/check_app_form_model.dart';
import '../../../models/eligibility_offer_model.dart';
import '../../../models/info_text_model.dart';

class OfferRepository extends BaseRepository {
  // offer and insurance details
  Future<PreApprovalOfferModel> fetchOfferDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrl/offerDetail/$appFormId",
    );
    return initialOfferModelFromJson(apiResponse);
  }

  Future<EligibilityOfferModel> fetchEligibilityOfferDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrl/offerDetail/$appFormId/eligibilityOffer",
    );
    return eligibilityOfferModelFromJson(apiResponse);
  }

  Future<InfoTextListModel> fetchInfoText() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrl/offerDetail/countOfPurpose",
    );
    return infoTextModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> recordConsent(Map<dynamic, dynamic> body) async {
    ApiResponse response = await HttpClient.post(
      url: "$morpheusBaseUrl/appForm/$appFormId/record-consent",
      body: body,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getKfsStatementLetter(String letterType) async {
    ApiResponse response = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/getLetterUrl?letterType=$letterType",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }
}
