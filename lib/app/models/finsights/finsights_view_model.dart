import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/models/finsights/finsights_overview_model.dart';
import '../../api/response_model.dart';
import '../../utils/app_functions.dart';

class FinSightsViewModel {
  late ApiResponse apiResponse;
  late List<MonthlyInfo> monthlyInfo;
  late List<TopFunds> topFundsTransferred = [];
  late List<TopFunds> topFundsReceived = [];
  late Map<String, List<MonthlyCategoryAnalysis>> monthlyCategoryWiseAnalysis =
      {};
  late SixMonthsSummary? sixMonths;
  late ThreeMonthsSummary? threeMonths;
  Map<DateTime, List<Transaction>> filterByMonthTransfers = {};
  Map<DateTime, List<Transaction>> filterByMonthReceived = {};
  late FinsightsOverviewModel overviewModel;
  late String closingBalance;
  late DateTime closingBalanceDate;
  late String? avgBalance;
  late String? avgCredit;
  late String? avgDebit;
  late EodSummary eodSummary;
  late Map<String, double> categoryWiseLastThreeMonthsDebitAmount = {};
  late Map<String, double> categoryWiseLastThreeMonthsDebitPercentage = {};
  late Map<String, double> categoryWiseLastSixMonthsDebitAmount = {};
  late Map<String, double> categoryWiseLastSixMonthsDebitPercentage = {};

