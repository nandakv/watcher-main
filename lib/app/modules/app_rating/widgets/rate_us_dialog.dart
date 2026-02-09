import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/app_rating/app_rating_logic.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class RateUsDialog extends StatelessWidget {
  RateUsDialog({
    Key? key,
  }) : super(key: key);

  var logic = Get.find<AppRatingLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Loving the experience",
            style: AppTextStyles.headingSMedium(color: blue1600),
          ),
          VerticalSpacer(4.h),
          Text(
            "Rate and review us on ${PrivoPlatform.platformService.getAppStoreText()} to help others like you ",
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(24.h),
          Text(
            "Top reviews from our users",
            style: AppTextStyles.bodyMMedium(color: blue1600),
          ),
          VerticalSpacer(12.h),
          copyableTextBox("Makes everything so convenient!"),
          VerticalSpacer(12.h),
          copyableTextBox(
              "Fantastic app! Super easy to use and navigate"),
          VerticalSpacer(12.h),
          copyableTextBox(
              "Finally, an app that makes managing loans simple and hassle free"),
          VerticalSpacer(36.h),
          Text(
            "You can use these default reviews by copying them or manually type on ${PrivoPlatform.platformService.getAppStoreText()} ",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(12.h),
          Button(
            buttonType: ButtonType.primary,
            buttonSize: ButtonSize.large,
            title: "Rate us",
            onPressed: logic.showInAppReview,
          ),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }

  Widget copyableTextBox(String title) {
    return Container(
      decoration: BoxDecoration(
          color: blue200, borderRadius: BorderRadius.circular(8.r)),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.bodySRegular(
                  color: AppTextColors.neutralDarkBody),
            ),
          ),
          HorizontalSpacer(16.w),
          InkWell(
              onTap: () {
                logic.onCopyTapped(title);
              },
              child: SvgPicture.asset(Res.copySimple))
        ],
      ),
    );
  }
}
