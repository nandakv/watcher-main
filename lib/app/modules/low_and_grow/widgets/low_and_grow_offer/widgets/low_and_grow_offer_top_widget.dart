import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/low_and_grow_offer_logic.dart';

import '../../../../../common_widgets/ROI_table.dart';
import '../../../../../common_widgets/offer_top_credit_line_components.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../utils/app_functions.dart';
import '../model/low_and_grow_enhanced_offer_model.dart';

class LowAndGrowOfferTopWidget extends StatelessWidget {
  String? tenure;
  String? strikeThroughProcessingFee;
  String? enhancedTenure;
  LowAndGrowEnhancedOfferModel model;

  LowAndGrowOfferTopWidget(
      {Key? key,
      required this.model,
      this.tenure,
      this.enhancedTenure,
      this.strikeThroughProcessingFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Text(
          "Level Up Your\nCredit Line!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: skyBlueColor,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "₹ ${AppFunctions().parseIntoCommaFormat(model.enhancedOfferSection!.limitAmount.toString())}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: const Color(0xffFFF3EB),
          ),
        ),
        if (model.upgradedFeatures!.limitAmount == 1)
          Text(
            "₹ ${AppFunctions().parseIntoCommaFormat(model.offerSection!.limitAmount.toString())}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color(0xffFFF3EB),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Better credit line for higher financial flexibility",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xffFFF3EB),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ROITable(
            interest: model.enhancedOfferSection!.interest,
            processingFeeROI: model.enhancedOfferSection!.processingFee,
            strikeThroughProcessingFee: strikeThroughProcessingFee ?? "",
            tenure: enhancedTenure!,
            strikeThroughInterest: computePastInterest(),
            strikeThroughTenure: tenure!,
            valueTextAlignment: TextAlign.right,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  String computePastInterest() {
    if (model.upgradedFeatures!.interest == 1) {
      return model.offerSection!.interest.toString();
    } else {
      return "";
    }
  }
}
