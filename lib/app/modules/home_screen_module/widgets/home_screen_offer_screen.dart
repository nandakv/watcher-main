import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/offer_top_credit_line_components.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/processing_fee_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';

import 'package:privo/res.dart';
import '../../../common_widgets/ROI_table.dart';
import '../../../common_widgets/gradient_button.dart';

import '../../../common_widgets/home_screen_title_subtitle.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/ui_constant_text.dart';
import '../../on_boarding/widgets/offer/offer_logic.dart';

class HomeScreenOfferScreen extends StatelessWidget {
  const HomeScreenOfferScreen(
      {Key? key,
      this.limitAmount = 0,
      this.interest = 0,
      this.minTenure = 0,
      this.maxTenure = 0,
      this.processingFeeModel,
      this.isUpgradeEligible = false,
      this.isPartnerFlow = false,
      this.isOnboardingOfferScreen = false,
      this.onPressOfferUpgrade,
      this.processingFee = ""})
      : super(key: key);
  final double limitAmount;
  final double interest;
  final double minTenure;
  final double maxTenure;
  final String processingFee;
  final bool isPartnerFlow;
  final bool isUpgradeEligible;
  final bool isOnboardingOfferScreen;
  final ProcessingFeeModel? processingFeeModel;
  final Function? onPressOfferUpgrade;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferLogic>(builder: (logic) {
      return Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.clear_rounded,
                color: infoTextColor,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                HomeScreenTitleSubTitle(
                  amount: limitAmount,
                  isPartnerAPI: isPartnerFlow,
                  isOfferUpgraded: isUpgradeEligible,
                  isOnboardingOfferScreen: isOnboardingOfferScreen,
                ),
                if (isUpgradeEligible)
                  TextButton(
                    onPressed: () {
                      if (onPressOfferUpgrade != null) {
                        onPressOfferUpgrade!();
                      }
                    },
                    child: const Text(
                      'Unlock greater possibilities- Get a higher credit limit',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: skyBlueColor,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                OfferTopCreditLineComponents(
                  interest: "$interest%",
                  tenure: _computeTenureText(),
                  processingFee: _computeProcessingFee(),
                ),
                const SizedBox(
                  height: 30,
                ),
                processingFeeModel != null &&
                        processingFeeModel!.offerFirstHeaderTitle.isNotEmpty &&
                        processingFee != "0.0"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _discountOfferText(),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
    /*      if (!logic.isPageLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              child: GetBuilder<OfferLogic>(
                id: 'button',
                builder: (logic) {
                  return GradientButton(
                      title: "Complete KYC",
                      onPressed: () => logic.onKycProceed(),
                      gradient: _computeGradientOnButtonType(),
                      // enabled: logic.isChecked,
                      isLoading: logic.isButtonLoading,
                      buttonTheme: AppButtonTheme.light);
                },
              ),
            ),*/
        ],
      );
    });
  }

  LinearGradient _computeGradientOnButtonType() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        preRegistrationEnabledGradientColor2,
        preRegistrationEnabledGradientColor3
      ],
    );
  }

  Column _discountOfferText() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              Res.discount,
              width: 14,
              height: 14,
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                "Offer applied",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.22,
                  color: const Color(0xFFFFF3EB),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            processingFeeModel!.offerFirstHeaderTitle +
                processingFeeModel!.offerSecondHeaderTitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.19,
              color: const Color(0xFFFFF3EB),
            ),
          ),
        ),
      ],
    );
  }

  String _computeTenureText() {
    return "${minTenure.toInt()} - ${maxTenure.toInt()}\nmonths";
  }

  String _computeProcessingFee() {
    if (processingFee == "0.0" || processingFee == "0") {
      return "$processingFee%";
    } else {
      return "Upto $processingFee%";
    }
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12, color: Color(0xffFFF3EB), fontWeight: FontWeight.normal);
  }
}