  FinSightsViewModel.decodeResponse(this.apiResponse) {
    //  eodSummary = null;
    // categoryWiseAnalysis = null;
    monthlyCategoryWiseAnalysis = {};

    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  void _parseJson(Map<String, dynamic> jsonMap) {
    overviewModel = FinsightsOverviewModel.parseJson(jsonMap);

    if (jsonMap['monthlyInfo'] is List) {
      monthlyInfo = (jsonMap['monthlyInfo'] as List<dynamic>)
          .map((e) => MonthlyInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (jsonMap['eodSummary'] is Map) {
      eodSummary =
          EodSummary.fromJson(jsonMap['eodSummary'] as Map<String, dynamic>);
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      closingBalanceDate = dateFormat.parse(eodSummary.closingDate);
      String formattedValue = AppFunctions()
          .formatNumberWithCommas(eodSummary.closingBalance.abs());
      closingBalance =
          '${eodSummary.closingBalance < 0 ? '-' : ''}₹$formattedValue';
      avgBalance = AppFunctions.getIOFOAmount(
        double.parse(eodSummary.averageBalance.toString()).roundToDouble(),
      );
      avgDebit = AppFunctions.getIOFOAmount(
        double.parse(eodSummary.averageDebit.toString()).roundToDouble(),
      );
      avgCredit = AppFunctions.getIOFOAmount(
        double.parse(eodSummary.averageCredit.toString()).roundToDouble(),
      );
    }

    for (var fundTransferValue in (jsonMap['topFundsTransferred'] as List<dynamic>? ?? [])) {
      final element = TopFunds.fromJson(fundTransferValue);
      topFundsTransferred.add(element);
      if (element.monthYear != null) {
        filterByMonthTransfers
            .putIfAbsent(element.monthYear!, () => [])
            .addAll(element.txns!.toList());
      }
    }

    for (var fundTransferValue in (jsonMap['topFundsReceived'] as List<dynamic>? ?? [])) {
      final element = TopFunds.fromJson(fundTransferValue);
      topFundsReceived.add(element);
      if (element.monthYear != null) {
        filterByMonthReceived
            .putIfAbsent(element.monthYear!, () => [])
            .addAll(element.txns!.toList());
      }
    }

    double sumOfAllLastThreeMonthsDebitAmount = 0;
    double sumOfAllLastSixMonthsDebitAmount = 0;

    if (jsonMap['monthlyCategoryWiseAnalysis'] is! Map) {
      return;
    }

    final Map<String, dynamic> rawMonthlyCategoryWiseAnalysis =
        jsonMap['monthlyCategoryWiseAnalysis'] as Map<String, dynamic>;

    Map<String, double> tempCategoryWiseLastThreeMonthsDebitAmount = {};
    Map<String, double> tempCategoryWiseLastSixMonthsDebitAmount = {};
    Map<String, List<MonthlyCategoryAnalysis>> tempMonthlyCategoryWiseAnalysis =
        {};

    for (final String categoryName in rawMonthlyCategoryWiseAnalysis.keys) {
      final dynamic categoryData = rawMonthlyCategoryWiseAnalysis[categoryName];

      // Skip if categoryData is not a List or is empty
      if (categoryData is! List<dynamic> || categoryData.isEmpty) {
        continue;
      }

      final List<MonthlyCategoryAnalysis> analysisList = [
        for (var monthlyData in categoryData)
          if (monthlyData is Map<String, dynamic>)
            MonthlyCategoryAnalysis.fromJson(monthlyData)
      ];

      // Skip if no valid analysis data was parsed
      if (analysisList.isEmpty) {
        continue;
      }

      // Calculate last 3 months
      if (analysisList.length >= 3) {
        final double lastThreeMonthsDebitAmount = analysisList
            .sublist(analysisList.length - 3)
            .fold(0, (sum, item) => sum + (item.totalDebitAmount ?? 0));
        sumOfAllLastThreeMonthsDebitAmount += lastThreeMonthsDebitAmount;
        tempCategoryWiseLastThreeMonthsDebitAmount[categoryName] =
            lastThreeMonthsDebitAmount;
      }

      // Calculate last 6 months
      if (analysisList.length >= 6) {
        final double lastSixMonthsDebitAmount = analysisList
            .sublist(analysisList.length - 6)
            .fold(0, (sum, item) => sum + (item.totalDebitAmount ?? 0));
        sumOfAllLastSixMonthsDebitAmount += lastSixMonthsDebitAmount;
        tempCategoryWiseLastSixMonthsDebitAmount[categoryName] =
            lastSixMonthsDebitAmount;
      }
      tempMonthlyCategoryWiseAnalysis[categoryName] = analysisList;
    }

    monthlyCategoryWiseAnalysis = tempMonthlyCategoryWiseAnalysis;
    categoryWiseLastThreeMonthsDebitAmount =
        tempCategoryWiseLastThreeMonthsDebitAmount;
    categoryWiseLastSixMonthsDebitAmount =
        tempCategoryWiseLastSixMonthsDebitAmount;

    void processAndSortCategories(
      double totalSum,
      Map<String, double> categoryWiseAmountMap,
      Map<String, double> categoryWisePercentageMap,
    ) {
      if (totalSum <= 0) {
        return; // No processing needed if sum is zero or negative
      }

      List<MapEntry<String, double>> sortedCategories =
          categoryWiseAmountMap.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedCategories.length > 10) {
        final double otherCategoryAmount = sortedCategories
            .skip(10)
            .fold(0, (sum, entry) => sum + entry.value);
        sortedCategories = [
          ...sortedCategories.take(10),
          MapEntry('Others', otherCategoryAmount)
        ];
      }

      categoryWiseAmountMap.clear();
      categoryWiseAmountMap.addEntries(sortedCategories);

      // Calculate percentage for each category
      categoryWiseAmountMap.forEach((categoryName, categoryData) {
        categoryWisePercentageMap[categoryName] =
            (categoryData / totalSum) * 100;
      });
    }

// Process for last 3 months
    processAndSortCategories(
      sumOfAllLastThreeMonthsDebitAmount,
      categoryWiseLastThreeMonthsDebitAmount,
      categoryWiseLastThreeMonthsDebitPercentage,
    );

// Process for last 6 months
    processAndSortCategories(
      sumOfAllLastSixMonthsDebitAmount,
      categoryWiseLastSixMonthsDebitAmount,
      categoryWiseLastSixMonthsDebitPercentage,
    );

    // Parse and assign sixMonths summary
    sixMonths = (jsonMap['sixMonths'] is Map)
        ? SixMonthsSummary.fromJson(
            jsonMap['sixMonths'] as Map<String, dynamic>)
        : null;

    // Parse and assign threeMonths summary
    threeMonths = (jsonMap['threeMonths'] is Map)
        ? ThreeMonthsSummary.fromJson(
            jsonMap['threeMonths'] as Map<String, dynamic>)
        : null;
  }
}


class SixMonthsSummary {
  final int? totalCreditTxnLast6Months;
  final double? totalCreditAmountLast6Months;
  final int? totalDebitTxnLast6Months;
  final double? totalDebitAmountLast6Months;
  final MonthlyAmount? highestSpend;
  final MonthlyAmount? lowestSpend;
  final HighestCategory? highestCatgeory;

  SixMonthsSummary({
    this.totalCreditTxnLast6Months,
    this.totalCreditAmountLast6Months,
    this.totalDebitTxnLast6Months,
    this.totalDebitAmountLast6Months,
    this.highestSpend,
    this.lowestSpend,
    this.highestCatgeory,
  });

  factory SixMonthsSummary.fromJson(Map<String, dynamic> json) {
    return SixMonthsSummary(
      totalCreditTxnLast6Months: json['totalCreditTxnLast6Months'] as int?,
      totalCreditAmountLast6Months:
          (json['totalCreditAmountLast6Months'] as num?)?.toDouble(),
      totalDebitTxnLast6Months: json['totalDebitTxnLast6Months'] as int?,
      totalDebitAmountLast6Months:
          (json['totalDebitAmountLast6Months'] as num?)?.toDouble(),
      highestSpend: json['highestSpend'] == null
          ? null
          : MonthlyAmount.fromJson(
              json['highestSpend'] as Map<String, dynamic>),
      lowestSpend: json['lowestSpend'] == null
          ? null
          : MonthlyAmount.fromJson(json['lowestSpend'] as Map<String, dynamic>),
      highestCatgeory: json['highestCatgeory'] == null
          ? null
          : HighestCategory.fromJson(
              json['highestCatgeory'] as Map<String, dynamic>),
    );
  }
}

class MonthlyAmount {
  late int month;
  final int? year;
  final double? amount;
  late String fullMonth;

  MonthlyAmount({
    required this.month,
    this.year,
    this.amount,
    this.fullMonth = "",
  });

  static Map<String, String> monthMap = {
    "1": "January",
    "2": "February",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "August",
    "9": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  factory MonthlyAmount.fromJson(Map<String, dynamic> json) {
    int parsedMonth = json['month'] as int;
    String derivedFullMonth =
        MonthlyAmount.monthMap[parsedMonth.toString()] ?? '';

    return MonthlyAmount(
        month: json['month'] as int,
        year: json['year'] as int?,
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        fullMonth: derivedFullMonth);
  }
}

class HighestCategory {
  final String month;
  final int year;
  final double totalAmount;
  final String category;
  final double highestMonthlyAmount;

  HighestCategory({
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.category,
    required this.highestMonthlyAmount,
  });

  factory HighestCategory.fromJson(Map<String, dynamic> json) {
    int parsedMonth = json['month'] as int;
    String highestMonth = MonthlyAmount.monthMap[parsedMonth.toString()] ?? '';
    return HighestCategory(
      month: highestMonth,
      year: json['year'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      category: json['category'] as String,
      highestMonthlyAmount: (json['highestMonthlyAmount'] as num).toDouble(),
    );
  }
}

class ThreeMonthsSummary {
  final int? totalDebitTxnLast3Months;
  final double? totalDebitAmountLast3Months;
  final int? totalCreditTxnLast3Months;
  final double? totalCreditAmountLast3Months;

  ThreeMonthsSummary({
    this.totalDebitTxnLast3Months,
    this.totalDebitAmountLast3Months,
    this.totalCreditTxnLast3Months,
    this.totalCreditAmountLast3Months,
  });

  factory ThreeMonthsSummary.fromJson(Map<String, dynamic> json) {
    return ThreeMonthsSummary(
      totalDebitTxnLast3Months: json['totalDebitTxnLast3Months'] as int?,
      totalDebitAmountLast3Months:
          (json['totalDebitAmountLast3Months'] as num?)?.toDouble(),
      totalCreditTxnLast3Months: json['totalCreditTxnLast3Months'] as int?,
      totalCreditAmountLast3Months:
          (json['totalCreditAmountLast3Months'] as num?)?.toDouble(),
    );
  }
}

class MonthlyInfo {
  final int? year;
  final int? month;
  final double? totalCreditAmount;
  final double? totalDebitAmount;
  final double? closingBalance;
  final double? avgBalance;
  final double? maxEodBalance;

  MonthlyInfo({
    this.year,
    this.month,
    this.totalCreditAmount,
    this.totalDebitAmount,
    this.closingBalance,
    this.avgBalance,
    this.maxEodBalance,
  });

  factory MonthlyInfo.fromJson(Map<String, dynamic> json) {
    return MonthlyInfo(
      year: json['Year'] as int?,
      month: json['Month'] as int?,
      totalCreditAmount: (json['TotalCreditAmount'] as num?)?.toDouble(),
      totalDebitAmount: (json['TotalDebitAmount'] as num?)?.toDouble(),
      closingBalance: (json['ClosingBalance'] as num?)?.toDouble(),
      avgBalance: (json['AvgBalance'] as num?)?.toDouble(),
      maxEodBalance: (json['MaxEodBalance'] as num?)?.toDouble(),
    );
  }
}

class EodSummary {
  final double closingBalance;
  final double? averageBalance;
  final double? averageCredit;
  final double? averageDebit;
  final String closingDate;
  final double? totalDebitAmount;
  final double? avgSpendPerMonth;

  EodSummary({
    required this.closingBalance,
    this.averageBalance,
    this.averageCredit,
    this.averageDebit,
    required this.closingDate,
    this.totalDebitAmount,
    this.avgSpendPerMonth,
  });

  factory EodSummary.fromJson(Map<String, dynamic> json) {
    return EodSummary(
      closingBalance: (json['closingBalance'] as num).toDouble(),
      averageBalance: (json['averageBalance'] as num?)?.toDouble()??0.0,
      averageCredit: (json['averageCredit'] as num?)?.toDouble()??0.0,
      averageDebit: (json['averageDebit'] as num?)?.toDouble()??0.0,
      closingDate: json['closingDate'] ?? "",
      totalDebitAmount: (json['totalDebitAmount'] as num?)?.toDouble(),
      avgSpendPerMonth: (json['avgSpendPerMonth'] as num?)?.toDouble(),
    );
  }
}

class TopFunds {
  final DateTime? monthYear;
  final List<Transaction>? txns;

  TopFunds({
    this.monthYear,
    this.txns,
  });

  factory TopFunds.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat("MMM-yy");

    return TopFunds(
      monthYear: dateFormat.parse(json['MonthYear']),
      txns: (json['Txns'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Transaction {
  final double amount;
  final String? category;

  Transaction({
    required this.amount,
    this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {

    return Transaction(
      amount: (json['Amount'] as num).toDouble(),
      category: json['Category'] as String?,
    );
  }
}

class CategoryAnalysis {
  final String? categoryCode;
  final double? totalDebitAmount;
  final int? totalTransactions;
  final double? last6MonthAvgDebitAmount;

  CategoryAnalysis({
    this.categoryCode,
    this.totalDebitAmount,
    this.totalTransactions,
    this.last6MonthAvgDebitAmount,
  });

  factory CategoryAnalysis.fromJson(Map<String, dynamic> json) {
    return CategoryAnalysis(
      categoryCode: json['CategoryCode'] as String?,
      totalDebitAmount: (json['TotalDebitAmount'] as num?)?.toDouble(),
      totalTransactions: json['TotalTransactions'] as int?,
      last6MonthAvgDebitAmount:
          (json['Last6MonthAvgDebitAmount'] as num?)?.toDouble(),
    );
  }
}

class MonthlyCategoryAnalysis {
  final int? year;
  final int? month;
  final String? categoryCode;
  final double? totalDebitAmount;
  final int? totalTransactions;

  MonthlyCategoryAnalysis({
    this.year,
    this.month,
    this.categoryCode,
    this.totalDebitAmount,
    this.totalTransactions,
  });

  factory MonthlyCategoryAnalysis.fromJson(Map<String, dynamic> json) {

    return MonthlyCategoryAnalysis(
      year: json['Year'] as int?,
      month: json['Month'] as int?,
      categoryCode: json['CategoryCode'] as String?,
      totalDebitAmount: (json['TotalDebitAmount'] as num?)?.toDouble(),
      totalTransactions: json['TotalTransactions'] as int?,
    );
  }
}
