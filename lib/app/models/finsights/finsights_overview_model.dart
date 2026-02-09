import 'package:intl/intl.dart';

class FinsightsOverviewModel {
  late List<DateTime> months = [];
  late List<MonthAmount> debitTransactionPerMonthList = [];
  late List<MonthAmount> creditTransactionPerMonthList = [];
  late List<MonthAmount> maxBalancePerMonthList = [];
  late List<String> dropDownMonths = [];
  late double minYvalue = 0.0;

  FinsightsOverviewModel.parseJson(Map<String, dynamic> jsonMap) {
    final List<Map<String, dynamic>> typedMonthlyInfo =
        (jsonMap['monthlyInfo'] as List<dynamic>?)?.cast<
            Map<String, dynamic>>() ?? [];

    if (typedMonthlyInfo.isNotEmpty) {
      creditTransactionPerMonthList =
          _generateList(typedMonthlyInfo, 'TotalCreditAmount');
      debitTransactionPerMonthList =
          _generateList(typedMonthlyInfo, 'TotalDebitAmount');
      maxBalancePerMonthList = _generateList(typedMonthlyInfo, 'MaxEodBalance');
      months = generateMonthYearList(typedMonthlyInfo) ?? [];
      minYvalue = _computeMinYValue(typedMonthlyInfo, 'MaxEodBalance');
      dropDownMonths = _computeDropDownMonths(months).reversed.toList();
    }
  }

  double _computeMinYValue(List<Map<String, dynamic>> jsonMap, String key) {
    List<double> values = jsonMap.map((e) {
      num value = e[key]; // Use 'num' as it can be either int or double
      return value.toDouble();
    }).toList();
    values.sort((a, b) => a.compareTo(b));
    if (values.first == 0) return 0;
    double minY = values.first / 1.5;
    return minY;
  }

  static Map<String, String> monthMap = {
    "1": "Jan",
    "2": "Feb",
    "3": "Mar",
    "4": "Apr",
    "5": "May",
    "6": "Jun",
    "7": "Jul",
    "8": "Aug",
    "9": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec",
  };

  List<DateTime> generateMonthYearList(List<Map<String, dynamic>> monthlyInfo) {
    List<DateTime> dateTimes = [];

    for (int i = 0; i < monthlyInfo.length; i++) {
      int yearInt = monthlyInfo[i]['Year'] as int;
      int monthInt = monthlyInfo[i]['Month'] as int;

      DateTime date = DateTime(yearInt, monthInt, 1);
      dateTimes.add(date);
    }

    return dateTimes;
  }

  List<MonthAmount> _generateList(
      List<Map<String, dynamic>> monthlyInfo, String key) {
    List<MonthAmount> monthAmountList = [];

    for (var value in monthlyInfo) {
      int monthInt = value['Month'] as int;
      String month = monthMap[monthInt.toString()] ?? '';
      String year = (value['Year'] as int).toString().substring(2, 4);

      monthAmountList.add(
          MonthAmount(month: "$month-$year", amount: value[key].toString()));
    }
    return monthAmountList;
  }

  List<String> _computeDropDownMonths(List<DateTime> months) {
    DateFormat dateFormat = DateFormat("MMMM yyyy");
    return months.map((e) => dateFormat.format(e)).toList();
  }
}

class MonthAmount {
  late String month;
  late String amount;

  MonthAmount({required this.month, required this.amount});
}
