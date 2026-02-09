import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/card_badge.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/offer_zone_rejected_card.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/gradient_border_container.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../models/home_screen_card_model.dart';
import '../../../../models/home_screen_model.dart';
import '../../../../services/lpc_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_functions.dart';
import '../../../../utils/html_text/html_text.dart';
import '../../home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import '../round_outline_badge_widget.dart';

class OfferZoneCard extends StatelessWidget {
  OfferZoneCard({
    super.key,
    required this.lpcCard,
    this.isKnowMore = false,
    this.daysToExpiry = "",
    this.rejectionHomeScreenType,
    this.inProgress = true,
  });

  final LpcCard lpcCard;
  final bool isKnowMore;
  final String daysToExpiry;
  final RejectionHomeScreenType? rejectionHomeScreenType;
  final bool inProgress;

  PrimaryHomeScreenCardLogic get logic => Get.find<PrimaryHomeScreenCardLogic>(
      tag: lpcCard.lpcCardType == LPCCardType.lowngrow
          ? "${lpcCard.appFormId}_low_grow"
          : lpcCard.appFormId);

  final svgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      color: Colors.white,
      borderRadius: 8.r,
      child: rejectionHomeScreenType != null
          ? OfferZoneRejectedCard(
              rejectionHomeScreenType: rejectionHomeScreenType!,
              lpcCard: lpcCard,
            )
          : _offerCard(),
    );
  }

  SizedBox _offerCard() {
    return SizedBox(
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.r),
                ),
                child: SvgPicture.asset(
                  _computeIllustration(),
                  key: svgKey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topUpCardTitleRow(),
                VerticalSpacer(16.h),
                Padding(
                  padding: EdgeInsets.only(right: 110.w),
                  child: HtmlText(
                    _computeBodyText(),
                  ),
                ),
                VerticalSpacer(20.h),
                if (logic.homeScreenModel.buttonText.isNotEmpty)
                  Button(
                    title: logic.homeScreenModel.buttonText,
                    buttonSize: ButtonSize.small,
                    buttonType: ButtonType.primary,
                    onPressed: () => logic.topUpCTAPressed(
                      isKnowMore: isKnowMore,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get isMultipleOffers => LPCService.instance.upgradeCards.length >= 2;

  String _computeBodyText() {
    String styleTag = "h1";
    String newLineTag = "\n";

    if (isMultipleOffers) {
      styleTag = "b";
      newLineTag = " ";
    }

    return logic.homeScreenModel.info
        .replaceAll("h1", styleTag)
        .replaceAll("\n", newLineTag);
  }

  String _computeIllustration() {
    return lpcCard.lpcCardType == LPCCardType.lowngrow
        ? Res.lowGrowHomePageIllustrationSVG
        : Res.offerZoneTopUpCardSVG;
  }

  Row _topUpCardTitleRow() {
    return Row(
      children: [
        Text(
          lpcCard.loanProductName,
          style: AppTextStyles.headingXSMedium(color: blue1600),
        ),
        HorizontalSpacer(8.w),
        _computeBadgeWidget(),
        HorizontalSpacer(8.w),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: SvgPicture.asset(
            Res.accordingRight,
            height: 24.h,
            width: 24.w,
          ),
        ),
      ],
    );
  }

  Widget _computeBadgeWidget() {
    if (inProgress || daysToExpiry.isNotEmpty) {
      return CardBadge(
        cardBadgeType: daysToExpiry.isNotEmpty
            ? CardBadgeType.expired
            : CardBadgeType.progress,
        text: daysToExpiry,
      );
    }

    return RoundOutlineBadgeWidget(
      title: lpcCard.lpcCardType == LPCCardType.lowngrow
          ? "Credit Line"
          : "Small Business Loan",
    );
  }
}
