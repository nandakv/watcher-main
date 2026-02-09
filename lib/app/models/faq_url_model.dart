import 'dart:convert';

import '../api/response_model.dart';

FAQUrlModel faqUrlModelFromJson(ApiResponse apiResponse) {
  return FAQUrlModel.decodeResponse(apiResponse);
}

class FAQUrlModel {
  late final String url;
  late final ApiResponse apiResponse;

  FAQUrlModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          url = jsonMap['faqFileLocation'];
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
