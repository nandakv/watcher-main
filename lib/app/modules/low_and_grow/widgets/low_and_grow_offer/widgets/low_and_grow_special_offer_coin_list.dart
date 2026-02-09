import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/res.dart';

import '../../../../../firebase/analytics.dart';
import '../../../../../utils/web_engage_constant.dart';
import 'package:privo/app/theme/app_colors.dart';
import '../../../../faq/faq_page.dart';

class LowAndGrowSpecialOfferCoinList extends StatelessWidget {
  final int? roi;
  final int? limit;
  final int? tenure;
  final int? processingFee;

  const LowAndGrowSpecialOfferCoinList(
      {Key? key, this.roi, this.limit, this.tenure, this.processingFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
            top: 20,
            bottom: 10,
          ),
          child: Text(
            "Added benefits",
            style: _titleTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            roi == 1
                ? specialOfferCoin(
                    title: "Better \n Interest Rates",
                    image: Res.addedBenefitInterestRate,
                  )
                : SvgPicture.asset(Res.fadeCoinRoi),
            limit == 1
                ? specialOfferCoin(
                    title: "Increase \n Credit Limit",
                    image: Res.lowGrowLimit,
                  )
                : SvgPicture.asset(Res.fadeCoinLimit),
            tenure == 1
                ? specialOfferCoin(
                    title: "Improved \n Repayment Tenure",
                    image: Res.lowGrowTenure,
                  )
                : SvgPicture.asset(Res.fadeCoinTenure),
            processingFee == 1
                ? specialOfferCoin(
                    title: "Reduced \n Processing Fee",
                    image: Res.lowGrowProcessingFee,
                  )
                : SvgPicture.asset(Res.fadeCoinPf),
          ],
        ),
        fAQSWidget(),
      ],
    );
  }

  Widget specialOfferCoin({String? image, String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: CircleAvatar(
              backgroundColor: const Color(0xff1161742).withOpacity(1),
              maxRadius: 40,
              child: SvgPicture.asset(image!),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: _titleTextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget fAQSWidget() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.lgFAQClicked);
          AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.lgFAQPageLoaded);
          Get.to(
            () => FAQPage(
              faqModel: FAQUtility().lowAndGrowFAQs,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Frequently Asked Questions',
            style: _fAQSTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  TextStyle _titleTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xff1D478E),
    );
  }

  TextStyle get _fAQSTextStyle {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: "Figtree",
        letterSpacing: 0.15,
        color: skyBlueColor,
        decoration: TextDecoration.underline);
  }
}
