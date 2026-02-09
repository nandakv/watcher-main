import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';

class HomeCardTexts {
  List<RichTextModel> fetchLPCTitle(String title) {
    return [
      RichTextModel(
        text: title,
        textStyle: GoogleFonts.poppins(
            color: darkBlueColor, fontSize: 14, fontWeight: FontWeight.w600),
      )
    ];
  }

  late final List<RichTextModel> preOfferSblbodyInfoList = [
    RichTextModel(
      text: "• ",
      textStyle: AppTextStyles.bodyXSMedium(color: grey700),
    ),
    RichTextModel(
      text: "Loans upto ",
      textStyle: AppTextStyles.bodyXSMedium(color: grey700),
    ),
    RichTextModel(
      text: "₹15 lakh\n",
      textStyle: AppTextStyles.bodyXSSemiBold(color: grey900),
    ),
    RichTextModel(
      text: "• ",
      textStyle: AppTextStyles.bodyXSMedium(color: grey700),
    ),
    RichTextModel(
      text: "Interest rates starting at ",
      textStyle: AppTextStyles.bodyXSMedium(color: grey700),
    ),
    RichTextModel(
      text: "19% p.a\n\n",
      textStyle: AppTextStyles.bodyXSSemiBold(color: grey900),
    ),
    RichTextModel(
      text: " Know more\n",
      onTap: onKnowMoreTapped,
      // onHyperlinkClicked: onKnowMoreTapped,
      textStyle: AppTextStyles.bodyXSSemiBold(color: blue600),
    )
  ];

  onKnowMoreTapped() {
    Get.log("Tapped");
    var logic = Get.find<PrimaryHomeScreenCardLogic>();
    logic.goToKnowMore(KnowMoreGetStartedState.knowMore, LoanProductCode.sbd);
  }

  late final List<RichTextModel> workDetailsTitleList = [
    RichTextModel(
      text: "Complete your ",
      textStyle: homePageCardTitleTextStyle,
    ),
    RichTextModel(
      text: "work details",
      textStyle: homePageCardHighlightedTitleTextStyle,
    ),
    RichTextModel(
      text: "\nto get the best offer",
      textStyle: homePageCardTitleTextStyle,
    )
  ];
  late final List<RichTextModel> aaTitleList = [
    RichTextModel(
      text: "Complete your ",
      textStyle: homePageCardTitleTextStyle,
    ),
    RichTextModel(
      text: "application",
      textStyle: homePageCardHighlightedTitleTextStyle,
    ),
    RichTextModel(
      text: "\nto get the best offers",
      textStyle: homePageCardTitleTextStyle,
    )
  ];

  late final List<RichTextModel> lineAgreementTitleList = [
    RichTextModel(
      text: "Accept the ",
      textStyle: homePageCardTitleTextStyle,
    ),
    RichTextModel(
      text: "Line Agreement ",
      textStyle: homePageCardHighlightedTitleTextStyle,
    ),
    RichTextModel(
      text: "\nto activate your Credit Line",
      textStyle: homePageCardTitleTextStyle,
    ),
  ];

