import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/data/repository/on_boarding_repository/bank_details_repository.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/home_screen_module/widgets/card_badge.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/html_text/html_text.dart';
// import 'package:privo/app/utils/screen_size_extension.dart';

import '../../../../components/button.dart';
import '../../../../res.dart';
import '../../../common_widgets/home_page_stepper_widget/home_page_stepper_widget.dart';
import '../../../common_widgets/home_page_stepper_widget/model/home_page_stepper_model.dart';
import '../../../common_widgets/rich_text_widget.dart';
import '../../../firebase/analytics.dart';
import '../../../models/rich_text_model.dart';
import '../../../utils/web_engage_constant.dart';
import '../widgets/home_page_right_arrow_widget.dart';
import '../widgets/offer_zone_section/offer_zone_card.dart';

enum CardBadgeType {
  none,
  ownership,
  progress,
  active,
  overdue,
  rejected,
  expired,
  closed,
}

class HomeScreenCard extends StatelessWidget {
  final Widget? bottomWidget;
  final List<RichTextModel>? titleTextValues;
  final List<RichTextModel> bodyTextValues;
  final bool showTopRightArrow;
  final Function()? onCta;
  final Function()? onRightArrowClicked;
  final String? nudgeText;
  final String? ctaText;
  final bool disableCTA;
  final LpcCard lpcCard;
  final Widget? child;
  final String? image;
  final String bodyText;
  final CardBadgeType cardBadgeType;
  final double bodyVerticalSpace;

  const HomeScreenCard(
      {Key? key,
      this.child,
      this.bottomWidget,
      this.titleTextValues,
      this.bodyTextValues = const [],
      this.onCta,
      this.nudgeText,
      required this.lpcCard,
      this.onRightArrowClicked,
      this.showTopRightArrow = false,
      this.ctaText,
      this.image,
      this.disableCTA = false,
      this.bodyText = "",
      this.bodyVerticalSpace = 40,
      this.cardBadgeType = CardBadgeType.ownership})
      : super(key: key);

