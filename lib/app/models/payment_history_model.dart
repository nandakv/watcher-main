import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';

PaymentHistoryModel paymentHistoryModelFromJson(ApiResponse apiResponse) {
  return PaymentHistoryModel.decodeResponse(apiResponse);
}

class PaymentHistoryModel {
  late PaymentReceipts paymentReceipts;
  late ApiResponse apiResponse;

  PaymentHistoryModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Payment history exception ${e.toString()}");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    paymentReceipts = (json['paymentReceipts'] != null
        ? PaymentReceipts.fromJson(json['paymentReceipts'])
        : null)!;
  }
}

class PaymentReceipts {
  late List<PaymentTransactions> paymentTransactions;
  late Pagination pagination;

  PaymentReceipts(
      {required this.paymentTransactions, required this.pagination});

  PaymentReceipts.fromJson(Map<String, dynamic> json) {
    pagination = Pagination.fromJson(json['pagination']);
    if (json['paymentTransactions'] != null) {
      paymentTransactions = <PaymentTransactions>[];
      json['paymentTransactions'].forEach((v) {
        paymentTransactions.add(PaymentTransactions.fromJson(v));
      });
    } else {
      paymentTransactions = <PaymentTransactions>[];
    }
  }
}

class Pagination {
  late int count;
  late int totalPages;
  late int nextPage;
  late int previousPage;

  Pagination(
      {required this.count,
      required this.totalPages,
      required this.nextPage,
      required this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalPages = json['totalPages'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
  }
}

class PaymentTransactions {
  late String paymentReference;
  late String amount;
  late String createdDate;

  PaymentTransactions(
      {required this.paymentReference,
      required this.amount,
      required this.createdDate});

  PaymentTransactions.fromJson(Map<String, dynamic> json) {
    paymentReference = json['paymentReference'];
    amount = double.parse(json['amount']).toInt().toString();
    createdDate = json['createdDate'];
    // Parse the input string into a DateTime object
    DateTime inputDate = DateTime.parse(createdDate);
    String outputFormat = 'dd MMM, yyyy';
    createdDate = DateFormat(outputFormat)
        .format(inputDate); // Output: 12 January, 2024 06:20 PM
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['paymentReference'] = paymentReference;
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    return data;
  }
}