  late final List<RichTextModel> eligibilityOfferTitleList = [
    RichTextModel(
      text: "You're eligible for our Credit \nLine",
      textStyle: homePageCardTitleTextStyle,
    ),
  ];
  late final List<RichTextModel> partnerPreOfferTitleList = [
    RichTextModel(
      text: "Well done",
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: goldColor,
      ),
    ),
    RichTextModel(
      text: "\nYour pre-approved Credit Line\noffer awaits ",
      textStyle: homePageCardTitleTextStyle,
    ),
  ];

  List<RichTextModel> partnerPreOfferBodyTextValues(
      {required String limitAmount}) {
    return [
      RichTextModel(
        text: "₹$limitAmount",
        textStyle: const TextStyle(
          color: offWhiteColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  List<RichTextModel> totalLimitPieChartTextValues({required String amount}) {
    return [
      RichTextModel(
        text: "Total Limit\n",
        textStyle:  TextStyle(
          color: navyBlueColor,
          fontSize: 8.sp,
          height: 11.2.sp/8.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      RichTextModel(
        text: "₹$amount",
        textStyle: AppTextStyles.bodySSemiBold(
          color: blue1600
        )
        // textStyle: const TextStyle(
        //   color: navyBlueColor,
        //   fontSize: 12,
        //   height: 1.5,
        //   fontWeight: FontWeight.w600,
        // ),
      ),
    ];
  }

  List<RichTextModel> uplPieChartTextValues(
      {required String emiPaid, required totalEmi}) {
    return [
      RichTextModel(
        text: "EMI’s Paid\n",
        textStyle: const TextStyle(
          color: navyBlueColor,
          fontSize: 8,
          fontWeight: FontWeight.w400,
          height: 1.1,
        ),
      ),
      RichTextModel(
        text: emiPaid,
        textStyle: const TextStyle(
            color: navyBlueColor, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      RichTextModel(
        text: "/$totalEmi",
        textStyle: const TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ];
  }

  List<RichTextModel> offerDetailsBodyTextValues(
      {required String limitAmount,
      String infoText = "",
      required String offerText,
      String? oldLimitAmout,
      String? oldOfferText}) {
    return [
      RichTextModel(
        text: "$infoText\n",
        textStyle: AppTextStyles.bodySRegular(color: grey700),
      ),
      RichTextModel(
        text: "₹",
        textStyle:  TextStyle(
          color: secondaryDarkColor,
          fontFamily: 'Figtree',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      RichTextModel(
        text: "$limitAmount  ",
        textStyle: AppTextStyles.headingMSemiBold(
          color: secondaryDarkColor,
        ),
      ),
      if (oldLimitAmout != null) ...[
        RichTextModel(
          text: "₹",
          textStyle: TextStyle(
            color: secondaryDarkColor.withOpacity(0.6),
            fontSize: 12,
            fontFamily: 'Figtree',
            decoration: TextDecoration.lineThrough,
          ),
        ),
        RichTextModel(
          text: oldLimitAmout,
          textStyle: GoogleFonts.poppins(
            color: secondaryDarkColor.withOpacity(0.6),
            fontSize: 12,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
      RichTextModel(
        text: "\n$offerText",
        textStyle: const TextStyle(
          color: secondaryDarkColor,
          fontSize: 12,
          height: 1.4,
          fontWeight: FontWeight.w500
        ),
      ),
      if (oldOfferText != null)
        RichTextModel(
          text: "\n$oldOfferText",
          textStyle: TextStyle(
            color: secondaryDarkColor.withOpacity(0.6),
            fontSize: 10,
            height: 1.4,
            decoration: TextDecoration.lineThrough,
          ),
        ),
    ];
  }

  late final List<RichTextModel> creditLineExpiredTitleList = [
    RichTextModel(
      text: "Your personalised Credit Line\nhas expired!",
      textStyle: GoogleFonts.poppins(
        fontSize: 10,
        color: lightRedColor,
      ),
    ),
  ];
  late final List<RichTextModel> offerExpiredTitleList = [
    RichTextModel(
      text: "Your personalised offer\nhas expired!",
      textStyle: GoogleFonts.poppins(
        fontSize: 10,
        color: lightRedColor,
      ),
    ),
  ];

  List<RichTextModel> rejectedBodyList(
      {required String title, required String message}) {
    return [
      RichTextModel(
        text:
            "${title.isEmpty ? "Your application has been declined" : title}\n",
        textStyle: GoogleFonts.poppins(
            fontSize: 10, color: lightRedColor, height: 1.4),
      ),
      RichTextModel(
        text: "\n",
        textStyle: GoogleFonts.poppins(
            fontSize: 10, color: lightRedColor, height: 0.6),
      ),
      RichTextModel(
        text: message.isEmpty
            ? "It doesn't meet one or more of our\neligibility criteria"
            : message,
        textStyle: GoogleFonts.poppins(
          fontSize: 10,
          height: 1.4,
          color: offWhiteColor,
        ),
      ),
    ];
  }

  late final List<RichTextModel> apiErrorBodyList = [
    RichTextModel(
      text: "Encountering a glitch while loading\ndetails. Refresh to retry.",
      textStyle:
          const TextStyle(fontSize: 12, color: offWhiteColor, height: 1.6),
    ),
  ];

  List<RichTextModel> uplApplicationReviewTitleList(String title) => [
        RichTextModel(
          text: title,
          textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: darkBlueColor,
              height: 1.6),
        ),
      ];

  List<RichTextModel> uplApplicationReviewBodyList(message) => [
        RichTextModel(
          text: message,
          textStyle: const TextStyle(
              fontSize: 10, color: secondaryDarkColor, height: 1.4),
        ),
      ];
}
