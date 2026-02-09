import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/finsights/finsights_overview_model.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_chart_helper.dart';
import 'package:privo/app/modules/fin_sights/widgets/mask_data_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/fl_chart/fl_chart.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';

import 'finsights_empty_widget.dart';

class FinsightsYourFinanceBarChart extends StatelessWidget {
  FinsightsYourFinanceBarChart({
    super.key,
  });

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const RadialGradient(
          colors: [
            Color(0xffE2F4FD),
            Colors.white,
          ],
          center: Alignment.bottomLeft,
        ),
      ),
      child: _chartWidget(),
    );
  }

  Column _chartWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: BarChart(
              _barChartData(),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _accountSummaryPanel(
              typeIncoming: true,
            ),
            _accountSummaryPanel(
              typeIncoming: false,
            ),
          ],
        )
      ],
    );
  }

  Widget _accountSummaryPanel({required bool typeIncoming}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: typeIncoming
                    ? FinsightsChartHelper.creditColor
                    : FinsightsChartHelper.debitColor,
                shape: BoxShape.circle,
              ),
            ),
             HorizontalSpacer(4.w),
            Text(typeIncoming ? 'Incoming' : 'Outgoing')
                .bodyXSRegular(color: secondaryDarkColor),
             HorizontalSpacer(16.w),

            MaskDataWidget(
              text: _computeAccountSummaryAmount(typeIncoming),
              styleBuilder: (text) =>
                  Text(text).bodyMMedium(color: primaryDarkColor),
            ),
          ],
        ),
      ],
    );
  }

  String _computeAccountSummaryAmount(bool isIncoming) {
    List<MonthAmount> list = isIncoming
        ? logic.selectedCreditAmountList
        : logic.selectedDebitAmountList;
    return AppFunctions.getIOFOAmount(
      list.fold(
        0.0,
        (previousValue, element) =>
            previousValue + double.parse(element.amount),
      ),
      decimalDigit: 2,
    ).replaceAll(".00", "");
  }

  Color _computeBarColor(int barGroupIndex, Color barColor) {
    if (logic.touchedBarGroupIndex != null &&
        logic.touchedBarGroupIndex != barGroupIndex) {
      return barColor.withOpacity(0.3);
    }
    return barColor;
  }

  BarChartData _barChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: _barTouchData(),
      barGroups: List<BarChartGroupData>.generate(
        logic.computeGraphLength(),
        (i) => BarChartGroupData(
          x: i,
          barRods: [
            _barChartRodData(
              double.parse(
                  logic.selectedCreditAmountList[i].amount.removeAllWhitespace),
              _computeBarColor(i, FinsightsChartHelper.creditColor),
            ),
            _barChartRodData(
              double.parse(
                  logic.selectedDebitAmountList[i].amount.removeAllWhitespace),
              _computeBarColor(i, FinsightsChartHelper.debitColor),
            ),
          ],
        ),
      ),
      borderData: FlBorderData(
        border: const Border(
          bottom: BorderSide(
            color: lightGreyColor,
            width: 1,
          ),
        ),
      ),
      gridData: FlGridData(
        drawHorizontalLine: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
            color: lightGrayColor,
            dashArray: [3, 3],
          );
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: _bottomTiles(),
        leftTitles: _leftTiles(),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
    );
  }

  AxisTitles _bottomTiles() {
    return AxisTitles(
      axisNameSize: 0,
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            axisSide: AxisSide.bottom,
            child: Text(
              logic.selectedCreditAmountList[value.toInt()].month
                  .split('-')
                  .first,
            ).bodySRegular(color: secondaryDarkColor),
          );
        },
      ),
    );
  }

  AxisTitles _leftTiles() {
    return AxisTitles(
      axisNameSize: 0,
      sideTitles: SideTitles(
        reservedSize: 40,
        minIncluded: false,
        showTitles: true,
        maxIncluded: false,
        getTitlesWidget: (value, meta) {
          Get.log("left tile value - $value");
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                logic.formatAmountForYAxis(value),
                textAlign: TextAlign.right,
              ).bodyXSMedium(color: secondaryDarkColor),
            ),
          );
        },
      ),
    );
  }

  BarChartRodData _barChartRodData(double y, Color color) {
    return BarChartRodData(
      toY: y,
      color: color,
      width: 10,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(8),
        topLeft: Radius.circular(8),
      ),
    );
  }

  BarTouchData _barTouchData() {
    return BarTouchData(
      touchCallback:
          (FlTouchEvent flTouchEvent, BarTouchResponse? barTouchResponse) {
        if (barTouchResponse == null || barTouchResponse.spot == null) {
          logic.touchedBarGroupIndex = null;
          return;
        }
        logic.touchedBarGroupIndex =
            barTouchResponse.spot!.touchedBarGroupIndex;
      },
      longPressDuration: const Duration(minutes: 3),
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => primarySubtleColor,
        tooltipRoundedRadius: 8,
        tooltipMargin: -40,
        tooltipHorizontalOffset: 15,
        tooltipPadding: const EdgeInsets.only(
          left: 8,
          top: 4,
          bottom: 6,
          right: 14,
        ),
        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String credit = logic.selectedCreditAmountList[group.x].amount;
          String debit = logic.selectedDebitAmountList[group.x].amount;
          return BarTooltipItem(
            "",
            const TextStyle(),
            textAlign: TextAlign.start,
            children: [
              if(logic.showData)...[
                TextSpan(
                  text: "",
                  style: _toolTipArrowStyle(FinsightsChartHelper.creditColor),
                ),
                TextSpan(
                  text:
                      "  ${AppFunctions.getIOFOAmount(double.parse(credit), decimalDigit: 2).removeAllWhitespace}\n",
                  style: _toolTipTextStyle(FinsightsChartHelper.creditColor),
                ),
                TextSpan(
                  text: "",
                  style: _toolTipArrowStyle(FinsightsChartHelper.debitColor),
                ),
                TextSpan(
                  text:
                      "  ${AppFunctions.getIOFOAmount(double.parse(debit), decimalDigit: 2).removeAllWhitespace}",
                  style: _toolTipTextStyle(FinsightsChartHelper.debitColor),
                ),
              ] else ...[
                TextSpan(
                  text:
                  "******\n",
                  style: _toolTipTextStyle(FinsightsChartHelper.creditColor),
                ),
                TextSpan(
                  text:
                  "******",
                  style: _toolTipTextStyle(FinsightsChartHelper.debitColor),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  TextStyle _toolTipArrowStyle(Color color) {
    return TextStyle(
      fontFamily: 'arrows',
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 6,
    );
  }

  TextStyle _toolTipTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 10,
      height: 2,
    );
  }
}
