import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../models/rich_text_model.dart';
import '../../home_page_right_arrow_widget.dart';

class LowAndGrowAlertWidget extends StatelessWidget {
  final Function() onUpgrade;
  final String newLimitAmount;
  final String oldLimitAmount;
  final String oldROI;
  final String newROI;
  final String numberExpiryDays;

  const LowAndGrowAlertWidget(
      {Key? key,
      required this.onUpgrade,
      required this.newLimitAmount,
      required this.oldLimitAmount,
      required this.oldROI,
      required this.newROI,
      required this.numberExpiryDays})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NudgeBadgeWidget(
      bgColor: goldColor,
      nudgeText: "Special Upgrade!",
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          color: updatesContainerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            SvgPicture.asset(Res.low_and_grow_alert),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 16, top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpacer(4),
                        _infoTextWidget(),
                        verticalSpacer(12),
                        _upgradeDetailsText(),
                        if (numberExpiryDays.isNotEmpty) _offerExpiryWarning(),
                        verticalSpacer(8),
                         HomePageButton(
                          title: 'Get Started',
                          onPressed: onUpgrade,
                          foregroundColor: Colors.white,
                          borderWidth: 0,
                          backgroundColor: navyBlueColor,
                        ),
                        verticalSpacer(16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerExpiryWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          //icon
          SvgPicture.asset(Res.expiryTimer),
          const SizedBox(width: 6),
          Text(
            "Offer expires in $numberExpiryDays days",
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: lightRedColor),
          )
        ],
      ),
    );
  }

  Widget _upgradeDetailsText() {
    return RichTextWidget(infoList: [
      RichTextModel(
        text: "₹$newLimitAmount  ",
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: primaryDarkColor),
      ),
      if (oldLimitAmount.isNotEmpty)
        RichTextModel(
          text: "₹$oldLimitAmount",
          textStyle: TextStyle(
              fontSize: 10,
              color: primaryDarkColor.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.lineThrough),
        ),
      RichTextModel(
        text: "\nat Interest Rate of $newROI% ",
        textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: primaryDarkColor,
            height: 1.5),
      ),
      if (oldROI.isNotEmpty)
        RichTextModel(
          text: "$oldROI% ",
          textStyle: const TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 8,
              color: secondaryDarkColor),
        ),
    ]);
  }

  Widget _infoTextWidget() {
    return const Padding(
      padding: EdgeInsets.only(right: 30),
      child: Text(
        "Rewarding your timely EMI payments. Claim your exclusive offer now!",
        style: TextStyle(
            fontSize: 10,
            height: 1.4,
            color: primaryDarkColor,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
