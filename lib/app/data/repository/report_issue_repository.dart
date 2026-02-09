import 'package:get/get.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

class ReportIssueRepository with BaseRepository {
  Future<ApiResponse> raiseIssue(Map<String, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$aquManBaseUrl/account/issueTracking", body: body);
    Get.log("raise issue response - ${apiResponse.toString()}");
    return apiResponse;
  }
}
