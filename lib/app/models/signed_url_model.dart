import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

SignedUrlModel signedUrlModelFromJson(ApiResponse apiResponse) {
  return SignedUrlModel.decodeResponse(apiResponse);
}

class SignedUrlModel {
  late String url;
  late final ApiResponse apiResponse;

  SignedUrlModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          url = apiResponse.apiResponse;
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Signed url model exception ${e.toString()}");
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
