import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/app_parameter_model.dart';

class AppParameterRepository with BaseRepository {
  Future<AppParameterModel> getAppParameters() async {
    ApiResponse apiResponse =
        await HttpClient.get(url: "$baseUrl/appParameters");
    return AppParameterModel.fromJson(apiResponse);
  }
}
