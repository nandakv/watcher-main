import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/business_details/gst_list_model.dart';

class BusinessDetailsRepository extends BaseRepository {
  Future<GSTListModel> getGstList(Map<String, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/business/appForm/$appFormId/gstinPanSearch",
      body: body,
    );
    return GSTListModel.decodeResponse(apiResponse);
  }
}
