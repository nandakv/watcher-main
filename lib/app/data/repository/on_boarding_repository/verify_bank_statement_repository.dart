import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/perfios_process_status_response_model.dart';
import 'package:privo/app/models/perfios_response_model.dart';

import '../../../api/http_client.dart';
import '../../../models/loans_pdf_model.dart';
import '../../../models/supported_banks_model.dart';

class VerifyBankStatementRepository extends BaseRepository {
  Future<SupportedBanksModel> getBanks() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/supportedBanks",
    );
    return supportedBanksNameModelFromJson(apiResponse);
  }

  ///Function to post the state management model
  Future<PerfiosResponseModel> startPerfiosProcess({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/perfios/start", body: body);
    return perfiosResponseModelFromJson(apiResponse);
  }

  Future<PerfiosProcessStatus> getPerfiosReportStatus() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$batManBaseUrl/process/status?appId=${await AppAuthProvider.appFormID}",
    );
    return perfiosProcessStatusResponseModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> getUserBankDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$morpheusBaseUrl/perfios/getAccountDetails?app_form_id=${await AppAuthProvider.appFormID}",
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<PreApprovalOfferModel> checkInitialOfferPost() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/${await AppAuthProvider.appFormID}/inference?inference_type=preapproval_inference",
    );
    return initialOfferModelFromJson(apiResponse);
  }

   Future<CheckAppFormModel> getSanctionLetter() async {
    ApiResponse response = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/letter?letterType=sanction_letter",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getLineAgreement() async {
    ApiResponse response = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/letter?letterType=loan_agreement",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getEnhancedOfferAgreementAccepted() async {
    ApiResponse response = await HttpClient.post(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/letterAcceptance?letter_type=ENHANCED_OFFER_LOAN_AGREEMENT",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getPDFLetterURL(
      {required String pdfLetterType}) async {
    ApiResponse response = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/getLetterUrl?letterType=$pdfLetterType",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getEnhancedOfferAgreement() async {
    ApiResponse response = await HttpClient.get(
      url:
          "$morpheusBaseUrl/appForm/$appFormId/getLetterUrl?letterType=ENHANCED_OFFER_LOAN_AGREEMENT",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<CheckAppFormModel> getLetterDownloadURL(String letterType) async {
    ApiResponse response = await HttpClient.get(
      url: "$morpheusBaseUrl/appForm/$appFormId/letter?letterType=$letterType",
      authType: AuthType.token,
    );
    return checkAppFormModelFromJson(response);
  }

  Future<LoansPDFModel> getLoanDetailsLetterDownloadURL(
      String letterType, String loanId,String appForm) async {
    ApiResponse response = await HttpClient.get(
      url:
          "$aquManBaseUrl/loan/$loanId/letter?letterType=$letterType&appFormId=$appForm&lpc=${await AppAuthProvider.getLpc}",
      authType: AuthType.token,
    );
    return LoansPDFModelFromJson(response);
  }
}
