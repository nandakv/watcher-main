import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'package:privo/app/models/home_card_rich_text_values.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/upl_disbursal_home_page_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_widget/home_screen_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/block_home_page_card_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';

import 'disbursal_complete_home_screen_card_logic.dart';

class DisbursalCompleteHomeScreenCard extends StatefulWidget {
  DisbursalCompleteHomeScreenCard(
      {Key? key,
      required this.uplDisbursalCompleteHomePageModel,
      required this.lpcCard})
      : super(key: key);

  final UplDisbursalHomeScreenType uplDisbursalCompleteHomePageModel;
  final LpcCard lpcCard;

  @override
  State<DisbursalCompleteHomeScreenCard> createState() => _DisbursalCompleteHomeScreenCardState();
}

class _DisbursalCompleteHomeScreenCardState extends State<DisbursalCompleteHomeScreenCard>
    with AfterLayoutMixin {
  final homeScreenLogic = Get.find<HomeScreenLogic>();
  late final HomeCardTexts homeCardTexts = HomeCardTexts();

  DisbursalCompleteHomeScreenLogic get logic => Get.put(DisbursalCompleteHomeScreenLogic(), tag: widget.lpcCard.appFormId);

  PrimaryHomeScreenCardLogic get primaryHomeScreenLogic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: widget.lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DisbursalCompleteHomeScreenLogic>(
      id: logic.WIDGET_KEY,
      tag: widget.lpcCard.appFormId,
      builder: (logic) {
        switch (logic.uplLoanDetailsTopWidgetState) {
          case UPLLoanDetailsTopWidgetState.loading:
            return const SkeletonLoadingWidget(
              skeletonLoadingType: SkeletonLoadingType.primaryHomeScreenCard,
            );
          case UPLLoanDetailsTopWidgetState.success:
            return _onUplDetailsLoaded(widget.lpcCard);
          case UPLLoanDetailsTopWidgetState.error:
            return BlockHomeScreenCardWidget(
              message:
                  "Encountering a glitch while loading\ndetails. Refresh to retry.",
              showRefreshButton: primaryHomeScreenLogic.homeScreenCardState !=
                  HomeScreenCardState.iosBeta,
              title: widget.lpcCard.loanProductName,
              lpcCard: widget.lpcCard,
            );
        }
      },
    );
  }

  Widget _onUplDetailsLoaded(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      // alertWidget: HomePageWithdrawalAlert(
      //   lpcCard: lpcCard,
      // ),
      homePageCard: UPLDisbursalHomePageCard(
          emiAmount: logic.fetchMonthlyEmi(),
          emiPaid: logic.loanDetailsModel.emiPaid,
          emiTotal: logic.loanDetailsModel.emiTotal,
          loanAmount: logic.fetchLoanAmount(),
          lpcCard: lpcCard,
          cardBadgeType: logic.fetchCardBadgeType(),
          isFundTransferInProgress: false),
    );
  }

  TextStyle get titleTextStyle {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.58,
      color: skyBlueColor,
    );
  }

  TextStyle amountTextStyle(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xffFFF3EB),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(
      widget.lpcCard,
      widget.uplDisbursalCompleteHomePageModel,
    );
  }
}
