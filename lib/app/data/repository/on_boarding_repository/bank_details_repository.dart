import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/penny_status_model.dart';

import '../../../api/response_model.dart';
import '../../../models/penny_testing/penny_testing_bank_model.dart';
import '../../../models/supported_banks_model.dart';
import '../base_repository.dart';

class BankDetailsRepository extends BaseRepository {
  Future<SupportedBanksModel> getBanks(String loanProductCode) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$baseUrl/supportedBanks?loanProductCode=$loanProductCode",
    );
    return supportedBanksNameModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> startPennyTesting({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/appForm/$appFormId/pennyTesting", body: body);
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<PennyTestingBankModel> getPennyTestingBank() async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$morpheusBaseUrlVersion2/appForm/$appFormId/pennyTesting/bankAccount",
    );
    return PennyTestingBankModel.decodeResponse(apiResponse);
  }
}
