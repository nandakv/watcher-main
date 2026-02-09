import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/home_card_rich_text_values.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/feedback/feedback_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/res.dart';

import '../../../../models/rich_text_model.dart';
import '../../../../theme/app_colors.dart';
import '../../home_screen_widget/home_screen_widget.dart';
import 'expiry_home_page_card_logic.dart';

class ExpiryHomePageCard extends StatefulWidget {
  final FeedbackType? feedbackType;
  final String nudgeText;
  final List<RichTextModel> titleValues;
  final List<RichTextModel> bodyValues;
  final LpcCard lpcCard;

  const ExpiryHomePageCard(
      {Key? key,
      this.feedbackType,
      required this.lpcCard,
      required this.nudgeText,
      required this.titleValues,
      required this.bodyValues})
      : super(key: key);

  @override
  State<ExpiryHomePageCard> createState() => _ExpiryHomePageCardState();
}

class _ExpiryHomePageCardState extends State<ExpiryHomePageCard>
    with AfterLayoutMixin {
  final logic = Get.put(ExpiryHomePageCardLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpiryHomePageCardLogic>(builder: (logic) {
      return HomeScreenWidget(
        lpcCard: widget.lpcCard,
        homePageCard: HomeScreenCard(
            lpcCard: widget.lpcCard,
            titleTextValues:
                HomeCardTexts().fetchLPCTitle(widget.lpcCard.loanProductName),
            cardBadgeType: CardBadgeType.expired,
            ctaText: logic.ctaText,
            image: Res.offerExpiryAlert,
            bodyVerticalSpace: 16,
            onCta: logic.onNotifyMe,
            bodyTextValues: widget.bodyValues,
            bottomWidget: _bottomWidget()),
      );
    });
  }

  _bottomWidget() {
    return Container(
      decoration: BoxDecoration(
          borderRadius:  BorderRadius.only(
            bottomRight: Radius.circular(8.r),
            bottomLeft: Radius.circular(8.r),
          ),
          border: Border.all(color: darkBlueColor, width: 0.2.w)),
      padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
      child: Center(
        child: Text(
          "Please check again and re-apply after 90 days",
          style: TextStyle(
              color: darkBlueColor,
              fontSize: 10.sp,
              height: 14.sp / 10.sp,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
