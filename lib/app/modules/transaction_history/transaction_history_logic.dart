import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/payment_history_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/payment_history_model.dart';
import 'package:privo/app/modules/payment/model/transaction_details_model.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/date_helper.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../loan_details/widgets/transaction_details_screen.dart';
import 'model/date_filter_type_model.dart';
import 'model/filter_params_model.dart';

enum PaginationLoadingState { loading, complete }

enum SortBy { latest, oldest, none }

class TransactionHistoryLogic extends GetxController with ApiErrorMixin {
  PaginationLoadingState _loadingState = PaginationLoadingState.loading;
  SortBy _sortByFilterState = SortBy.none;
  SortBy get sortByFilterState => _sortByFilterState;

  final String SORT_BY_ID = "SORT_BY_ID";
  final String FILTER_BY_ID = "FILTER_BY_ID";
  final String TOOL_TIP = "TOOL_TIP";
  final String PAGINATION_LODING_ID = "PAGINATION_LODING_ID";
  final String DATE_RANGE_WIDGET_ID = "DATE_RANGE_WIDGET_ID";

  final String LATEST_TITLE = "Latest";

  final String OLDEST_TITLE = "Oldest";

  final String DESC_KEY = "desc";

  final String ASC_KEY = "asc";

  String _dateRangeValue = "Last 3 months";
  DateTimeRange? dateTimeRangeCustomDate;

  String get dateRangeValue => _dateRangeValue;
  set dateRangeValue(String value) {
    _dateRangeValue = value;
    update();
  }


  PaginationLoadingState get loadingState => _loadingState;

  late final List<DateFilterTypeModel> dateFilterTypeList = [
    DateFilterTypeModel(title: "Today", type: DateFilterType.today),
    DateFilterTypeModel(
        title: "Last one week", type: DateFilterType.lastOneWeek),
    DateFilterTypeModel(
        title: "Last one month", type: DateFilterType.lastOneMonth),
    DateFilterTypeModel(
        title: "Last three months", type: DateFilterType.lastThreeMonths),
    DateFilterTypeModel(title: "Custom", type: DateFilterType.customDate),
  ];

  set sortByFilterState(SortBy value) {
    _sortByFilterState = value;
    update([FILTER_BY_ID]);
  }

  set loadingState(PaginationLoadingState value) {
    _loadingState = value;
    update([PAGINATION_LODING_ID]);
  }

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  bool _showTooltip = true;

  bool get showTooltip => _showTooltip;

  set showTooltip(bool value) {
    _showTooltip = value;
    update([TOOL_TIP]);
  }

  /// This is used to check which filtered data is currently being displayed on app
  DateFilterTypeModel _currentDateFilterType = DateFilterTypeModel.none;

  /// whenever the user toogles the filter we use this variable
  DateFilterTypeModel _selectedDateFilterType = DateFilterTypeModel.none;

  DateFilterTypeModel get selectedDateFilterType => _selectedDateFilterType;

  set selectedDateFilterType(DateFilterTypeModel value) {
    _selectedDateFilterType = value;
    update([FILTER_BY_ID]);
  }

  String _selectedSortType = "";

  String get selectedSortType => _selectedSortType;

