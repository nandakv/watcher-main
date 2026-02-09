import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';

import '../../../../components/button.dart';
import '../../../../res.dart';
import '../referral_logic.dart';

class MyReferralInfoBottomSheet extends StatelessWidget {
  MyReferralInfoBottomSheet({super.key});

  final logic = Get.find<ReferralLogic>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Leader Board",
                style: AppTextStyles.headingSMedium(
                  color: blue1600,
                ),
              ),
              HorizontalSpacer(8.w),
              CSBadge(
                text: "Coming soon",
                //fill: true,
              )
              //.specialBadge(),
            ],
          ),
          VerticalSpacer(24.h),
          SvgPicture.asset(
            Res.referralLeaderBoard,
          ),
          VerticalSpacer(24.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Soon you’ll be able to view how you are performing against other users and refer more friends to stay on top of the leaderboard.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralDarkBody,
              ),
            ),
          ),
          VerticalSpacer(24.h),
          _computeCTA(),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

  GetBuilder<ReferralLogic> _computeCTA() {
    return GetBuilder<ReferralLogic>(
      id: logic.LEADERBOARD_BUTTON_ID,
      builder: (logic) {
        return logic.isLeaderBoardNotified
            ? _notifiedWidget()
            : Button(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.modifiedMedium,
                onPressed: logic.onNotifyMePressed,
                title: "Notify me",
              );
      },
    );
  }

  Container _notifiedWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppBackgroundColors.primaryLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        "We’ll notify you once it is live!",
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySRegular(
          color: AppTextColors.neutralDarkBody,
        ),
      ),
    );
  }
}
