import 'package:privo/app/amplify/models/otp_response_model.dart';
import 'package:privo/app/models/experian_consent_model.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_response_model.dart';
import 'package:privo/app/models/credit_score_request_model.dart';
import 'package:privo/app/modules/masked_credit_score/models/masked_otp_response_model.dart';

import '../../../flavors.dart';
import '../../api/http_client.dart';
import '../../api/response_model.dart';
import '../../modules/credit_report/widgets/credit_score_line_graph/credit_scoreline_graph_model.dart';
import '../../modules/masked_credit_score/models/masked_mobile_response_model.dart';
import 'base_repository.dart';

class CreditReportRepository extends BaseRepository {
  Future<CreditReportResponseModel> getCreditReport() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$magnusBaseUrl/finTools/experianD2CReportVersion2",
    );
    return CreditReportResponseModel.decodeResponse(apiResponse);
  }

  //post call if pull type is "COMPLETED"
  Future<CreditReportResponseModel> getCreditReportWithPhoneNumber(
      {required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$magnusBaseUrl/finTools/experianD2CReport",
      body: body
    );
    return CreditReportResponseModel.decodeResponse(apiResponse);
  }

  Future<CreditReportResponseModel> getStatelessCreditReport(
      {required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$magnusBaseUrl/finTools/fetchFinsightsWithPhone", body: body);
    return CreditReportResponseModel.decodeResponse(apiResponse);
  }

  Future<ExperianConsentModel> checkConsentStatus() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$morpheusBaseUrl/experianD2C/${await phoneNumber}/consent/experian_d2c",
    );
    return ExperianConsentModel.decodeResponse(apiResponse);
  }

  //slide to refresh and on click of refresh calling this api
  Future<CreditScoreRequestModel> initiatePullCreditScore(
      {required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/experianD2C/pullExperianD2C", body: body);
    return creditScoreRequestModelFromJson(apiResponse);
  }

  Future<MaskedMobileResponseModel> experianD2CMaskedMobileCall(
      {required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/experianD2C/maskedMobile", body: body);
    return maskedMobileResponseModelFromJson(apiResponse);
  }

  Future<MaskedOTPResponseModel> fetchOtp({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "${F.envVariables.privoBaseURL}/api/v1/otp/send", body: body);
    return maskedOTPResponseModelFromJson(apiResponse);
  }

  Future<MaskedOTPResponseModel> verifyOtp({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "${F.envVariables.privoBaseURL}/api/v1/otp/verify", body: body);
    return maskedOTPResponseModelFromJson(apiResponse);
  }

  Future<CreditScoreLineGraphModel> getCreditScoreHistory() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$magnusBaseUrl/finTools/creditScore/history",
    );
    return CreditScoreLineGraphModel.decodeResponse(apiResponse);
  }
}
