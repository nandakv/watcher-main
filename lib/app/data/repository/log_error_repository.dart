import 'package:get/get.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';

class LogErrorRepository with BaseRepository {
  Future logError(Map<String, dynamic> body) async {
    ApiResponse apiResponse =
        await HttpClient.post(url: "$baseUrl/errorlogger", body: body);
    Get.log("error logger response - ${apiResponse.toString()}");
  }
}
