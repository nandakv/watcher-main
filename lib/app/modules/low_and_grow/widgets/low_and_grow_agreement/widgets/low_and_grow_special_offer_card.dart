import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_ui_low_and_glow/upgrade_offer.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../utils/app_functions.dart';
import '../../../low_and_grow_logic.dart';
import '../../low_and_grow_offer/model/special_offer_model.dart';

class SpecialOfferCard extends StatelessWidget {
  final SpecialOffer? specialOffer;
  final LoanProductCode loanProductCode;

  const SpecialOfferCard({
    Key? key,
    this.specialOffer,
    this.loanProductCode = LoanProductCode.clp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      decoration: BoxDecoration(
          gradient: _computeGradientOnButtonType(),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (specialOffer!.upgradedLimitAmount == 1 ||
              specialOffer!.upgradedInterest == 1 ||
              specialOffer!.upgradedTenure == 1 ||
              specialOffer!.upgradedPF == 1)
            const SizedBox(
              height: 10,
              child: FittedBox(
                alignment: Alignment.topRight,
                child: UpgradeOfferWidget(),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    offerTitleAndValue(
                        computeTitleText(), _getTotalLimitValue()),
                    const SizedBox(
                      height: 20,
                    ),
                    offerTitleAndValue(
                      "Processing fee",
                      _computeProcessingFee(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    offerTitleAndValue("Rate of interest",
                        "${specialOffer!.enhancedInterest}%"),
                    const SizedBox(
                      height: 20,
                    ),
                    offerTitleAndValue("Tenure", specialOffer!.enhancedTenure!),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _computeProcessingFee() {
    if (loanProductCode == LoanProductCode.clp) {
      return _computeClpProcessingFee();
    } else {
      return "₹ ${specialOffer!.enhancedProcessingFee}";
    }
  }

  _computeClpProcessingFee() {
    if (specialOffer!.enhancedProcessingFee == "0") {
      return "${specialOffer!.enhancedProcessingFee}%";
    } else {
      return "Upto ${specialOffer!.enhancedProcessingFee}%";
    }
  }

  String _getTotalLimitValue() {
    return AppFunctions.getIOFOAmount(specialOffer!.enhancedLimitAmount!);
  }

  String computeTitleText() {
    switch (loanProductCode) {
      case LoanProductCode.unknown:
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
        return "Loan Amount";
      case LoanProductCode.clp:
        return "Total Limit";
      default:
        return '';
    }
  }

  Widget offerTitleAndValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: _titleTextStyle(),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          value,
          style: _subTitleTextStyle,
        )
      ],
    );
  }

  TextStyle _titleTextStyle({double fontSize = 10}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
        color: Color(0xFFFFF3EB));
  }

  TextStyle get _subTitleTextStyle {
    return const TextStyle(
        fontSize: 14,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Figtree',
        color: Color(0xFFFFF3EB));
  }

  List<Color> _darkEnabledGradient() {
    return [
      postRegistrationEnabledGradientColor2,
      postRegistrationEnabledGradientColor1,
    ];
  }

  LinearGradient _computeGradientOnButtonType() {
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: _darkEnabledGradient(),
    );
  }
}
