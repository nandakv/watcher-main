import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../common_widgets/rich_text_widget.dart';
import '../../../models/home_card_rich_text_values.dart';
import '../../../models/home_screen_card_model.dart';
import '../../../utils/app_functions.dart';

class WithdrawalPieChart extends StatelessWidget {
  const WithdrawalPieChart(
      {Key? key, required this.withdrawalDetailsHomePageType})
      : super(key: key);

  final WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageType;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      chartType: ChartType.ring,
      legendOptions: const LegendOptions(showLegends: false),
      colorList:  const [
        green500,
        blue900,
      ],
      totalValue: 100,
      ringStrokeWidth: 14.w,
      degreeOptions: const DegreeOptions(
        initialAngle: 0,
      ),
      chartValuesOptions: _chartOptions(),
      centerWidget: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: RichTextWidget(
          textAlign: TextAlign.center,
          infoList: HomeCardTexts().totalLimitPieChartTextValues(
            amount: AppFunctions().parseIntoCommaFormat(
              withdrawalDetailsHomePageType.totalLimit.toString(),
            ),
          ),
        ),
      ),
      dataMap: _fetchLimitDataMap(),
    );
  }

  ChartValuesOptions _chartOptions() {
    return  ChartValuesOptions(
      showChartValuesOutside: true,
      chartValueStyle: TextStyle(
        fontSize: 6.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      chartValueBackgroundColor: navyBlueColor,
      decimalPlaces: 0,
      showChartValuesInPercentage: true,
    );
  }

  Map<String, double> _fetchLimitDataMap() {
    //To Compute the percentage to be shown in pie chart indicators
    return {
      "Used Limit": (withdrawalDetailsHomePageType.utilizedLimit /
              withdrawalDetailsHomePageType.totalLimit) *
          100,
      "Available limit": (withdrawalDetailsHomePageType.availableLimit /
              withdrawalDetailsHomePageType.totalLimit) *
          100,
    };
  }
}
