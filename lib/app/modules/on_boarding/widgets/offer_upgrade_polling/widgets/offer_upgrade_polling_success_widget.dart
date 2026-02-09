import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/golden_badge.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_polling/offer_upgrade_polling_logic.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

import '../../../../../common_widgets/ROI_table.dart';
import '../../../../../theme/app_colors.dart';

class OfferPollingSuccessWidget extends StatelessWidget {
  OfferPollingSuccessWidget({
    Key? key,
    required this.offerUpgraded,
  }) : super(key: key);

  final bool offerUpgraded;

  final logic = Get.find<OfferUpgradePollingLogic>();

  @override
  Widget build(BuildContext context) {
    return BlueBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                Res.close_mark_svg,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcATop,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    offerUpgraded
                        ? "Congratulations!\nUpgrade successful"
                        : "Process Complete!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: skyBlueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset(
                    offerUpgraded ? Res.offer_upgraded_svg : Res.same_offer_svg,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (offerUpgraded) ...[
                    const GoldenBadge(title: "UPGRADED"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  Text(
                    AppFunctions.getIOFOAmount(logic.finalOffer.limitAmount),
                    style: GoogleFonts.poppins(
                      color: offWhiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  if (offerUpgraded)
                    Text(
                      AppFunctions.getIOFOAmount(
                          logic.initialOffer.limitAmount),
                      style: const TextStyle(
                        color: offWhiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    offerUpgraded
                        ? "Higher credit limit for financial flexibility"
                        : "Based on your credit eligibility, this is\nbest limit we can offer you.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: offWhiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ROITable(
                    tenure: _computeTenureText(logic.finalOffer),
                    interest: logic.finalOffer.interest,
                    processingFeeROI: logic.finalOffer.processingFee,
                    valueTextAlignment: TextAlign.end,
                    strikeThroughInterest: _computeOldInterest(),
                    strikeThroughTenure: _computeTenureText(
                      logic.initialOffer,
                      strikeThrough: true,
                    ),
                  ),
                  const Spacer(),
                  if (offerUpgraded)
                    GradientButton(
                      onPressed: logic.onContinueToKycClicked,
                      bottomPadding: 30,
                      title: "Continue to KYC",
                      buttonTheme: AppButtonTheme.light,
                    )
                  else ...[
                    _knowledgeBaseWidget(),
                    TextButton(
                      onPressed: logic.onContinueToKycClicked,
                      child: const Text(
                        "Continue to KYC",
                        style: TextStyle(
                          color: skyBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _knowledgeBaseWidget() {
    return InkWell(
      onTap: logic.onKnowledgeBaseClicked,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: appBarTitleColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    Res.vkyc_bulb_svg,
                    height: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Text(
                  "Want to Know how to improve Credit Eligibility ?",
                  style: TextStyle(
                    color: appBarTitleColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ),
              SvgPicture.asset(
                Res.arrow_right,
                colorFilter: const ColorFilter.mode(
                  secondaryDarkColor,
                  BlendMode.srcATop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _computeTenureText(OfferSection offerSection,
      {bool strikeThrough = false}) {
    if (strikeThrough &&
        logic.initialOffer.minTenure == logic.finalOffer.minTenure &&
        logic.finalOffer.maxTenure == logic.initialOffer.maxTenure) {
      return "";
    }
    return "${offerSection.minTenure.toInt()} - ${offerSection.maxTenure.toInt()} months";
  }

  String _computeOldInterest() {
    if (logic.finalOffer.interest == logic.initialOffer.interest) return "";
    return "${logic.initialOffer.interest}";
  }
}
