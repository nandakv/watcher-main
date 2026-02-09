import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

import 'aa_stand_alone_bank_account_model.dart';

class AAStandAloneRepository extends BaseRepository {
  Future<AAStandAloneBankAccountModel> getAAStandAloneBank() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$morpheusBaseUrlVersion2/appForm/$appFormId/mandate/bankAccount");
    return AAStandAloneBankAccountModel.decodeResponse(apiResponse);
  }
}
