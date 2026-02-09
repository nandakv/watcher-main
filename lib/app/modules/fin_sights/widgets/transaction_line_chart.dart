import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';

import '../../../utils/fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import '../../../utils/fl_chart/src/chart/base/axis_chart/axis_chart_widgets.dart';
import '../../../utils/fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import '../../../utils/fl_chart/src/chart/line_chart/line_chart.dart';
import '../../../utils/fl_chart/src/chart/line_chart/line_chart_data.dart';

class TransactionLineChart extends StatefulWidget {
  const TransactionLineChart({
    super.key,
  });

  @override
  State<TransactionLineChart> createState() => _TransactionLineChartState();
}

class _TransactionLineChartState extends State<TransactionLineChart> {
  final logic = Get.put(FinSightsLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff8FD1EC),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
        gradient: const RadialGradient(
          // begin: Alignment.bottomLeft,
          // end: Alignment.topRight,
          center: Alignment.bottomLeft,
          // focal: Alignment.topRight,
          stops: [0.0, 1.0],
          colors: [
            Color(0xffCEEDFB),
            Color(0xffffffff),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0,right: 20,bottom: 12,top: 25),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                preventCurveOverShooting: false,
                dotData: const FlDotData(
                  show: true,
                ),
                color: debitColor,
                spots: List.generate(
                  logic.overviewModel.maxBalancePerMonthList.length,
                  (index) => FlSpot(
                      index.toDouble(),
                      double.parse(logic.overviewModel
                          .maxBalancePerMonthList[index].amount)),
                ),
              ),
            ],
            //maxY: 10,
            borderData: FlBorderData(
              border: const Border(
                bottom: BorderSide(
                  color: lightGreyColor,
                  width: 1,
                ),
              ),
              // show: true,
            ),
            minY: logic.overviewModel.minYvalue,
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
            titlesData: _tilesData(),
            lineTouchData: _lineTouchData(),
          ),
        ),
      ),
    );
  }

  FlTitlesData _tilesData() {
    return FlTitlesData(
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
    );
  }

  AxisTitles _bottomTiles() {
    return AxisTitles(
      axisNameSize: 0,
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value % 1 == 0) {
            return SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(
                logic.overviewModel.maxBalancePerMonthList[value.toInt()].month
                    .split("-")
                    .first,
              ).bodySRegular(color: secondaryDarkColor),
            );
          }
          return const SizedBox.shrink();
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
          return SideTitleWidget(
            //fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
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

  LineTouchData _lineTouchData() {
    return LineTouchData(
      longPressDuration: const Duration(minutes: 3),
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (group) => greenColor,
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        tooltipHorizontalAlignment: FLHorizontalAlignment.center,
        getTooltipItems: (List<LineBarSpot> lineBarSpots) {
          return lineBarSpots.map(
            (LineBarSpot lineBarSpot) {
              double amount = lineBarSpot.y;
              return LineTooltipItem(
                logic.showData
                    ? '${amount < 0 ? '-' : ''}${AppFunctions.getIOFOAmount(amount.abs(), decimalDigit: 2).replaceAll(" ", "")}'
                    : "******",
                _lineGraphAmountTextStyle(),
              );
            },
          ).toList();
        },
      ),
    );
  }

  TextStyle _lineGraphAmountTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: Colors.white,
      height: 14 / 10,
      fontFamily: 'Figtree',
    );
  }
}
