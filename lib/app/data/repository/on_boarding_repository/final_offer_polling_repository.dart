import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/final_offer_polling/untagged_doc_model.dart';

class FinalOfferPollingRepository extends BaseRepository{
  Future<ApiResponse> addFinalOfferCoApplicant(Map<String,dynamic> coApplicantJson)async{
    ApiResponse apiResponse = await HttpClient.post(url: '$morpheusBaseUrl/business/appForm/$appFormId/applicant',body: coApplicantJson);
    return apiResponse;
  }

  Future<UnTaggedDocModel> getUnTaggedDocs() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
      "$drStrangeBaseUrl/appForm/$appFormId/docsBySection?loanProductCode=SBD",
    );
    return unTaggedDocModelFromJson(apiResponse);
  }
}