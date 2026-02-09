import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../../common_widgets/bottom_sheet_widget.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import '../../../../utils/fl_chart/src/chart/base/axis_chart/axis_chart_widgets.dart';
import '../../../../utils/fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import '../../../../utils/fl_chart/src/chart/line_chart/line_chart.dart';
import '../../../../utils/fl_chart/src/chart/line_chart/line_chart_data.dart';
import '../../credit_report_logic.dart';

class CreditLineGraphBottomSheet extends StatelessWidget {
  final logic = Get.find<CreditReportLogic>();

  CreditLineGraphBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(),
          VerticalSpacer(16.h),
          _messageText(),
          VerticalSpacer(8.h),
          _buildLineGraphWidget(),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

  Container _buildLineGraphWidget() {
    List<double> indices = List.generate(
        logic.creditScoreLineGraphModel.monthList.length,
        (index) => index.toDouble());
    return Container(
      height: 300.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff8FD1EC),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 12.w, right: 16.w, bottom: 12.h, top: 25.h),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                isCurved: false,
                preventCurveOverShooting: false,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, bar) {
                    return spot.y != 0.0;
                  },
                ),
                color: debitColor,
                spots: logic.creditScoreLineGraphModel.creditScoreHistory
                    .where((history) => double.parse(history.score) != 0.0)
                    .map((history) {
                  final scoreValue = double.parse(history.score);
                  final index = logic
                      .creditScoreLineGraphModel.creditScoreHistory
                      .indexOf(history);
                  return FlSpot(index.toDouble(), scoreValue);
                }).toList(),
              ),
            ],
            borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(
                  color: lightGreyColor,
                  width: 1.w,
                ),
              ),
              // show: true,
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  strokeWidth: 1.w,
                  color: lightGrayColor,
                  dashArray: [3, 3],
                );
              },
            ),
            minX: indices.reduce((a, b) => a < b ? a : b) -
                (indices.reduce((a, b) => a > b ? a : b) -
                        indices.reduce((a, b) => a < b ? a : b)) *
                    0.1,
            maxX: 5.5,
            minY: logic.creditScoreLineGraphModel.minY,
            maxY: logic.creditScoreLineGraphModel.maxY,
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
                logic.creditScoreLineGraphModel
                    .creditScoreHistory[value.toInt()].date
                    .split("-")
                    .first,
                style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
              ),
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
            axisSide: meta.axisSide,
            child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  logic.formatScoreForYAxis(value.toDouble()),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyXSMedium(color: secondaryDarkColor),
                )),
          );
        },
      ),
    );
  }

  LineTouchData _lineTouchData() {
    return LineTouchData(
      longPressDuration: const Duration(minutes: 3),
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (group) => blue900,
        tooltipRoundedRadius: 8,
        tooltipPadding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 6.h,
        ),
        tooltipHorizontalAlignment: FLHorizontalAlignment.center,
        getTooltipItems: (List<LineBarSpot> lineBarSpots) {
          return lineBarSpots.map(
            (LineBarSpot lineBarSpot) {
              double amount = lineBarSpot.y;
              return LineTooltipItem(
                amount.toString(),
                AppTextStyles.bodyXSMedium(color: Colors.white),
              );
            },
          ).toList();
        },
      ),
    );
  }

  Text _titleText() {
    return Text("Score trend",
        style: AppTextStyles.headingMedium(color: darkBlueColor));
  }

  RichText _messageText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                'Your Experian score has ${logic.creditScoreUpdate.scoreChange} by ',
            style: AppTextStyles.bodySMedium(color: secondaryDarkColor),
          ),
          TextSpan(
            text: '${logic.creditScoreUpdate.creditPoint} points',
            style: AppTextStyles.bodySSemiBold(
                color: logic.creditScoreUpdate.textColor),
          ),
        ],
      ),
    );
  }
}
