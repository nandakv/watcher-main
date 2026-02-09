  import 'dart:convert';
  import 'package:get/get.dart';
  import '../../api/response_model.dart';

  ABTestingModel abUserModelFromJson(ApiResponse apiResponse) {
    return ABTestingModel.fromApiResponse(apiResponse);
  }

  class ABTestingModel {
    late int responseCode;
    late String message;
    String? assignedGroup;
    late ApiResponse apiResponse;

    ABTestingModel.fromApiResponse(ApiResponse apiResponse) {
      try {
        final jsonMap = jsonDecode(apiResponse.apiResponse);
        responseCode = jsonMap['response_code'] ?? "";
        message = jsonMap['message'] ?? "";
        assignedGroup = jsonMap['assigned_group'];
      } catch (e) {
        Get.log(e.toString());
      }
      switch (apiResponse.state) {
        case ResponseState.success:
          try {
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