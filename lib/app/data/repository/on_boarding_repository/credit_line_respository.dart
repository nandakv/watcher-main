import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/credit_limit_model.dart';
import 'package:privo/app/models/post_withdrawal_address_response_model.dart';
import 'package:privo/app/models/withdrawal_block_check_model.dart';
import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/models/withdrawal_tenure_response_model.dart';

class CreditLimitRepository extends BaseRepository {
  Future<CreditLimitModel> getWithdrawalLimitDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/appForm/$appFormId/creditLine",
    );
    return creditLimitModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> createCreditLinePost() async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$baseUrl/appForm/$appFormId/creditLine",
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> postWithdrawRequest({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$baseUrl/appForm/$appFormId/withdrawal", body: body);
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<WithdrawalBlockCheckModel> checkWithdrawalBlocked() async {
    ApiResponse apiResponse =
        await HttpClient.get(url: "$shieldBaseUrl/appForm/$appFormId");
    return WithdrawalBlockCheckModel.decodeResponse(apiResponse);
  }

  Future<PostWithdrawalAddressResponseModel> postWithdrawalAddressPost(
      {required Map? body}) async {
    ApiResponse apiResponse = await HttpClient.put(
        url: "$shieldBaseUrl/appForm/$appFormId", body: body);
    return postWithdrawalAddressResponseModelFromJson(apiResponse);
  }

  Future<WithdrawalStatusModel> getAppFormStatus() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/appForm/$appFormId",
    );
    return WithdrawalStatusModel.decodeResponse(apiResponse);
  }

  Future<CheckAppFormModel> getListOfPurposes() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$baseUrl/appForm/$appFormId/creditLine/purpose");
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<WithdrawalCalculationResponseModel> getWithdrawalCalculation(
      {required int loanAmount, required int tenure, Map? requestBody}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url:
          "$baseUrl/appForm/$appFormId/withdrawalCalculation?amount=$loanAmount&tenure=$tenure",
      body: requestBody,
    );
    return withdrawalCalculationResponseModelFromJson(apiResponse);
  }

  Future<WithdrawalTenureResponseModel> getTenureList(
      {required int loanAmount}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url:
            "$baseUrl/appForm/$appFormId/withdrawalCalculation?amount=$loanAmount");
    return withdrawalTenureResponseModelFromJson(apiResponse);
  }
}
