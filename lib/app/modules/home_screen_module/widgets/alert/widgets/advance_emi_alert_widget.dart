import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/button.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/home_page_button.dart';
import '../../../../../common_widgets/vertical_spacer.dart';
import '../../../../../theme/app_colors.dart';

class AdvanceEMIAlertWidget extends StatelessWidget {
  final Function() onKnowMore;
  final Function() onPayNow;
  final String loanInfoText;

  const AdvanceEMIAlertWidget(
      {Key? key, required this.onKnowMore, required this.onPayNow,required this.loanInfoText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NudgeBadgeWidget(
      csBadge: const CSBadge(
        text: "EMI Fast-track",
        bgColor: secondaryYellow800,
      ).special(showLeadingIcon: false),
      bgColor: goldColor,
      child: Container(
        decoration: BoxDecoration(
          color: updatesContainerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                Res.advance_emi_alert,
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacer(8.h),
                  _infoTextWidget(),
                  VerticalSpacer(16.h),
                  _ctaButtonAndKnowMore(),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _ctaButtonAndKnowMore() {
    return Row(
      children: [
        _payNowButton(),
         SizedBox(width: 16.w),
        _knowMoreButton(),
      ],
    );
  }

  Widget _knowMoreButton() {
    return InkWell(
      onTap: onKnowMore,
      child: Text(
        "Know more",
        style: AppTextStyles.bodySSemiBold(color: blue1600),
      ),
    );
  }

  Widget _payNowButton() {
    return Button(
      title: "Pay Now",
      buttonSize: ButtonSize.small,
      buttonType: ButtonType.primary,
      onPressed: onPayNow,
    );
  }

  Widget _alertBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTileWidget("Get credit limit upgrade"),
        _infoTileWidget("Ease of multiple payment options")
      ],
    );
  }

  Widget _infoTileWidget(String text) {
    return Text(
      "• $text",
      style: AppTextStyles.bodyXSRegular(color: AppTextColors.neutralDarkBody),
    );
  }

  Widget _infoTextWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "Pay your upcoming EMI before the due date with ease",
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkSubtitle),
          ),
        ),
        HorizontalSpacer(23.w),
        Text(loanInfoText,style: AppTextStyles.bodyXSMedium(color: AppTextColors.neutralDarkSubtitle),)
      ],
    );
  }
}
