import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/theme/app_colors.dart';

class LoanBreakdownWidget extends StatelessWidget {
  final LoanBreakdownModel breakdownModel;
  final bool disableBorder;

  const LoanBreakdownWidget({
    Key? key,
    required this.breakdownModel,
    this.disableBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainContainer(
          color: breakdownModel.backgroundColor ?? Colors.transparent,
          borderRadiusGeometry: breakdownModel.borderRadiusGeometry ??
              BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
          child: Padding(
            padding: disableBorder
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _computeBreakdownTitleWidget(),
                    const Spacer(),
                    _computeBreakdownTitleSuffixWidget(),
                  ],
                ),
                ...breakdownModel.breakdownRowData
                    .map((e) => _breakdownTile(rowData: e))
                    .toList(),
                _computeDivider(),
              ],
            ),
          ),
        ),
        VerticalSpacer(8.h),
        _getBottomWidget(),
      ],
    );
  }

  Widget _buildMainContainer({
    required Widget child,
    required Color color,
    BorderRadiusGeometry? borderRadiusGeometry,
  }) {
    if (disableBorder) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadiusGeometry ?? BorderRadius.circular(8.r),
        ),
        child: child,
      );
    } else {
      return GradientBorderContainer(
        width: double.infinity,
        color: color,
        borderRadiusGeometry: borderRadiusGeometry,
        child: child,
      );
    }
  }

  Widget _getBottomWidget() {
    if (breakdownModel.bottomWidget == null) {
      return const SizedBox();
    }
    return _buildMainContainer(
      color: !disableBorder ? AppBackgroundColors.primarySubtle : Colors.white,
      borderRadiusGeometry: BorderRadius.only(
        bottomLeft: Radius.circular(8.r),
        bottomRight: Radius.circular(8.r),
      ),
      child: Padding(
        padding: disableBorder
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: breakdownModel.bottomWidget!,
      ),
    );
  }

  Widget _computeDivider() {
    return breakdownModel.showDivider
        ? Divider(
      color: AppBackgroundColors.neutralLightSubtle.withOpacity(.5),
    )
        : const SizedBox();
  }

  Widget _breakdownTile({required LoanBreakdownRowData rowData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            rowData.key,
            style: rowData.keyTextStyle,
          ),
          const Spacer(),
          Text(
            rowData.value,
            style: rowData.valueTextStyle,
            textAlign: TextAlign.right,
          ),
          if (rowData.suffixWidget != null)
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: rowData.suffixWidget!,
            ),
        ],
      ),
    );
  }

  Widget _computeBreakdownTitleWidget() {
    if (breakdownModel.title == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        breakdownModel.title!,
        style: breakdownModel.titleTextStyle,
      ),
    );
  }

  Widget _computeBreakdownTitleSuffixWidget() {
    if (breakdownModel.titleSuffixWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: breakdownModel.titleSuffixWidget,
      );
    }
    return const SizedBox();
  }
}