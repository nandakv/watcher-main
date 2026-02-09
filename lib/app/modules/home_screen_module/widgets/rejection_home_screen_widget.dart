import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/common_widgets/rejection_details_bottom_sheet.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/feedback/feedback_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/expandable_home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/share_experience_widget.dart';
import 'package:privo/app/utils/html_text/html_text.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../components/button.dart';
import '../../../models/home_card_rich_text_values.dart';
import '../../../theme/app_colors.dart';
import '../home_screen_widget/home_screen_widget.dart';
import 'offer_zone_section/offer_zone_card.dart';

class RejectionHomeScreenWidget extends StatefulWidget {
  const RejectionHomeScreenWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.lpcCard,
    required this.showFeedback,
    this.rejectionHomeScreenType,
  }) : super(key: key);

  final String title;
  final String message;
  final LpcCard lpcCard;
  final bool showFeedback;
  final RejectionHomeScreenType? rejectionHomeScreenType;

  @override
  State<RejectionHomeScreenWidget> createState() =>
      _RejectionHomeScreenWidgetState();
}

class _RejectionHomeScreenWidgetState extends State<RejectionHomeScreenWidget> {
  final homeScreenLogic = Get.find<HomeScreenLogic>();

  final HomeCardTexts homeCardTexts = HomeCardTexts();

  @override
  Widget build(BuildContext context) {
    switch (widget.lpcCard.lpcCardType) {
      case LPCCardType.loan:
        return _rejectionCard();
      case LPCCardType.topUp:
      case LPCCardType.lowngrow:
        return OfferZoneCard(
          lpcCard: widget.lpcCard,
          rejectionHomeScreenType: widget.rejectionHomeScreenType,
        );
    }
  }

  HomeScreenWidget _rejectionCard() {
    return HomeScreenWidget(
      lpcCard: widget.lpcCard,
      homePageCard: ExpandableHomeScreenCard(
        lpcCard: widget.lpcCard,
        padding: EdgeInsets.zero,
        cardBadgeType: CardBadgeType.rejected,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: HtmlText(widget.message),
          ),
          isReasonAvailable ? _knowWhyCta() : SizedBox(),
          widget.showFeedback
              ? ShareExperienceWidget(
                  onTap: () => homeScreenLogic.onShareFeedbackClicked(
                      FeedbackType.rejected, widget.lpcCard),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _knowWhyCta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Button(
          buttonSize: ButtonSize.small,
          buttonType: ButtonType.primary,
          title: "Know Why",
          onPressed: onKnowMoreClicked,
        ),
      ),
    );
  }

  onKnowMoreClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.knowWhyPopped,
    );
    Get.bottomSheet(RejectionDetailsBottomSheet(), isDismissible: false);
  }

  bool get isReasonAvailable =>
      widget.title.isNotEmpty && widget.message.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _expandCard();
    _toggleHomePageTitle();
  }

  void _toggleHomePageTitle() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeScreenLogic.toggleHomePageTitle("Your Loan Dashboard");
      homeScreenLogic.toggleExploreMore(false);
    });
  }

  void _expandCard() {
    final primaryCardLogic =
        Get.find<PrimaryHomeScreenCardLogic>(tag: widget.lpcCard.appFormId);
    primaryCardLogic.expandable = true;
    primaryCardLogic.initiallyExpanded = true;
  }
}
