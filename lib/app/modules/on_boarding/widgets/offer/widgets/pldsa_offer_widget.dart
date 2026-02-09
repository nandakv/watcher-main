import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/check_box_tile_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/net_disbursal_widget.dart';
import 'package:privo/app/utils/app_functions.dart';
import '../../../../../../res.dart';
import '../../../../../theme/app_colors.dart';
import '../offer_logic.dart';
import 'offer_table_item_widget.dart';

class PLDSAOfferWidget extends StatefulWidget {
  PLDSAOfferWidget({Key? key}) : super(key: key);

  @override
  State<PLDSAOfferWidget> createState() => _PLDSAOfferWidgetState();
}

class _PLDSAOfferWidgetState extends State<PLDSAOfferWidget>
    with AfterLayoutMixin {
  final logic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(Res.close_x_mark_svg),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _loanDetailsWidget(),
          ),
        ),
      ],
    );
  }

  Widget _loanDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Congratulations,\n${logic.firstName}!',
          style: titleTextStyle(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Your Personalised Offer Awaits",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: darkBlueColor,
          ),
        ),
        Text.rich(
          TextSpan(
            text: "₹",
            children: [
              TextSpan(
                text: logic.fetchLoanAmount(),
                style: titleTextStyle(
                  fontSize: 40,
                ),
              ),
            ],
          ),
          style: titleTextStyle(
            fontSize: 40,
            isFigtree: true,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        SvgPicture.asset(Res.sbdOfferGiftsSvg),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderSkyBlueColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logic.responseModel.loanBreakDownData.length,
              itemBuilder: (BuildContext context, int index) {
                return OfferTableItemWidget(
                    offerTableModel:
                        logic.responseModel.loanBreakDownData[index]);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        if (logic.responseModel.insuranceDetails != null)
          CheckBoxTileWidget(
            offerServiceType: OfferServiceType.insurance,
          ),
        if (logic.responseModel.vasDetailsList != null) ...[
          CheckBoxTileWidget(
            offerServiceType: OfferServiceType.healthcare,
          ),
        ],
        const SizedBox(
          height: 6,
        ),
        NetDisbursalWidget(),
        const SizedBox(
          height: 15,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            textAlign: TextAlign.start,
            "*Processing fee, document charges and insurance is inclusive of GST",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: navyBlueColor,
            ),
          ),
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }

  TextStyle amountTextStyle({required double fontSize}) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      letterSpacing: 0.18,
      color: const Color(0xff344157),
    );
  }

  TextStyle titleTextStyle({double? fontSize, bool isFigtree = false}) {
    return isFigtree
        ? TextStyle(
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          )
        : GoogleFonts.poppins(
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          );
  }

  TextStyle briTextStyle({FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        color: const Color(0xff161742),
        fontSize: 11,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  TextStyle get knowMoreTextStyle {
    return const TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        color: skyBlueColor,
        fontFamily: 'Figtree',
        decoration: TextDecoration.underline);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onPldsaOfferLoaded();
  }
}
