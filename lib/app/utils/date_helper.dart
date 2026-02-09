import '../modules/transaction_history/model/date_filter_type_model.dart';

class DateRange {
  final DateTime fromDate;
  final DateTime endDate;

  DateRange(this.fromDate, this.endDate);
}

class DateHelper {
  static DateRange getDateRangeFromDateFilter(DateFilterType filter,
      {DateTime? baseDate}) {
    DateTime today = baseDate ?? DateTime.now();
    DateTime start, end;

    switch (filter) {
      case DateFilterType.today:
        start = DateTime(today.year, today.month, today.day);
        end = start
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1));
        break;
      case DateFilterType.lastOneWeek:
        start = today.subtract(const Duration(days: 6));
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);
        break;
      case DateFilterType.lastOneMonth:
        start = DateTime(today.year, today.month - 1, today.day);
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);
        break;
      case DateFilterType.lastThreeMonths:
        start = DateTime(today.year, today.month - 3, today.day);
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);
        break;
      case DateFilterType.customDate:
      // Assuming custom date range handling logic here
      // start = dateTimeRange.start; // Placeholder for custom logic
      // end = dateTimeRange.end; // Placeholder for custom logic
      // break;
      case DateFilterType.none:
        start = today;
        end = today;
        break;
    }

    return DateRange(start, end);
  }
}
