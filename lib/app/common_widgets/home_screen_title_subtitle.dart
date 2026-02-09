import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/golden_badge.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../modules/on_boarding/mixins/app_form_mixin.dart';
import '../utils/app_functions.dart';
import '../utils/ui_constant_text.dart';

class HomeScreenTitleSubTitle extends StatelessWidget {
  const HomeScreenTitleSubTitle(
      {Key? key,
      this.amount = 0,
      this.oldAmount = 0,
      this.isLpcStatus = LoanProductCode.clp,
      this.isOfferUpgraded = false,
      this.isOnboardingOfferScreen = false,
      this.isPartnerAPI = false})
      : super(key: key);
  final double amount;
  final double oldAmount;
  final LoanProductCode isLpcStatus;
  final bool isPartnerAPI;
  final bool isOfferUpgraded;
  final bool isOnboardingOfferScreen;

  String _computeSubTitle() {
    if (isPartnerAPI) {
      return "You have an in-principle\ncredit line of";
    } else if (isLpcStatus != LoanProductCode.clp) {
      return "You are approved for a loan \n amount of";
    } else {
      if (isOnboardingOfferScreen) {
        return finalOfferSubTitle.replaceAll("\n", " ");
      }
      return finalOfferSubTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            "Congratulations!",
            style: titleTextStyle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: Text(
            _computeSubTitle(),
            textAlign: TextAlign.center,
            style: _subTitleTextStyle(),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (!isOnboardingOfferScreen && isOfferUpgraded) ...[
          const GoldenBadge(title: "UPGRADED"),
          const SizedBox(
            height: 5,
          ),
        ],
        Flexible(
          child: Text(
            AppFunctions.getIOFOAmount(amount),
            style: amountTextStyle(fontSize: 32),
          ),
        ),
        if (oldAmount != 0) ...[
          Flexible(
            child: Text(
              AppFunctions.getIOFOAmount(oldAmount),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: offWhiteColor,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ],
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12, color: Color(0xffFFF3EB), fontWeight: FontWeight.normal);
  }

  TextStyle get titleTextStyle {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.58,
      color: skyBlueColor,
    );
  }

  TextStyle amountTextStyle({required double fontSize}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: FontWeight.bold,
      color: const Color(0xffFFF3EB),
    );
  }
}
