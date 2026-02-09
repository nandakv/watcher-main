import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/home_screen_title_subtitle.dart';
import 'package:privo/app/common_widgets/offer_top_credit_line_components.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/utils/native_channels.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_widgets/ROI_table.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../../theme/app_colors.dart';
import '../../on_boarding/mixins/app_form_mixin.dart';

class HomeScreenTopUpgradeOfferWidget extends StatelessWidget {
  HomeScreenTopUpgradeOfferWidget({
    Key? key,
    required this.offerDetailsModel,
    required this.lpcCard,
  }) : super(key: key);

  final UpgradeOfferDetailsHomeScreenType offerDetailsModel;

  final LpcCard lpcCard;

  get homeScreenCardLogic => Get.find<PrimaryHomeScreenCardLogic>(
        tag: lpcCard.appFormId,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeScreenTitleSubTitle(
            amount: double.parse(
              offerDetailsModel.limitAmount.replaceAll(",", ""),
            ),
            isLpcStatus: homeScreenCardLogic.loanProductCode,
            isPartnerAPI: homeScreenCardLogic.homeScreenModel.isPartnerFlow,
            isOfferUpgraded: offerDetailsModel.isOfferUpgraded,
            oldAmount: offerDetailsModel.isOfferUpgraded
                ? double.parse(
                    offerDetailsModel.pastLimit.replaceAll(',', ''),
                  )
                : 0,
          ),
          const SizedBox(
            height: 10,
          ),

          if (offerDetailsModel.isUpgradeEligible) ...[
            GradientButton(
              onPressed: () =>
                  homeScreenCardLogic.onHomeScreenOfferUpgradeCTAPressed(
                actionType: "upgrade",
              ),
              enabled: homeScreenCardLogic.homeScreenCardState !=
                  HomeScreenCardState.loading,
              buttonTheme: AppButtonTheme.light,
              title: "Upgrade your offer",
              fillWidth: false,
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 10,
                color: lightEnabledButtonTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],

          // if (homeScreenControllerLogic.loanProductCode != LoanProductCode.clp)
          // ROITable(
          //   processingFeeROI: offerDetailsModel.processingFee,
          //   interest: double.parse(offerDetailsModel.roi),
          //   tenure: _computeTenureMonths(),
          // )
          // else
          //   OfferTopCreditLineComponents(
          //     interest: "${offerDetailsModel.roi}%",
          //     processingFee:
          //         _computeProcessingFee(offerDetailsModel.processingFee),
          //     tenure:
          //         "${offerDetailsModel.minTenure.toInt()} - ${offerDetailsModel.maxTenure.toInt()} months",
          //     oldInterest: offerDetailsModel.isROIDecreased
          //         ? offerDetailsModel.pastROI
          //         : "",
          //   ),
          const SizedBox(
            height: 24,
          ),
          // Flexible(
          //   child:
          //       homeScreenControllerLogic.loanProductCode != LoanProductCode.clp
          //           ? const SizedBox()
          //           : Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 45),
          //               child: GradientButton(
          //                   onPressed: () {
          //                     homeScreenControllerLogic.goToOnBoardingPage();
          //                   },
          //                   title: homeScreenControllerLogic
          //                       .homeScreenModel.buttonText,
          //                   buttonTheme: AppButtonTheme.light),
          //             ),
          // ),
        ],
      ),
    );
  }

  String _computeProcessingFee(String processingFee) {
    if (processingFee == "0.0" || processingFee == "0") {
      return "$processingFee%";
    } else {
      return "Upto $processingFee%";
    }
  }

  String _computeTenureMonths() {
    if (homeScreenCardLogic.loanProductCode != LoanProductCode.clp) {
      return "${offerDetailsModel.maxTenure} months";
    }
    return "${offerDetailsModel.minTenure}-${offerDetailsModel.maxTenure} months";
  }
}
