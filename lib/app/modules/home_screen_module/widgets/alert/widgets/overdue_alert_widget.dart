import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

import '../../../../../common_widgets/home_page_button.dart';
import '../../home_page_right_arrow_widget.dart';

class OverdueAlertWidget extends StatelessWidget {
  final String refIDText;
  final String ctaTitle;
  final Function() onPay;
  final Function()? onKnowMore;
  final LpcCard lpcCard;
  final String infoText;
  final String nudgeTitle;

  const OverdueAlertWidget(
      {Key? key,
      required this.refIDText,
      required this.ctaTitle,
      required this.onPay,
        this.infoText = "Pay your EMI now to avoid late fee & charges",
      required this.lpcCard,
        this.nudgeTitle = "Overdue alert",
      required this.onKnowMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NudgeBadgeWidget(
      csBadge: CSBadge(
        text: nudgeTitle,
        showLeadingIcon: false,
        bgColor: red700,
        textColor: Colors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFe6f7fd),
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        padding: EdgeInsets.only(left: 16.w,top: 29.h),
        child: Column(
          children: [
            _lpcTitle(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpacer(12.h),
                      _infoText(),
                      VerticalSpacer(16.h),
                      _ctaButton(),
                      VerticalSpacer(28.h)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset(Res.overdueClock),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lpcTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lpcCard.loanProductName,
          style: AppTextStyles.bodyMMedium(color: AppTextColors.brandBlueTitle),
        ),
        _refIDText(),
      ],
    );
  }

  Widget _refIDText() {
    return Flexible(
      child: Padding(
        padding:  EdgeInsets.only(right: 16.w),
        child: Text(
          refIDText,
          textAlign: TextAlign.right,
          style: AppTextStyles.bodyXSRegular(color: grey700),
        ),
      ),
    );
  }

  Widget _ctaButton() {
    return Button(
      title: ctaTitle,
      buttonSize: ButtonSize.small,
      buttonType: ButtonType.primary,
      onPressed: onPay,
    );
  }

  Widget _infoText() {
    return Text(
      infoText,
      style: AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkSubtitle),
    );
  }
}
