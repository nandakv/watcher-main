import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/common_ui_low_and_glow/upgrade_offer.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_logic.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../../../../../res.dart';
import '../../../../common_widgets/ROI_table.dart';
import '../../../../common_widgets/document_button.dart';
import '../../../../firebase/analytics.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../../pdf_document/pdf_document_logic.dart';
import '../low_and_grow_offer/model/low_and_grow_enhanced_offer_model.dart';
import 'low_and_grow_success_logic.dart';

class LowAndGrowSuccessScreen extends StatefulWidget {
  LowAndGrowSuccessScreen({Key? key}) : super(key: key);

  @override
  State<LowAndGrowSuccessScreen> createState() =>
      _LowAndGrowSuccessScreenState();
}

class _LowAndGrowSuccessScreenState extends State<LowAndGrowSuccessScreen>
    with AfterLayoutMixin {
  final logic = Get.find<LowAndGrowSuccessLogic>();

  final lowAndGrowLogic = Get.find<LowAndGrowLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: _computeGradientOnButtonType()),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                _headerTextWidget(),
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(Res.lowGrowSuccessImg),
                const SizedBox(
                  height: 15,
                ),
                const UpgradeOfferWidget(),
                const SizedBox(
                  height: 15,
                ),
                Text(
                    "₹ ${AppFunctions().parseIntoCommaFormat(lowAndGrowLogic.model.enhancedOfferSection!.limitAmount.toString().replaceAll(',', ''))}",
                    style: _titleTextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700)),
                Text(
                    lowAndGrowLogic.model.upgradedFeatures!.limitAmount == 1
                        ? "₹ ${AppFunctions().parseIntoCommaFormat(lowAndGrowLogic.model.offerSection!.limitAmount.toString().replaceAll(',', ''))}"
                        : "",
                    style: _strikeThroughTextStyle()),
                const SizedBox(
                  height: 15,
                ),
                Text("Better credit line for higher financial flexibility",
                    style: _titleTextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: ROITable(
                    interest:
                        lowAndGrowLogic.model.enhancedOfferSection!.interest,
                    tenure: lowAndGrowLogic.computeEnhancedTenureText(),
                    processingFeeROI: lowAndGrowLogic
                        .model.enhancedOfferSection!.processingFee,
                    strikeThroughInterest: computeStrikeThroughInterest(),
                    strikeThroughTenure:
                        lowAndGrowLogic.model.upgradedFeatures!.tenure == 1
                            ? lowAndGrowLogic.computeTenureText()
                            : "",
                    strikeThroughProcessingFee:
                        lowAndGrowLogic.model.upgradedFeatures!.processingFee ==
                                1
                            ? lowAndGrowLogic.model.offerSection!.processingFee
                            : "",
                    valueTextAlignment: TextAlign.right,
                  ),
                ),
                _documentsWidget(),
                const SizedBox(
                  height: 100,
                ),
                TextButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: Text(
                    "Go to Home",
                    style: _textButtonStyle(),
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String computeStrikeThroughInterest() {
    return lowAndGrowLogic.model.upgradedFeatures!.interest == 1
        ? lowAndGrowLogic.model.offerSection!.interest.toString()
        : "";
  }

  Text _headerTextWidget() {
    return Text(
      "Congratulations! \n Upgrade successful",
      // "₹ ${AppFunctions().parseIntoCommaFormat(amount.replaceAll(',', ''))}",
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.11,
        color: skyBlueColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  TextStyle _textButtonStyle() {
    return const TextStyle(
      decoration: TextDecoration.underline,
      letterSpacing: 0.47,
      color: skyBlueColor,
      fontSize: 12,
    );
  }

  List<Color> _darkEnabledGradient() {
    return [
      postRegistrationEnabledGradientColor2,
      postRegistrationEnabledGradientColor1,
    ];
  }

  LinearGradient _computeGradientOnButtonType() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: _darkEnabledGradient(),
    );
  }

  TextStyle _titleTextStyle(
      {required double fontSize, required FontWeight fontWeight}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        color: const Color(0xffFFF3EB),
        fontFamily: "Figtree");
  }

  TextStyle _strikeThroughTextStyle() {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: .16,
        fontWeight: FontWeight.w400,
        color: Color(0xffFFF3EB),
        decoration: TextDecoration.lineThrough);
  }

  _documentsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      child: DocumentButton(
        title: "Download agreement letter",
        borderColor: const Color(0xffFFF3EB),
        onPressed: () {
          logic.fetchLetter(
            DocumentType.agreementLetterDownload,
            "agreement_letter_download",
          );
        },
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppFunctions()
        .showInAppReview("${WebEngageConstants.playStorePrompted} LG");
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.lgSuccessScreenLoaded);
  }
}
