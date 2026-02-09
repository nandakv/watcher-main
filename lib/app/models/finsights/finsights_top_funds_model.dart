import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/utils/app_functions.dart';

class FinsightsTopFundsModel {
  late ApiResponse apiResponse;
  Map<DateTime, List<FundTransfer>> filterByMonthTransfers = {};
  Map<DateTime, List<FundTransfer>> filterByMonthReceived = {};

  FinsightsTopFundsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          jsonMap['topfundstransfered'].forEach((fundTransferValue) {
            final element = FundTransfer.fromJson(fundTransferValue);
            filterByMonthTransfers
                .putIfAbsent(element.month, () => [])
                .add(element);
          });
          jsonMap['topfundsreceived'].forEach((fundTransferValue) {
            final element = FundTransfer.fromJson(fundTransferValue);
            filterByMonthReceived
                .putIfAbsent(element.month, () => [])
                .add(element);
          });
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

class FundTransfer {
  late String amount;
  late String category;
  late DateTime month;

  DateFormat dateFormat = DateFormat("MMM-yy");

  FundTransfer.fromJson(Map<String, dynamic> jsonMap) {
    amount = AppFunctions.getIOFOAmount(double.parse("${jsonMap['amount']}"),
        decimalDigit: 2);
    category = jsonMap['category'];
    month = dateFormat.parse(jsonMap['month']);
  }
}
