import 'date_filter_type_model.dart';

//ResetPage = false only when we are appending to existing transaction history(in case of pagination)
class FilterParams {
  String fromDate;
  String toDate;
  DateFilterTypeModel dateFilter;
  String sortBy;
  int page;
  bool resetPage;

  FilterParams(
      {required this.fromDate,
      required this.toDate,
      required this.dateFilter,
      required this.sortBy,
      this.resetPage = true,
      this.page = 1});
}
