import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_polling_model.dart';
import 'package:privo/app/models/offer_upgrade/perfios_bank_statement_model.dart';

import '../../../../flavors.dart';
import '../../../api/http_client.dart';
import '../../../api/response_model.dart';
import '../../../models/offer_upgrade/aa_consent_model.dart';
import '../../../models/offer_upgrade/bank_report_initiate_model.dart';
import '../../../models/offer_upgrade/bank_report_model.dart';
import '../../../models/supported_banks_model.dart';

class OfferUpgradeRepository extends BaseRepository {
  Future<SupportedBanksModel> getBanks(String loanProductCode) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/supportedBanks?loanProductCode=$loanProductCode",
    );
    return supportedBanksNameModelFromJson(apiResponse);
  }

  Future<ApiResponse> submitBankDetailsConsent() async {
    Map<String, dynamic> body = {
      "consent": {
        "sbd_bank_details": "Yes",
        "sbd_bank_details_created_at": DateTime.now().toString(),
      }
    };
    ApiResponse apiResponse = await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/update",
      body: body,
    );
    return apiResponse;
  }

  // Future<AAConsentModel> getAAConsent(
  //     String bankFipID, String mobileNumber) async {
  //   ApiResponse apiResponse = await HttpClient.post(
  //     url: '$morpheusBaseUrl/appForm/$appFormId/consent',
  //     body: {
  //       "phoneNumber": mobileNumber,
  //       "fipIds": [bankFipID]
  //     },
  //   );
  //   return AAConsentModel.fromJson(apiResponse);
  // }

  Future<CheckAppFormModel> getAAStatus(String url, Map body) async {
    ApiResponse apiResponse = await HttpClient.post(url: url, body: body);
    return checkAppFormModelFromJson(apiResponse);
  }

  // Future<PerfiosBankStatementModel> getPerfiosWebURL(Map body) async {
  //   ApiResponse apiResponse = await HttpClient.post(
  //     url: "$morpheusBaseUrl/perfios/$appFormId/start",
  //     body: body,
  //   );
  //   return PerfiosBankStatementModel.decodeResponse(apiResponse);
  // }

  Future<BankReportModel> getBankReports() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrlVersion2/appForm/$appFormId/bankReport",
    );
    return BankReportModel.decodeResponse(apiResponse);
  }

  Future<BankReportInitiateModel> initiateBankReport(
      Map body, bool isCLPAccountAggregator,
      {bool isFinsights = false}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: isFinsights
          ? "$morpheusBaseUrl/bankReport/stateless"
          : "$morpheusBaseUrlVersion2/appForm/$appFormId/bankReport/initiate",
      body: body,
    );
    return isCLPAccountAggregator
        ? AAConsentModel.fromJson(apiResponse)
        : PerfiosBankStatementModel.decodeResponse(apiResponse);
  }

  Future<BankReportPollingModel> bankReportPolling(String reportId,
      {bool isFinsights = false}) async {
    AuthUser user = await Amplify.Auth.getCurrentUser();

    ApiResponse apiResponse = await HttpClient.post(
        url: isFinsights
            ? "$baseUrl/poll?type=stateless_ignosis"
            : "$baseUrl/poll?app_form_id=$appFormId&type=bank_report",
        body: isFinsights
            ? {
                'reportId': reportId,
                "subId": user.userId,
                "phone_number": await AppAuthProvider.phoneNumber
              }
            : {'reportId': reportId});
    return BankReportPollingModel.decodeResponse(apiResponse);
  }
}
