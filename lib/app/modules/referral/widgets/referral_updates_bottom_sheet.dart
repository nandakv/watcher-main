import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../../res.dart';
import '../../../common_widgets/spacer_widgets.dart';

class ReferralUpdatesBottomSheet extends StatelessWidget {
  const ReferralUpdatesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Referral updates",
            style: AppTextStyles.headingSMedium(
              color: blue1600,
            ),
          ),
          VerticalSpacer(24.h),
          SvgPicture.asset(
            Res.referralBellIcon,
          ),
          VerticalSpacer(24.h),
          Text(
            "You will receive an update once the user has successfully signed up",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(
              color: AppTextColors.neutralDarkBody,
            ),
          ),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }
}
