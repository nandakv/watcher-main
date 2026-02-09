import 'package:privo/app/utils/fl_chart/fl_chart.dart';
import 'package:privo/app/utils/fl_chart/src/chart/bar_chart/bar_chart_helper.dart';

import '../base/axis_chart/axis_chart_data.dart';
import 'line_chart_data.dart';

/// Contains anything that helps LineChart works
class LineChartHelper {
  /// Calculates the [minX], [maxX], [minY], and [maxY] values of
  /// the provided [lineBarsData].
  AxisOffset calculateMaxAxisValues(
    List<LineChartBarData> lineBarsData,
  ) {
    if (lineBarsData.isEmpty) {
      return AxisOffset(
        xAxis: MinMax(min: 0, max: 0),
        yAxis: MinMax(min: 0, max: 0),
      );
    }

    final LineChartBarData lineBarData;
    try {
      lineBarData =
          lineBarsData.firstWhere((element) => element.spots.isNotEmpty);
    } catch (e) {
      // There is no lineBarData with at least one spot
      return AxisOffset(
        xAxis: MinMax(min: 0, max: 0),
        yAxis: MinMax(min: 0, max: 0),
      );
    }

    final FlSpot firstValidSpot;
    try {
      firstValidSpot =
          lineBarData.spots.firstWhere((element) => element != FlSpot.nullSpot);
    } catch (e) {
      // There is no valid spot
      return AxisOffset(
        xAxis: MinMax(min: 0, max: 0),
        yAxis: MinMax(min: 0, max: 0),
      );
    }

    var minX = firstValidSpot.x;
    var maxX = firstValidSpot.x;
    var minY = firstValidSpot.y;
    var maxY = firstValidSpot.y;

    for (final barData in lineBarsData) {
      if (barData.spots.isEmpty) {
        continue;
      }

      if (barData.mostRightSpot.x > maxX) {
        maxX = barData.mostRightSpot.x;
      }

      if (barData.mostLeftSpot.x < minX) {
        minX = barData.mostLeftSpot.x;
      }

      if (barData.mostTopSpot.y > maxY) {
        maxY = barData.mostTopSpot.y;
      }

      if (barData.mostBottomSpot.y < minY) {
        minY = barData.mostBottomSpot.y;
      }
    }

    return AxisOffset(
      xAxis: MinMax(min: minX, max: maxX),
      yAxis: MinMax(min: minY, max: maxY),
    );
  }
}
