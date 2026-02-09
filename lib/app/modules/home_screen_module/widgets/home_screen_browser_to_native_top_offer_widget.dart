import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common_widgets/ROI_table.dart';

class HomeScreenBrowserToNativeTopOfferWidget extends StatelessWidget {
  const HomeScreenBrowserToNativeTopOfferWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.roi,
    this.minTenure = "",
    this.maxTenure = "",
    this.ctaButton,
    this.processingFee = "",
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String amount;
  final String roi;
  final String minTenure;
  final String maxTenure;
  final String processingFee;
  final Widget? ctaButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _verticalSpacer(15),
            _topTitleWidget(),
            _verticalSpacer(24),
            _eligibleText(),
            _verticalSpacer(24),
            _creditLineAmountText(),
            _amountTextWidget(),
            _verticalSpacer(20),
            _loanTableWidget(),
            _verticalSpacer(32),
            _computeCTAButtonWidget(),
          ],
        ),
      ),
    );
  }

  Widget _loanTableWidget() {
    if (minTenure.isEmpty || maxTenure.isEmpty || processingFee.isEmpty) {
      return _roiTextWidget();
    } else {
      return ROITable(
        processingFeeROI: processingFee,
        interest: double.parse(roi),
        tenure: _computeTenureMonths(),
      );
    }
  }

  String _computeTenureMonths() {
    return "$minTenure-$maxTenure months";
  }

  Widget _computeCTAButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0, left: 30, right: 30),
      child: ctaButton ?? const SizedBox(),
    );
  }

  SizedBox _verticalSpacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  Text _amountTextWidget() {
    return Text(
      amount,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 40,
        height: 1.56,
      ),
    );
  }

  Widget _roiTextWidget() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0xff1B3B7B)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: _roiText(),
    );
  }

  Text _roiText() {
    return Text(
      "At $roi% Rate Of Interest",
      style: const TextStyle(
        color: Colors.white,
        fontFamily: "Figtree",
        fontSize: 12,
      ),
    );
  }

  Text _creditLineAmountText() {
    return const Text(
      "CREDIT LINE AMOUNT",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Figtree",
        fontSize: 10,
      ),
    );
  }

  Widget _eligibleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "Figtree",
          fontSize: 12,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _topTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xff5BC4F0),
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 1.3,
        ),
      ),
    );
  }
}
