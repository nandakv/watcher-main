import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../res.dart';
import '../../../../api/response_model.dart';
import 'credit_score_update_model.dart';

class CreditScoreHistory {
  late String date;
  late String score;

  CreditScoreHistory({required this.date, required this.score});

  factory CreditScoreHistory.fromJson(Map<String, dynamic> json) {
    return CreditScoreHistory(
      date: json['month'],
      score: json['score'] ?? "0",
    );
  }
}

/// Model for the credit score response
class CreditScoreLineGraphModel {
  late List<CreditScoreHistory> creditScoreHistory;
  late ApiResponse apiResponse;
  late List<String> monthList;
  late List<String> sixMonthsList;
  late List<String> scoreList;
  Map<String, String> monthToScoreMap = {};
  late CreditScoreUpdate creditScoreUpdate;
  late int scoreDifference;
  late double minY;
  late double maxY;
  late bool isMonthPresentInSixMonth;

  CreditScoreLineGraphModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          var historyList = jsonMap['credit_score_history'] as List<dynamic>? ?? [];

          if(historyList.isNotEmpty){
            creditScoreHistory = historyList
                .map(
                    (e) => CreditScoreHistory.fromJson(e as Map<String, dynamic>))
                .toList();
            monthList = creditScoreHistory
                .map((history) => history.date.split('-')[0])
                .toList();

            scoreList =
                creditScoreHistory.map((history) => history.score).toList();

            minY = double.parse(scoreList.reduce(
                    (a, b) => double.parse(a) < double.parse(b) ? a : b)) -
                20;
            maxY = double.parse(scoreList.reduce(
                    (a, b) => double.parse(a) > double.parse(b) ? a : b)) +
                20;

            // Create a map from the API data for efficient lookup
            final Map<String, String> monthToScoreMap = {
              for (var item in historyList)
                if (item is Map<String, dynamic>)
                  item['month']?.split('-')[0]: item['score']?.toString() ?? "0"
            };

            // Generate the list of the last 6 months
            final now = DateTime.now();
            sixMonthsList = List.generate(6, (i) {
              final date = DateTime(now.year, now.month - (5 - i), 1);
              return DateFormat.MMM().format(date);
            });

            creditScoreHistory = sixMonthsList.map((month) {
              final score = monthToScoreMap[month];
              final year = now.year;
              return CreditScoreHistory(
                date: '$month-$year',
                score: score ?? "0",
              );
            }).toList();

            isMonthPresentInSixMonth = monthList.length > 1 &&
                monthList.any((month) => sixMonthsList.contains(month));
            Get.log("isMonthPresentInSixMonth $isMonthPresentInSixMonth");

            scoreDifference = monthList.length > 1
                ? int.parse(scoreList[0]) -
                int.parse(scoreList[1])
                : 0;

            if (scoreDifference >= 0) {
              creditScoreUpdate = CreditScoreUpdate(
                creditPoint: "$scoreDifference",
                scoreChange: "increased",
                scoreTitle: "Great News!",
                textColor: Colors.green,
                icon: Res.trendingUp,
              );
            } else {
              creditScoreUpdate = CreditScoreUpdate(
                creditPoint: "${scoreDifference.abs()}",
                scoreChange: "decreased",
                scoreTitle: "Score Update",
                textColor: Colors.red,
                icon: Res.trendingDown,
              );
            }
          }
          else {
            creditScoreHistory = [];
            monthList = [];
            scoreList = [];
            sixMonthsList = [];
            minY = 0;
            maxY = 0;
            isMonthPresentInSixMonth = false;
            scoreDifference = 0;
            creditScoreUpdate = CreditScoreUpdate(
              creditPoint: "",
              scoreChange: "",
              scoreTitle: "",
              textColor: Colors.grey, icon: '',
            );
          }

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
