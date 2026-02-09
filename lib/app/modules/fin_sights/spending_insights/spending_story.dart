import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../res.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/app_text_styles.dart';
import '../fin_sights_logic.dart';

class SpendingStoryScreen extends StatelessWidget {
  SpendingStoryScreen({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your spending story',
              style: AppTextStyles.headingSMedium(color: navyBlueColor)),
          VerticalSpacer(24.h),
          Text(
            'Monthly spends',
            style: AppTextStyles.bodySMedium(color: darkBlueColor),
          ),
          VerticalSpacer(16.h),
          _buildMonthlySpendCard(),
          VerticalSpacer(32.h),

          // Top category section
          Text(
            'Top category',
            style: AppTextStyles.bodySMedium(color: darkBlueColor),
          ),
          VerticalSpacer(16.h),
          _buildTopCategoryCard(context),
          VerticalSpacer(3.h),
          if (logic.categoryData[logic.highestCategory.category]
                  ?.contains(logic.highestCategory.category) ==
              true)
            _buildSuggestionCard(context),
          VerticalSpacer(42.h),
        ],
      ),
    );
  }

  Row _buildMonthlySpendCard() {
    return Row(
      children: [
        Expanded(
          child: _buildSpendingCard(
            title: 'Highest',
            amount:
                "₹ ${AppFunctions().parseIntoCommaFormat(logic.highestSpend.amount.toString())}",
            month: logic.getMonthName(
                logic.highestSpend.year!, logic.highestSpend.month),
            img: Res.highestSpending,
          ),
        ),
         SizedBox(width: 16.w),
        Expanded(
          child: _buildSpendingCard(
            title: 'Lowest',
            amount:
                "₹ ${AppFunctions().parseIntoCommaFormat(logic.lowestSpend.amount.toString())}",
            month: logic.getMonthName(
                logic.lowestSpend.year!, logic.lowestSpend.month),
            img: Res.lowestSpending,
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingCard(
      {required String title,
      required String amount,
      required String month,
      required String img}) {
    return Card(
      color: Colors.white, // A slightly lighter dark blue
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.blue,
          width: .5.w,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(img),
            ),
            VerticalSpacer(8.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: AppTextStyles.bodyXSSemiBold(color: primaryDarkColor),
              ),
            ),
            VerticalSpacer(4.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                amount,
                style: AppTextStyles.bodyLSemiBold(color: darkBlueColor),
              ),
            ),
            VerticalSpacer(4.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                month,
                style: AppTextStyles.bodySMedium(color: primaryDarkColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCategoryCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              Res.spendingBg,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 72.w, right: 72.w, top: 36.h),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: SvgPicture.asset(Res.rsIcon),
                        ),
                        VerticalSpacer(16.h),
                        Text(
                          logic.highestCategory.category,
                          style:
                              AppTextStyles.headingXSBold(color: darkBlueColor),
                        ),
                        VerticalSpacer(4.h),
                        Text(
                          "₹ ${AppFunctions().parseIntoCommaFormat(logic.highestCategory.totalAmount.toString())}",
                          style:
                              AppTextStyles.bodySRegular(color: navyBlueColor),
                        ),
                        VerticalSpacer(4.h),
                        Text(
                          'spent in last 6 months',
                          style:
                              AppTextStyles.bodySRegular(color: navyBlueColor),
                        ),
                        VerticalSpacer(24.h),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSpacer(24.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Res.leaderboard),
                  const SizedBox(width: 8),
                  Text(
                    'Highest spend in ${logic.highestCategory.month} ₹ ${AppFunctions().parseIntoCommaFormat(logic.highestCategory.highestMonthlyAmount.toString())}',
                    style: AppTextStyles.bodySMedium(color: secondaryDarkColor),
                  ),
                ],
              ),
              VerticalSpacer(19.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: blue100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.w),
          bottomRight: Radius.circular(8.w),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Res.blueBulbSVG),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  logic.categoryData[logic.highestCategory.category].toString(),
                  style: AppTextStyles.bodySRegular(color: blue1700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
