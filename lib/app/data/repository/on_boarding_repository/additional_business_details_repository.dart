import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/additional_business_details_model.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/models/file_tag_model.dart';
import 'package:privo/app/models/final_offer_polling/appform_tag_doc_model.dart';

class AdditionalBusinessDetailsRepository extends BaseRepository {
  Future<DocumentTypeListModel> getDocumentTypeList(
      String entityId, String lpc,String loanAppFormId) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$drStrangeBaseUrl/appForm/$loanAppFormId/docsBySection?loanProductCode=$lpc",
    );
    return documentTypeListModelFromJson(apiResponse, entityId: entityId);
  }

  Future<AppFormTagDocModel> tagAppFormDoc(
      {required List<String> s3Urls, required String appFormId}) async {
    Map body = {
      "s3Urls": s3Urls,
      "appFormId": appFormId,
      "osvStatus": true,
    };
    ApiResponse apiResponse = await HttpClient.post(
        url: "$drStrangeBaseUrl/appForm/$appFormId/tagMultiple", body: body);
    return appFormTagModelFromJson(apiResponse);
  }

  Future<FileTagModel> tagFile({
    required String s3Url,
    required String applicantId,
    required String docTypeId,
    required String? sectionId,
  }) async {
    Map body = {
      "s3Urls": [s3Url],
      "applicantId": applicantId,
      "osvStatus": true,
      "docTypeId": docTypeId,
      "sectionId": sectionId,
    };
    ApiResponse apiResponse = await HttpClient.post(
      // need to add loanappform
        url: "$drStrangeBaseUrl/appForm/$appFormId/tagMultiple", body: body);
    return fileTagModelFromJson(apiResponse);
  }

  Future<ApiResponse> deleteFile(int docId) async {
    ApiResponse apiResponse = await HttpClient.delete(
      url:
          "$drStrangeBaseUrl/appForm/$appFormId/appFormDoc/appFormDocId/$docId",
    );
    return apiResponse;
  }

  Future<ApiResponse> postDocumentConsent(Map<dynamic, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/business/appForm/$appFormId/document/consent",
      body: body,
    );
    return apiResponse;
  }

  Future<AdditionalBusinessDetailsModel> getAdditionalBusinessDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$morpheusBaseUrl/business/appForm/$appFormId/additionalBusinessDetails",
    );

    return additionalBusinessDetailsModelFromJson(apiResponse);
  }
}
