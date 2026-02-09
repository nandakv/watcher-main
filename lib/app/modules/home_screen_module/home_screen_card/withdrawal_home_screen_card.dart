import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/expandable_home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/offer_zone_card.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/components/button.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';
import '../widgets/withdrawal_home_page/withdrawal_limit_details_widget.dart';

class WithdrawalHomeScreenCard extends StatelessWidget {
  const WithdrawalHomeScreenCard(
      {Key? key,
      required this.withdrawalHomePageType,
      required this.lpcCard,
      required this.pieChart})
      : super(key: key);

  PrimaryHomeScreenCardLogic get logic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);
  final LpcCard lpcCard;

  final WithdrawalDetailsHomeScreenType withdrawalHomePageType;
  final Widget pieChart;

  @override
  Widget build(BuildContext context) {
    switch (lpcCard.lpcCardType) {
      case LPCCardType.loan:
        return ExpandableHomeScreenCard(
          lpcCard: lpcCard,
          children: [
            _bodyWidget(),
            VerticalSpacer(26.h),
            _computeCTA(),
          ],
        );
      case LPCCardType.topUp:
        return OfferZoneCard(lpcCard: lpcCard);
      case LPCCardType.lowngrow:
        return OfferZoneCard(
          lpcCard: lpcCard,
          inProgress: false,
        );
    }
  }

  Widget _computeCTA() {
    if (withdrawalHomePageType.isFirstWithdrawal) {
      return Align(
        alignment: Alignment.centerLeft,
        child: _withdrawCta(),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _viewLoansCta(),
        SizedBox(
          width: 16.w,
        ),
        _withdrawCta(),
      ],
    );
  }

  Widget _viewLoansCta() {
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      tag: lpcCard.appFormId,
      builder: (logic) {
        return Button(
          fillWidth: true,
          title: "View details",
          buttonSize: ButtonSize.small,
          buttonType: ButtonType.secondary,
          isLoading: logic.isWithdrawButtonLoading,
          onPressed: () => logic.goToServicingScreen(
              LPCService.instance.lpcCards.indexOf(lpcCard)),
        );
      },
    );
  }

  Widget _withdrawCta() {
    bool isCLP =
        AppFunctions().computeLoanProductCode(lpcCard.loanProductCode) ==
            LoanProductCode.clp;
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      id: logic.WITHDRAW_BUTTON_ID,
      tag: lpcCard.appFormId,
      builder: (logic) {
        return Button(
          fillWidth: true,
          title: withdrawalHomePageType.isWithdrawalPolling
              ? "Check status"
              : "Withdraw",
          onPressed: () => logic.onWithdrawButtonClicked(
              withdrawalHomePageType, lpcCard,
              isCLP: isCLP),
          icon: isCLP
              ? const SVGIcon(
                  size: SVGIconSize.small,
                  icon: Res.errorFilledIcon,
                  color: red600,
                )
              : null,
          buttonSize: ButtonSize.small,
          buttonType: ButtonType.primary,
          enabled: !_computeIsDisabled(),
          isLoading: logic.isWithdrawButtonLoading,
        );
      },
    );
  }

  Widget _bottomWidget() {
    return Container(
        decoration: BoxDecoration(
          color: darkBlueColor.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: _computeBottomWidget());
  }

  Widget _computeBottomWidget() {
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      tag: lpcCard.appFormId,
      id: logic.WITHDRAW_BUTTON_ID,
      builder: (logic) {
        if (logic.isWithdrawButtonLoading) {
          return _pleaseWait();
        }
        return _bottomInfoWidget();
      },
    );
  }

  Widget _pleaseWait() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
          width: 10,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: offWhiteColor,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          _computePleaseWaitText(),
          style: const TextStyle(
            color: offWhiteColor,
            fontSize: 10,
            height: 1.1,
          ),
        )
      ],
    );
  }

  // Widget _baseBottomWidget({required Widget child}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: darkBlueColor.withOpacity(0.2),
  //       borderRadius: const BorderRadius.only(
  //         bottomRight: Radius.circular(16),
  //         bottomLeft: Radius.circular(16),
  //       ),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  //     child: child,
  //   );
  // }

  String _computePleaseWaitText() {
    return "Please wait for a moment";
  }

  Widget _bodyWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(right: 15.sp),
              child: _withdrawalDataPoints(),
            ),
          ),
        ),
        pieChart,
      ],
    );
  }

  Widget _withdrawalDataPoints() {
    return Container(
      child: ListView.builder(
        itemCount: withdrawalHomePageType.withdrawalDataPoints.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WithdrawalLimitDetailsWidget(
                withdrawalLimitType:
                    withdrawalHomePageType.withdrawalDataPoints[index],
              ),
              if (index != withdrawalHomePageType.withdrawalDataPoints.length)
                verticalSpacer(13.h)
            ],
          );
        },
      ),
    );
  }

  Widget _bottomInfoWidget() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Maintain regular payments to qualify for a higher credit limit",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: yellowColor,
              fontSize: 10,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Row _titleWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lpcCard.loanProductName,
          style: GoogleFonts.poppins(
              color: darkBlueColor, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () => logic.goToServicingScreen(
              LPCService.instance.lpcCards.indexOf(lpcCard),
            ),
            child: SvgPicture.asset(
              Res.arrow_right,
              colorFilter:
                  const ColorFilter.mode(darkBlueColor, BlendMode.srcIn),
            ),
          ),
        )
      ],
    );
  }

  bool _computeIsDisabled() {
    if (withdrawalHomePageType.isWithdrawalPolling) return false;
    if (withdrawalHomePageType.availableLimit == 0) return true;
    return false;
  }
}
