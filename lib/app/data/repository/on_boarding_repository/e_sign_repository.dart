import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/e_sign_download_model.dart';

import '../../../api/http_client.dart';
import '../../../api/response_model.dart';
import '../../../models/generate_doc_sign_model.dart';
import '../../../models/request_doc_sign_model.dart';

class ESignRepository extends BaseRepository {
  /// For generating the Loan agreement
  Future<GenerateDocSignModel> generateDocSign({required String lpc}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$drStrangeBaseUrl/appForm/$appFormId/generateDocSign",
        body: {
          "docType": "Loan Agreement",
          "docTypeSigned": "Loan Agreement",
          "templateType": "LOAN_AGREEMENT",
          "lpc": lpc,
        });
    return generateDocSignModelFromJson(apiResponse);
  }

  /// E-stamp will be attached on the Loan agreement and get the document id and access token
  Future<RequestDocSignModel> requestDocSign({required String lpc}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$drStrangeBaseUrl/appForm/$appFormId/requestDocSign",
        body: {
          "docType": "Loan Agreement",
          "docTypeSigned": "Loan Agreement",
          "templateType": "LOAN_AGREEMENT",
          "lpc": lpc,
        });
    return requestDocSignModelFromJson(apiResponse);
  }

  Future<ESignDownloadModel> getESignLink({required String docId}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url:
            "$poseidonBaseUrl/eSign/$docId/download?appFormId=$appFormId");
    return eSignDownloadModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> sendS3DocId({required String docId}) async {
    ApiResponse apiResponse = await HttpClient.put(
      url: "$baseUrl/appForm/$appFormId/uploadSignedLA",
      body: {"docId": docId},
    );
    return checkAppFormModelFromJson(apiResponse);
  }
}
