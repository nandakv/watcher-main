import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/fin_sights/spending_insights/spending_story.dart';
import 'package:privo/app/utils/text_styles.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/app_text_styles.dart';
import '../fin_sights_logic.dart';

class SpendingInsights extends StatelessWidget {
  SpendingInsights({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
          title: Text(
                  "Spending insights",
                  style: AppTextStyles.headingSMedium(color: navyBlueColor),
                )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              VerticalSpacer(24.h),
              _buildOverAllSpending(),
              VerticalSpacer(40.h),
              _buildPieChartData(context),
              if (logic.finSightsViewModel.sixMonths != null)SpendingStoryScreen(),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<FinSightsLogic> _buildOverAllSpending() {
    return GetBuilder<FinSightsLogic>(
        id: logic.OVER_ALL_SPENDING,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${AppFunctions().formatNumberWithCommas(logic.totalDebitAmount)}',
                style: AppTextStyles.bodyLSemiBold(color: navyBlueColor),
              ),
              Text(
                'Avg. spend per month ₹${AppFunctions().formatNumberWithCommas(logic.averageTotalDebitAmount)}',
                style: AppTextStyles.bodyMRegular(color: grey700),
              ),
            ],
          );
        });
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Overall spending",
          style: AppTextStyles.bodyLSemiBold(color: secondaryDarkColor),
        ),
        _selectMonthWidget(),
      ],
    );
  }

  _buildPieChartData(BuildContext context) {
    return GetBuilder<FinSightsLogic>(
        id: logic.PIE_CHART,
        builder: (logic) {
          final displayedEntries =
              logic.showLessData && logic.currentChartData.length > 4
                  ? logic.currentChartData.entries.take(4).toList()
                  : logic.currentChartData.entries.toList();
          return Column(
            children: [
              PieChart(
                dataMap: logic.currentChartData,
                animationDuration: const Duration(milliseconds: 800),
                chartRadius: MediaQuery.of(context).size.width / 3.2.w,
                colorList: logic.pieChartColorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 30.w,
                chartValuesOptions:
                    const ChartValuesOptions(showChartValues: false),
                legendOptions: const LegendOptions(showLegends: false),
              ),
              VerticalSpacer(30.h),
              ...displayedEntries.map((entry) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: logic.pieChartColorList[logic
                                    .currentChartData.keys
                                    .toList()
                                    .indexOf(entry.key) %
                                logic.pieChartColorList.length],
                            radius: 8,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: AppTextStyles.bodySMedium(
                                    color: navyBlueColor),
                              ),
                              Text(
                                  logic.showSpendingPercentage(entry.key),
                                  style: AppTextStyles.bodySRegular(
                                    color: grey700,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Text(
                       '₹${AppFunctions().formatNumberWithCommas(entry.value)}',
                        style:
                            AppTextStyles.bodySSemiBold(color: navyBlueColor),
                      )
                    ],
                  ),
                );
              }).toList(),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    logic.showLessData = !logic.showLessData;
                  },
                  child: Text(
                    logic.showLessData ? 'View All' : "View Less",
                    style: AppTextStyles.bodySMedium(color: blue600),
                  ),
                ),
              ),
               VerticalSpacer(32.h),
            ],
          );
        });
  }

  _selectMonthWidget() {
    return GetBuilder<FinSightsLogic>(
      id: logic.SHOW_MONTHS,
      builder: (logic) {
        return InkWell(
          onTap: () {
            logic.radioMonthWidget();
          },
          borderRadius: BorderRadius.circular(50.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.w),
              border: Border.all(
                color: darkBlueColor,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 7.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(logic.showMonths).bodyXSMedium(color: darkBlueColor),
                  SizedBox(
                    width: 4.w,
                  ),
                  SvgPicture.asset(
                    Res.dropDownTFSvg,
                    height: 3.5.h,
                    width: 6.5.w,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
