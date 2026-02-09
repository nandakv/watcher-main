import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';

import '../../../../flavors.dart';
import '../../../api/response_model.dart';
import '../../../models/check_app_form_model.dart';
import '../../provider/auth_provider.dart';

enum HttpMethod { post, put, get }

class SequenceEngineRepository extends BaseRepository {
  SequenceEngineModel sequenceEngineModel;

  SequenceEngineRepository(this.sequenceEngineModel);

  // Method to make an HTTP call based on the provided API request
  Future<CheckAppFormModel> makeHttpRequest(
      {required Map body}) async {
    // Determine the HTTP method from the API request and perform the appropriate action
    switch (httpMethodMap[sequenceEngineModel.httpRequestMethod]) {
      case HttpMethod.post:
        return await _postUser(body, sequenceEngineModel.httpSubmitUrl);
      case HttpMethod.put:
        return await _putUser(body, sequenceEngineModel.httpSubmitUrl);
      case HttpMethod.get:
        return await _getUser(sequenceEngineModel.httpSubmitUrl);
      default:
        return await _postUser(body, sequenceEngineModel.httpSubmitUrl);
    }
  }

  Future<CheckAppFormModel> _postUser(Map body, String url) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: url,
      body: body,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> _putUser(Map body, String url) async {
    ApiResponse apiResponse = await HttpClient.put(
      url: url,
      body: body,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> _getUser(String url) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: url,
    );
    return checkAppFormModelFromJson(apiResponse);
  }
}

// Map to associate string HTTP method names with HttpMethod enum values
Map<String, HttpMethod> httpMethodMap = {
  'POST': HttpMethod.post,
  'PUT': HttpMethod.put,
  'GET': HttpMethod.get,
};
