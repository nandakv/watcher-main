import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/api/http_client.dart';

class FeedbackRepository extends BaseRepository{
  Future<ApiResponse> postUserRejectionFeedBack({required Map body})async{
    ApiResponse apiResponse = await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/update",
      body: body,
    );
    return apiResponse;
  }
}