import 'package:privo/app/api/response_model.dart';

ESignDownloadModel eSignDownloadModelFromJson(ApiResponse apiResponse) =>
    ESignDownloadModel.decodeResponse(apiResponse);

class ESignDownloadModel {
  late String s3URL;
  late ApiResponse apiResponse;

  ESignDownloadModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          s3URL = apiResponse.apiResponse;
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }
}
