import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

import '../../models/finsights/finsights_account_info_model.dart';
import '../../models/finsights/finsights_view_model.dart';

class FinsightsRepository extends BaseRepository {
  Future<FinsightsAccountInfoModel> getAccountInfo() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$batManBaseUrl/account/getAllAccountInfo?entityId=$appFormId",
    );
    return FinsightsAccountInfoModel.decodeResponse(apiResponse);
  }

  Future<ApiResponse> updateUserTracking({required Map body})async{
    ApiResponse apiResponse = await HttpClient.put(
      url: "$morpheusBaseUrl/userTracking/update",
      body: body,
    );
    return apiResponse;
  }


  Future<FinSightsViewModel> getFinSightsOverView() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$magnusBaseUrl/finTools/finSights",
    );
    return FinSightsViewModel.decodeResponse(apiResponse);
  }

}