  set selectedSortType(String value) {
    _selectedSortType = value;
    update([SORT_BY_ID]);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.sortBySelected,
        attributeName: {
          'SortType': selectedSortType.isEmpty ? "NA" : selectedSortType
        });
  }

  late String TRANSACTION_HISTORY_SCREEN = "transaction_history";

  String fromDate = "";
  String toDate = "";

  late PaymentHistoryModel paymentHistoryModel;
  int _paymentHistoryLength = 0;

  // ignore: unnecessary_getters_setters
  int get paymentHistoryLength => _paymentHistoryLength;

  set paymentHistoryLength(int value) {
    _paymentHistoryLength = value;
  }

  late LoanDetailsModel loanDetailsModel;

  ScrollController scrollController = ScrollController();

  String _selectedDateRange = "";

  String get selectedDateRange => _selectedDateRange;

  set selectedDateRange(String value) {
    _selectedDateRange = value;
    update([FILTER_BY_ID]);
  }

  onFilterClose() {
    Get.back();
    if (_currentDateFilterType != selectedDateFilterType) {
      selectedDateFilterType = _currentDateFilterType;
    }
  }

  onAfterLayout() {
    var arguments = Get.arguments;
    loanDetailsModel = arguments["loanDetails"];
    // Default we show only past 3 moths data,
    DateRange dateRange =
        DateHelper.getDateRangeFromDateFilter(DateFilterType.lastThreeMonths);
    // fromDate = loanDetailsModel.loanStartDate;
    // toDate = loanDetailsModel.loanEndDate;
    isPageLoading = true;
    showToolTip();
    fetchPaymentHistory(
      filterParams: FilterParams(
          dateFilter: DateFilterTypeModel.none,
          sortBy: selectedSortType,
          toDate: dateRange.endDate.toString(),
          fromDate: dateRange.fromDate.toString()),
    );
  }

  showToolTip() {
    Future.delayed(const Duration(seconds: 8)).then((val) {
      showTooltip = false;
    });
  }

  fetchPaymentHistory({required FilterParams filterParams}) async {
    loadingState = PaginationLoadingState.loading;
    if (loanDetailsModel.loanId.isNotEmpty) {
      PaymentHistoryModel paymentHistoryModel = await PaymentHistoryRepository()
          .getPaymentHistory(
              loanId: loanDetailsModel.loanId,
              toDate: DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(filterParams.toDate)),
              sortOrder: filterParams.sortBy,
              page: filterParams.page,
              fromDate: DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(filterParams.fromDate)));
      switch (paymentHistoryModel.apiResponse.state) {
        case ResponseState.success:
          _onFetchPaymentHistorySuccess(
              paymentHistoryModel, filterParams.resetPage);
          break;
        default:
          handleAPIError(paymentHistoryModel.apiResponse,
              screenName: TRANSACTION_HISTORY_SCREEN,
              retry: fetchPaymentHistory);
      }
    }
  }

  void _onFetchPaymentHistorySuccess(
      PaymentHistoryModel _paymentHistoryModel, bool resetList) {
    if (resetList) {
      paymentHistoryModel = _paymentHistoryModel;
      paymentHistoryLength =
          _paymentHistoryModel.paymentReceipts.paymentTransactions.length;
    } else {
      _addToPaymentHistory(_paymentHistoryModel);
      paymentHistoryLength +=
          _paymentHistoryModel.paymentReceipts.paymentTransactions.length;
    }
    _currentDateFilterType = selectedDateFilterType;
    loadingState = PaginationLoadingState.complete;
    isPageLoading = false;

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.transactionHistoryLoaded,
        attributeName: {
          'No of payments': paymentHistoryLength,
          'Total payments':
              _paymentHistoryModel.paymentReceipts.pagination.count,
        });
  }

  void _addToPaymentHistory(PaymentHistoryModel _paymentHistoryModel) {
    paymentHistoryModel.paymentReceipts.paymentTransactions
        .addAll(_paymentHistoryModel.paymentReceipts.paymentTransactions);
    paymentHistoryModel.paymentReceipts.pagination =
        _paymentHistoryModel.paymentReceipts.pagination;
  }

  void clearAllFilters() {
    _resetFiltersAndSort();
    DateRange dateRange =
        DateHelper.getDateRangeFromDateFilter(DateFilterType.lastThreeMonths);
    fetchPaymentHistory(
      filterParams: FilterParams(
          dateFilter: DateFilterTypeModel.none,
          sortBy: "",
          toDate: dateRange.endDate.toString(),
          fromDate: dateRange.fromDate.toString()),
    );
  }

  onFilterCheckboxChecked(DateFilterTypeModel dateFilterTypeModel) {
    selectedDateFilterType = dateFilterTypeModel;
    _checkIfCustomDate(dateFilterTypeModel.type);
  }

  onFilterCheckboxUnchecked(DateFilterTypeModel dateFilterType) {
    selectedDateFilterType = DateFilterTypeModel.none;
  }

  onSortByfilterChanged(SortBy value, String sortByKey) {
    sortByFilterState = value;
    selectedSortType = sortByKey;
  }

  void _checkIfCustomDate(DateFilterType dateFilter) {
    if (selectedDateFilterType.type == DateFilterType.customDate) {
      _onOpenDatePicker(dateFilter);
    }
  }

  void onApplyFilterClicked() {
    Get.back();
    // selectedDateRange = "";
    _computeDateAndFetchPaymentHistory();
  }

  void _computeDateAndFetchPaymentHistory() {
    DateRange dateRange =
        DateHelper.getDateRangeFromDateFilter(selectedDateFilterType.type);
    final iscustomDateSelected =
        (selectedDateFilterType.type == DateFilterType.customDate &&
            dateTimeRangeCustomDate != null);
    dateRangeValue =
        iscustomDateSelected ? selectedDateRange : selectedDateFilterType.title;
    _fetchPaymentHistory(
        startDate: iscustomDateSelected
            ? dateTimeRangeCustomDate!.start
            : dateRange.fromDate,
        endDate: iscustomDateSelected
            ? dateTimeRangeCustomDate!.end
            : dateRange.endDate);
  }

  void _onOpenDatePicker(DateFilterType dateFilter) async {
    DateTimeRange? dateTimeRange;
    if (dateFilter == DateFilterType.customDate && Get.context != null) {
      dateTimeRange = await showDateRangePicker(
          context: Get.context!,
          saveText: "Apply",
          firstDate: DateTime.parse(loanDetailsModel.loanStartDate),
          lastDate: DateTime.now(),
          initialDateRange: DateTimeRange(
              start: DateTime.parse(loanDetailsModel.loanStartDate),
              end: _computeEndDateForDateRange()));
      if (dateTimeRange == null) {
        selectedDateFilterType = _currentDateFilterType;
      } else {
        Get.log(dateTimeRange.toString());
        selectedDateRange = formatDateRange(dateTimeRange);
        dateTimeRangeCustomDate = dateTimeRange;
      }
    }
  }

  String formatDateRange(DateTimeRange pickedRange) {
    String formattedStartDate =
        DateFormat('d MMM, yyyy').format(pickedRange.start);
    String formattedEndDate = DateFormat('d MMM, yyyy').format(pickedRange.end);

    return '$formattedStartDate - $formattedEndDate';
  }

  DateTime _computeEndDateForDateRange() {
    return _isClosed()
        ? DateTime.parse(loanDetailsModel.loanEndDate)
        : DateTime.now();
  }

  _isClosed() {
    return loanDetailsModel.loanStatus == LoanStatus.closed;
  }

  void _fetchPaymentHistory(
      {required DateTime startDate, required DateTime endDate}) {
    fromDate = startDate.toString();
    toDate = endDate.toString();

    isPageLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.filterSelected,
        attributeName: {
          'Filter':
              formatDateRange(DateTimeRange(start: startDate, end: endDate))
        });
    // selectedDateRange = formatDateRange(
    // DateTimeRange(start: dateRange.fromDate, end: dateRange.endDate));
    //     incase if product or qa asks to show chip for last week and other filters too just uncomment these lines
    fetchPaymentHistory(
      filterParams: FilterParams(
        dateFilter: selectedDateFilterType,
        sortBy: selectedSortType,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  bool onScrollEndReached(ScrollEndNotification onScrollEnded) {
    if (onScrollEnded.metrics.atEdge && onScrollEnded.metrics.pixels != 0) {
      //when the scroll has reached the edge and bottom the pixels will be more than 0, while for top it will be 0.
      _fetchPayments();
    }
    return true;
  }

  void _fetchPayments() {
    Pagination? pagination = paymentHistoryModel.paymentReceipts.pagination;
    if (pagination.nextPage != 0 &&
        loadingState != PaginationLoadingState.loading) {
      loadingState = PaginationLoadingState.loading;
      fetchPaymentHistory(
        filterParams: FilterParams(
            fromDate: fromDate,
            toDate: toDate,
            page: pagination.nextPage,
            resetPage: false,
            dateFilter: selectedDateFilterType,
            sortBy: selectedSortType),
      );
    }
  }

  void clearDateFilter() {
    _resetFiltersAndSort();
    fetchPaymentHistory(
      filterParams: FilterParams(
          fromDate: fromDate,
          toDate: toDate,
          resetPage: true,
          dateFilter: selectedDateFilterType,
          sortBy: selectedSortType),
    );
    update();
  }

  void _resetFiltersAndSort() {
    selectedDateFilterType = DateFilterTypeModel.none;
    selectedSortType = "";
    isPageLoading = true;
    fromDate = loanDetailsModel.loanStartDate;
    toDate = loanDetailsModel.loanEndDate;
    selectedDateRange = "";
    sortByFilterState = SortBy.none;
  }

  void onTransactionCardTapped(PaymentTransactions transaction) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentCardClicked);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.transactionDetailsLoaded,
        attributeName: {
          'LAN': loanDetailsModel.loanId,
          'UTR': "#${transaction.paymentReference}"
        });
    Get.to(() => TransactionDetailsScreen(
          transactionDetailsModel: TransactionDetailsModel(
            refId: "#${loanDetailsModel.loanId}",
            amount:
                "₹${AppFunctions().parseIntoCommaFormat(transaction.amount)}",
            transactionDate: transaction.createdDate,
            transactionId: "#${transaction.paymentReference}",
          ),
        ));
  }

  List<PaymentTransactions> fetchPaymentTransactions() {
    return paymentHistoryModel.paymentReceipts.paymentTransactions;
  }
}
