import '../amplify/auth/amplify_auth.dart';
import '../api/response_model.dart';
import '../data/provider/auth_provider.dart';
import '../data/repository/log_error_repository.dart';

class ErrorLoggerMixin {
  logErrorWithApiResponse(ApiResponse apiResponse) async {
    Map<String, dynamic> body = {
      "sub_id": await AmplifyAuth.userID,
      "error_data": {
        "url": apiResponse.url,
        "statusCode": apiResponse.statusCode,
        "requestBody": apiResponse.requestBody,
        "responseBody": apiResponse.apiResponse,
        "exception": apiResponse.exception,
        "app_form_id": AppAuthProvider.appFormID,
      }
    };
    LogErrorRepository().logError(body);
  }

  logError({
    String? url,
    String? statusCode,
    String? requestBody,
    String? responseBody,
    String? exception,
  }) async {
    Map<String, dynamic> body = {
      "sub_id": await AmplifyAuth.userID,
      "error_data": {
        "url": url,
        "statusCode": statusCode,
        "requestBody": requestBody,
        "responseBody": responseBody,
        "exception": exception,
        "app_form_id": AppAuthProvider.appFormID,
      }
    };
    LogErrorRepository().logError(body);
  }
}
