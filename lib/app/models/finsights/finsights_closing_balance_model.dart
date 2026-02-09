import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/utils/app_functions.dart';

class FinsightsClosingBalanceModel {
  late ApiResponse apiResponse;
  late String closingBalance;
  late DateTime closingBalanceDate;

  FinsightsClosingBalanceModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  void _parseJson(Map<String, dynamic> jsonMap) {
    Map<String, dynamic> eodMap = jsonMap['eod'];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    var latestEntry = eodMap.entries.reduce((a, b) =>
        dateFormat.parse(a.key).isAfter(dateFormat.parse(b.key)) ? a : b);

    closingBalanceDate = dateFormat.parse(latestEntry.key);
    closingBalance = AppFunctions.getIOFOAmount(double.parse(latestEntry.value),
        decimalDigit: 2);
  }
}
