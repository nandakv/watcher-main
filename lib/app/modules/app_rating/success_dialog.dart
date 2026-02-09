import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VerticalSpacer(16.h),
        SvgPicture.asset(Res.successGradient),
        VerticalSpacer(16.h),
         Text(
           "Thank you for your feedback!",
           style: AppTextStyles.headingSMedium(color: navyBlueColor),
         ),
        VerticalSpacer(4.h),
         Text(
          "We are working on it continuously ",
          style: AppTextStyles.bodySMedium(color: AppTextColors.neutralBody),
        ),
        VerticalSpacer(40.h),
      ],
    );
  }
}
