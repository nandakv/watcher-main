import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/round_outline_badge_widget.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import '../../../utils/app_text_styles.dart';
import 'primary_home_screen_card/primary_home_screen_card_logic.dart';

class ExploreMoreCard extends StatelessWidget {
  final String loanProductCode;
  final bool isMultiCard;
  final LpcCard lpcCard;

  ExploreMoreCard({
    super.key,
    required this.loanProductCode,
    this.isMultiCard = false,
    required this.lpcCard,
  });

  final logic = Get.find<HomeScreenLogic>();

  PrimaryHomeScreenCardLogic get primaryCardLogic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMultiCard ? 148.w : 312.w,
      decoration: _gradientBorderDecoration(),
      child: InkWell(
        onTap: () {
          primaryCardLogic.goToKnowMore(KnowMoreGetStartedState.knowMore,
              AppFunctions().computeLoanProductCode(loanProductCode));
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SvgPicture.asset(
                    _computeImage(),
                    height: isMultiCard ? 70.h : 85.h,
                    width: isMultiCard ? 86.w : 133.w,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isMultiCard ? 12.w : 20.w,
                top: 20.h,
                bottom: 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMultiCard) ...[
                    _computeTitleIndicator(),
                    SizedBox(height: 10.h,),
                  ],
                  _cardTitle(),
                  verticalSpacer( isMultiCard ? 5.h : 16.h),
                  if (loanProductCode == "CLP") ...[
                    _clpBodyText(),
                  ] else ...[
                    _sblBodyText(),
                  ],
                  VerticalSpacer(isMultiCard ? 54.h : 12.h),
                  if(!isMultiCard)
                  _knowMore(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightArrow() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SvgPicture.asset(
          Res.rightArrow,
          color: darkBlueColor,
          height: 8,
          width: 5,
        ),
      ),
    );
  }

  String _computeImage() {
    switch (loanProductCode) {
      case "CLP":
        return Res.privoHomePageCard;
      default:
        return Res.sblHomePageCard;
    }
  }

  Text _knowMore() {
    return Text(
      "Know more",
      style: AppTextStyles.bodyXSSemiBold(color: blue600),
    );
  }

  Row _cardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          _computeTitle(),
          style: AppTextStyles.bodySMedium(color: blue1600),
        ),
        if (!isMultiCard) ...[
          SizedBox(
            width: 8.w,
          ),
          _computeTitleIndicator(),
        ],
      ],
    );
  }

  Widget _computeTitleIndicator() {
    switch (loanProductCode) {
      case "SBL":
      case "UPL":
      case "SBD":
      case "SBA":
        return const RoundOutlineBadgeWidget(title: "For business owners");
      case "CLP":
        return const RoundOutlineBadgeWidget(title: "For salaried");
      default:
        return const RoundOutlineBadgeWidget(title: "For salaried");
    }
  }

  Widget _clpBodyText() {
    return Padding(
      padding: EdgeInsets.only(right: isMultiCard ? 19.w : 117.w),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Figtree'),
          children: [
            TextSpan(
              text: "Get a loan upto ",
              style: AppTextStyles.bodyXSMedium(color: grey700),
            ),
            TextSpan(
              text: "₹5 lakhs ",
              style: AppTextStyles.bodyXSSemiBold(color: grey900),
            ),
            TextSpan(
              text: "with interest rates starting at",
              style: AppTextStyles.bodyXSMedium(color: grey700),
            ),
            TextSpan(
              text: " 9.9% p.a.",
              style: AppTextStyles.bodyXSSemiBold(color: grey900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sblBodyText() {
    return Padding(
      padding: EdgeInsets.only(right: isMultiCard ? 19.w :117.w),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Figtree'),
          children: [
            TextSpan(
              text: "Loan upto ",
              style: AppTextStyles.bodyXSMedium(color: grey700),
            ),
            TextSpan(
              text: "₹15 lakhs ",
              style: AppTextStyles.bodyXSSemiBold(color: grey900),
            ),
            TextSpan(
              text: "with interest rates starting at",
              style: AppTextStyles.bodyXSMedium(color: grey700),
            ),
            TextSpan(
              text: " 19% p.a.",
              style: AppTextStyles.bodyXSSemiBold(color: grey900),
            ),
          ],
        ),
      ),
    );
  }

  String _computeTitle() {
    switch (loanProductCode) {
      case "CLP":
        return "Privo Instant Loan";
      default:
        return "Small Business Loan";
    }
  }

  BoxDecoration _gradientBorderDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: blue1200,
        width: 1.r,
      ),
    );
  }
}
