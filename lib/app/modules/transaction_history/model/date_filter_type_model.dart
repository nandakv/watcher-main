enum DateFilterType {
  today,
  lastOneWeek,
  lastOneMonth,
  lastThreeMonths,
  customDate,
  none
}

class DateFilterTypeModel {
  final String title;
  final DateFilterType type;

  DateFilterTypeModel({required this.title, required this.type});

  @override
  String toString() {
    return title;
  }

  static DateFilterTypeModel get none =>
      DateFilterTypeModel(title: "None", type: DateFilterType.none);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DateFilterTypeModel && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}
