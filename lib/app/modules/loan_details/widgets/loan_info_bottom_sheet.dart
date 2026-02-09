import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';

// Data class to hold title, value, and highlight status for each item row
class DetailItem {
  final String title;
  final num value;
  final bool isHighlighted;

  DetailItem({
    required this.title,
    required this.value,
    this.isHighlighted = false,
  });
}

class LoanInfoBottomSheet extends StatelessWidget {
  final String sheetTitle;
  final List<DetailItem> itemsBeforeDivider;
  final DetailItem? itemAfterDivider;
  final Widget? bottomWidget;

  const LoanInfoBottomSheet({
    super.key,
    required this.sheetTitle,
    required this.itemsBeforeDivider,
    this.itemAfterDivider, // This can be null if no item is needed after the divider
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
      childPadding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sheetTitle,
                  style: AppTextStyles.headingSMedium(
                      color: AppTextColors.brandBlueTitle),
                ),
                VerticalSpacer(4.h),
                ...itemsBeforeDivider.map((item) => _itemRow(item)).toList(),
                if (itemAfterDivider != null) ...[
                  VerticalSpacer(4.h),
                  Divider(
                    height: 1.h,
                    color: AppBackgroundColors.neutralLightSubtle,
                  ),
                  VerticalSpacer(12.h),
                  _itemRow(itemAfterDivider!), // Display the item after the divider
                ],
              ],
            ),
          ),
          if (bottomWidget != null) ...[
            VerticalSpacer(8.h),
            bottomWidget!,
          ]
        ],
      ),
    );
  }

  Widget _itemRow(DetailItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            item.title,
            style: item.isHighlighted
                ? AppTextStyles.bodySMedium(
                    color: AppTextColors.neutralDarkBody)
                : AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          const Spacer(),
          Text(
            AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(item.value),
            style: AppTextStyles.bodySSemiBold(
                color: AppTextColors.neutralDarkBody),
          )
        ],
      ),
    );
  }
}
