import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class ReferralCard extends StatelessWidget {
  final String bodyText;
  final void Function()? onTap;

  const ReferralCard({super.key, required this.onTap, required this.bodyText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.r,
        bottom: 16.r,
        left: 16.r,
        right: 4.r,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: blue100,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 0),
            color: Color.fromRGBO(0, 0, 0, 0.15),
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Refer a friend!",
                    style: AppTextStyles.bodySSemiBold(
                      color: AppTextColors.primaryNavyBlueHeader,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  VerticalSpacer(4.h),
                  Text(
                    bodyText,
                    style: AppTextStyles.bodyXSRegular(
                      color: AppTextColors.neutralBody,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            HorizontalSpacer(4.w),
            SvgPicture.asset(
              Res.referralHomeImage,
              width: 148.w,
            ),
          ],
        ),
      ),
    );
  }
}
