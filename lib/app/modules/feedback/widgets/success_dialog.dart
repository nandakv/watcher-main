import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

class SuccessDialog extends StatelessWidget {
  final String body;
  const SuccessDialog(
      {Key? key, this.body = "We are working on it continuously "})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
        enableCloseIconButton: false,
        childPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            SvgPicture.asset(Res.confetti),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.w, top: 24.h, bottom: 9.h),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const SVGIcon(
                        icon: Res.crossMarkIcon,
                        size: SVGIconSize.medium,
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  Res.checkCircle,
                  width: 80.w,
                  height: 80.h,
                ),
                VerticalSpacer(12.h),
                Text(
                  "Thank you for your feedback!",
                  style: AppTextStyles.headingSMedium(
                      color: AppTextColors.brandBlueTitle),
                ),
                VerticalSpacer(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySRegular(
                        color: AppTextColors.neutralBody),
                  ),
                ),
                VerticalSpacer(32.h),
              ],
            )
          ],
        ));
  }
}
