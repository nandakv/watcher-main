import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class BpiInfoWidget extends StatelessWidget {
  const BpiInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppBackgroundColors.primaryLight,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer(16.h),
            Text(
              "Broken Period Interest",
              style: AppTextStyles.headingSMedium(
                  color: AppTextColors.brandBlueTitle),
            ),
            VerticalSpacer(4.h),
            Text(
              "It refers to the interest charged when the gap between the loan disbursal date and your 1st EMI is more than 30 days",
              style: AppTextStyles.bodyXSRegular(
                  color: AppTextColors.neutralBody),
            ),
            VerticalSpacer(32.h),
          ],
        ),
      ),
    );
  }
}
