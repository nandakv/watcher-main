import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/components/pill_button.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import '../model/date_filter_type_model.dart';
import 'bottom_filter_sort_button.dart';

class FilterByOption extends StatelessWidget {
  FilterByOption({Key? key}) : super(key: key);

  final logic = Get.find<TransactionHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return logic.isPageLoading ? const SizedBox() : _filterWidget();
  }

  Widget _filterWidget() {
    return GetBuilder<TransactionHistoryLogic>(
        id: logic.TOOL_TIP,
        builder: (logic) {
          return BottomFilterSortButton(
            onTap: _onFilterByTapped,
            onClearFilterTap: logic.clearAllFilters,
            iconPath: Res.filter_list,
            title: "Filter",
            isHighlighted:
                logic.selectedDateFilterType != DateFilterTypeModel.none,
            logic: logic,
          );
        });
  }

  _onFilterByTapped() {
    Get.bottomSheet(GetBuilder<TransactionHistoryLogic>(
      id: logic.FILTER_BY_ID,
      builder: (logic) {
        return _filterByBottomSheetWidget(logic);
      },
    ));
  }

  _filterByBottomSheetWidget(TransactionHistoryLogic logic) {
    return BottomSheetWidget(
      onCloseClicked: Get.back,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filter by",
            style: AppTextStyles.headingSMedium(color: darkBlueColor),
          ),
          verticalSpacer(16.h),
          Wrap(
            children: [_filterByList()],
          ),
          verticalSpacer(32),
          Text(
            "Sort by",
            style: AppTextStyles.headingSMedium(color: darkBlueColor),
          ),
          verticalSpacer(16.h),
          _sortByList(),
          verticalSpacer(32.h),
          GradientButton(
            onPressed: logic.onApplyFilterClicked,
            enabled: logic.selectedDateFilterType.type != DateFilterType.none &&
                logic.sortByFilterState != SortBy.none,
            title: "Apply",
            titleTextStyle: AppTextStyles.bodyLSemiBold(color: whiteTextColor),
          ),
        ],
      ),
    );
  }

  Widget _sortByList() {
    final isLatestSelected = logic.sortByFilterState == SortBy.latest;
    final isOldestSelected = logic.sortByFilterState == SortBy.oldest;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        PillButton(
            text: "Latest",
            trailing: isLatestSelected ? Res.crossWhite : null,
            isSelected: isLatestSelected,
            onTap: () {
              if (isLatestSelected) {
                logic.onSortByfilterChanged(SortBy.none, "");
              } else {
                logic.onSortByfilterChanged(SortBy.latest, logic.DESC_KEY);
              }
            }),
        PillButton(
            text: "Oldest",
            trailing: isOldestSelected ? Res.crossWhite : null,
            isSelected: isOldestSelected,
            onTap: () {
              if (isOldestSelected) {
                logic.onSortByfilterChanged(SortBy.none, "");
              } else {
                logic.onSortByfilterChanged(SortBy.oldest, logic.ASC_KEY);
              }
            })
      ],
    );
  }

  Widget _filterByList() {
    final filterButtons = [
      DateFilterTypeModel(title: "Today", type: DateFilterType.today),
      DateFilterTypeModel(
          title: "Last one week", type: DateFilterType.lastOneWeek),
      DateFilterTypeModel(
          title: "Last one month", type: DateFilterType.lastOneMonth),
      DateFilterTypeModel(
          title: "Last three months", type: DateFilterType.lastThreeMonths),
    ];
    final isCustomDateSelected =
        logic.selectedDateFilterType.type == DateFilterType.customDate;
    return Column(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            ...filterButtons.map((e) => PillButton(
                  isSelected: logic.selectedDateFilterType == e,
                  text: e.title,
                  trailing:
                      logic.selectedDateFilterType == e ? Res.crossWhite : null,
                  onTap: () {
                    if (logic.selectedDateFilterType == e) {
                      logic.onFilterCheckboxUnchecked(e);
                    } else {
                      logic.onFilterCheckboxChecked(e);
                    }
                  },
                )),
            PillButton(
              text: isCustomDateSelected
                  ? logic.selectedDateRange
                  : "Custom",
              trailing: isCustomDateSelected ? Res.crossWhite : null,
              isSelected: isCustomDateSelected ? true : false,
              onTap: () {
                if (isCustomDateSelected) {
                  logic.onFilterCheckboxUnchecked(DateFilterTypeModel(
                      title: "Custom", type: DateFilterType.customDate));
                } else {
                  logic.onFilterCheckboxChecked(DateFilterTypeModel(
                      title: "Custom", type: DateFilterType.customDate));
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
