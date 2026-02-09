import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

class FinsightsAccountInfoModel {
  late String accountId;
  late ApiResponse apiResponse;

  FinsightsAccountInfoModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          List<dynamic> jsonList = jsonDecode(apiResponse.apiResponse);
          jsonList.sort((a, b) => DateTime.parse(b['createdDate'])
              .compareTo(DateTime.parse(a['createdDate'])));
          accountId = jsonList.firstWhere(
              (element) => element['source'] == "accountAggregator")['id'];
          this.apiResponse = apiResponse;
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