  PrimaryHomeScreenCardLogic get logic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    switch (lpcCard.lpcCardType) {
      case LPCCardType.loan:
        return _cardWidget();
      case LPCCardType.topUp:
        return OfferZoneCard(lpcCard: lpcCard);
      case LPCCardType.lowngrow:
        return OfferZoneCard(
          lpcCard: lpcCard,
          inProgress: false,
        );
    }
  }

  Widget _bussinessOwners(String text) {
    return Container(
      // width: 116.w,
      // height: 22.h,
      decoration: _bussinessOwnersDecoration(),
      // padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.r,
          vertical: 4.h,
        ),
        child: Text(
          text,
          style: _bussinessOwnerTextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TextStyle _bussinessOwnerTextStyle() {
    return AppTextStyles.bodyXSMedium(color: secondaryYellow800);
  }

  BoxDecoration _bussinessOwnersDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: secondaryYellow800,
        width: 1.r,
      ),
      borderRadius: BorderRadius.circular(50.r),
    );
  }

  Widget _cardWidget() {
    return NudgeBadgeWidget(
      nudgeText: nudgeText,
      child: Container(
        width: 312.w,
        decoration: BoxDecoration(
          border: Border.all(color: blue1200),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                _bgImage(),
                if (child != null) child! else _topWidget(),
              ],
            ),
            if (lpcCard.appFormId.isNotEmpty) _bottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bgImage() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SvgPicture.asset(
          _computeImage(),
          // height: 103.w,
          width: 117.w,
        ),
      ),
    );
  }

  Widget _bottomWidget() {
    return bottomWidget ?? _computeStepperWidget();
  }

  Widget _computeStepperWidget() {
    if (logic.homeScreenModel.appState != PERSONAL_DETAILS) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: navyBlueColor, width: 0.2.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: _stepperWidget(),
      );
    }
    return SizedBox();
  }

  Widget _stepperWidget() {
    return HomePageStepperWidget(
      homePageStepperModel: HomePageStepperModel(
        appState: logic.homeScreenModel.appState,
        isBrowserToAppFlow: logic.homeScreenModel.isBrowserToAppFlow,
        isPartnerFlow: logic.homeScreenModel.isPartnerFlow,
        loanProductCode: logic.loanProductCode,
      ),
    );
  }

  Widget _topWidget() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        top: 16.h,
        bottom: 12.h,
        right: 20.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    richTextWidget(
                      titleTextValues ??
                          _getLPCTitle(logic.homeScreenModel.lpcName),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    _computeIndicator(),
                  ],
                ),
                VerticalSpacer(8.h),
                Padding(
                  padding: EdgeInsets.only(right: 98.w),
                  child: bodyText.isNotEmpty
                      ? HtmlText(bodyText)
                      : richTextWidget(bodyTextValues),
                ),
                verticalSpacer(bodyVerticalSpace.h),
                _computeCTA(),
              ],
            ),
          ),
          if (onRightArrowClicked != null)
            HomePageRightArrowWidget(
              onTap: onRightArrowClicked,
            )
        ],
      ),
    );
  }

  Widget richTextWidget(List<RichTextModel> textList) {
    return RichTextWidget(
      infoList: textList,
    );
  }

  Widget _computeTitleIndicator() {
    switch (lpcCard.loanProductCode) {
      case "SBL":
      case "UPL":
      case "SBD":
      case "SBA":
        return _bussinessOwners("For business owners");
      case "CLP":
        return _bussinessOwners("For salaried");
      default:
        return _bussinessOwners("For salaried");
    }
  }

  Widget _computeCTA() {
    if (ctaText == null && logic.homeScreenModel.buttonText.isEmpty) {
      return verticalSpacer(35.h);
    }
    return Button(
      buttonSize: ButtonSize.small,
      buttonType: ButtonType.primary,
      title: ctaText != null
          ? ctaText!.length > 13
              ? "Continue"
              : ctaText!
          : logic.homeScreenModel.buttonText,
      onPressed: () async {
        if (onCta == null) {
          logic.computeUserStateAndNavigate(
              AppFunctions().computeLoanProductCode(lpcCard.loanProductCode));
        } else {
          onCta!();
        }
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.homepageMainCTAClicked,
            attributeName: {
              "app_stage": logic.homeScreenModel.appState,
            });
      },
      enabled: !disableCTA,
    );
    // return GradientButton(
    //   onPressed: () async {
    //     if (onCta == null) {
    //       logic.computeUserStateAndNavigate(
    //           AppFunctions().computeLoanProductCode(lpcCard.loanProductCode));
    //     } else {
    //       onCta!();
    //     }
    //     AppAnalytics.trackWebEngageEventWithAttribute(
    //         eventName: WebEngageConstants.homepageMainCTAClicked,
    //         attributeName: {
    //           "app_stage": logic.homeScreenModel.appState,
    //         });
    //   },
    //   enabled: !disableCTA,
    //   fillWidth: false,
    //   edgeInsets: const EdgeInsets.symmetric(horizontal: 39, vertical: 9),
    //   title: ctaText ?? logic.homeScreenModel.buttonText,
    //   titleTextStyle: const TextStyle(
    //       fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white),
    // );
  }

  String _computeImage() {
    if (image == null) {
      return _fetchImageBasedOnLpc();
    }
    return image!;
  }

  String _fetchImageBasedOnLpc() {
    switch (AppFunctions().computeLoanProductCode(lpcCard.loanProductCode)) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
      case LoanProductCode.upl:
        return Res.sblHomePageCard;
      default:
        return Res.privoWalletWithMobile;
    }
  }

  List<RichTextModel> _getLPCTitle(String title) {
    return [
      RichTextModel(
        text: title,
        textStyle: AppTextStyles.bodySSemiBold(color: blue1200),
      )
    ];
  }

  _computeIndicator() {
    switch (cardBadgeType) {
      case CardBadgeType.ownership:
        return _computeTitleIndicator();
      case CardBadgeType.none:
        return verticalSpacer(0);
      default:
        return CardBadge(
          cardBadgeType: cardBadgeType,
        );
    }
  }
}
