import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/e_mandate/e_mandate_bank_model.dart';
import 'package:privo/app/models/emandate_response_model.dart';

import '../../../models/supported_banks_model.dart';

class EmandateRepository extends BaseRepository {
  Future<EMandateResponseModel> getEMandatePost() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$valBaseUrl/mandate/$appFormId?pennyTestingSuccess=true&mandateMethod=emandate",
    );
    return eMandateResponseModelFromJson(apiResponse);
  }

  Future<EMandateResponseModel> startEmandatePost({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/appForm/$appFormId/mandate",
      body: body,
    );
    return eMandateResponseModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> getCompleteAppFormStatusGet() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/appForm/$appFormId?complete=true",
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> postMandateAction() async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/appForm/$appFormId/mandateAction",
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<BanksModel> getJusPayMandateType() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$morpheusBaseUrl/appForm/$appFormId/mandateMethods");
    return BanksModel.decodeResponse(apiResponse);
  }

  Future<EMandateBankModel> getEMandateBank() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$morpheusBaseUrlVersion2/appForm/$appFormId/mandate/bankAccount");
    return EMandateBankModel.decodeResponse(apiResponse);
  }

}
