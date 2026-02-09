import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/horizontal_radio_button/horizontal_radio_button_model.dart';
import 'package:privo/app/common_widgets/privo_radio_list.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';

import '../model/date_filter_type_model.dart';
import '../model/filter_params_model.dart';
import 'bottom_filter_sort_button.dart';

class SortByOption extends StatelessWidget {
  final logic = Get.find<TransactionHistoryLogic>();

  SortByOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _sortByWidget();
  }

  Widget _sortByWidget() {
    return BottomFilterSortButton(
      onTap: _onSortByTapped,
      onClearFilterTap: logic.clearAllFilters,
      iconPath: Res.sort,
      title: "Sort By",
      isHighlighted: logic.selectedSortType.isNotEmpty,
      logic: logic,
    );
  }

  void _onSortByTapped() {
    if (logic.paymentHistoryLength != 0 && Get.context != null) {
      showModalBottomSheet(
        context: Get.context!,
        isDismissible: false,
        builder: (context) {
          return GetBuilder<TransactionHistoryLogic>(
              id: logic.SORT_BY_ID,
              builder: (logic) {
                return _sortByBottomSheetWidget(logic);
              });
        },
      );
    } else {
      Fluttertoast.showToast(msg: "No Data available to sort");
    }
  }

  Container _sortByBottomSheetWidget(TransactionHistoryLogic logic) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _sortByHeader(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: PrivoRadioList<String>(
              axisDirection: Axis.vertical,
              isEnabled: true,
              radioList: [
                HorizontalRadioButtonModel(
                    title: logic.LATEST_TITLE, value: logic.LATEST_TITLE),
                HorizontalRadioButtonModel(
                    title: logic.OLDEST_TITLE, value: logic.OLDEST_TITLE)
              ],
              selectedValue: logic.selectedSortType,
              onChanged: (value) {
                _onSortRadioButtonChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSortRadioButtonChanged(String? value) {
    if (value != null) {
      logic.selectedSortType = value;
      _onSortValueNotNull(value);
    }
  }

  void _onSortValueNotNull(String value) {
    logic.isPageLoading = true;
    Get.back();
    logic.fetchPaymentHistory(
        filterParams: value == logic.OLDEST_TITLE
            ? _sortOldestDateFilterParams()
            : _sortLatestDateFilterParams());
  }

  FilterParams _sortLatestDateFilterParams() => FilterParams(
      dateFilter: DateFilterTypeModel.none,
      sortBy: logic.DESC_KEY,
      fromDate: logic.fromDate,
      toDate: logic.toDate);

  FilterParams _sortOldestDateFilterParams() => FilterParams(
      dateFilter: DateFilterTypeModel.none,
      sortBy: logic.ASC_KEY,
      fromDate: logic.fromDate,
      toDate: logic.toDate);

  Row _sortByHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Sort by',
          style: TextStyle(
            color: Color(0xFF1D478E),
            fontSize: 16,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.w600,
            height: 0.09,
          ),
        ),
        const Spacer(),
        Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.clear_rounded,
              color: darkBlueColor,
            ),
          ),
        ),
      ],
    );
  }
}
