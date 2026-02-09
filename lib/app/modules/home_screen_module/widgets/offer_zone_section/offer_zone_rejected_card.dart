import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/exit_page.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/expandable_home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/top_up_offer_rejection_screen.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../models/home_screen_model.dart';
import '../../../feedback/feedback_logic.dart';
import '../../home_screen_logic.dart';
import '../share_experience_widget.dart';

class OfferZoneRejectedCard extends StatefulWidget {
  const OfferZoneRejectedCard({
    super.key,
    required this.rejectionHomeScreenType,
    required this.lpcCard,
  });

  final RejectionHomeScreenType rejectionHomeScreenType;
  final LpcCard lpcCard;

  @override
  State<OfferZoneRejectedCard> createState() => _OfferZoneRejectedCardState();
}

class _OfferZoneRejectedCardState extends State<OfferZoneRejectedCard>
    with AfterLayoutMixin {
  final homeScreenLogic = Get.find<HomeScreenLogic>();

  PrimaryHomeScreenCardLogic get logic => Get.find<PrimaryHomeScreenCardLogic>(
        tag: widget.lpcCard.appFormId,
      );

  @override
  Widget build(BuildContext context) {
    return ExpandableHomeScreenCard(
      lpcCard: widget.lpcCard,
      outlineInputBorder: null,
      cardBadgeType: CardBadgeType.none,
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Unfortunately, we are unable to offer you a Top-up loan at this time.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: secondaryDarkColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              HomePageButton(
                backgroundColor: appBarTitleColor,
                onPressed: () {
                  Get.to(() => const TopUpOfferRejectionScreen());
                },
                title: "View More",
                titleColor: Colors.white,
              ),
            ],
          ),
        ),
        widget.rejectionHomeScreenType.showFeedback
            ? ShareExperienceWidget(
                onTap: () => homeScreenLogic.onShareFeedbackClicked(
                  FeedbackType.rejected,
                  widget.lpcCard,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.expandable = true;
    logic.update([logic.EXPANSION_CARD_ID]);
  }
}
