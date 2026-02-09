import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/tenure_emi_card.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/tenure_slider.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/web_engage_constant.dart';

class TenureSelector extends StatelessWidget {
  TenureSelector({Key? key}) : super(key: key);
  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!logic.isPaymentDetailsLoading) ...[
          Text(
            "Choose EMI Tenure",
            style: GoogleFonts.poppins(
                color: const Color(0xFF161742),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 12,
          ),
          _tenureEmiCard(),
          const SizedBox(
            height: 12,
          )
        ],
        if (logic.showTenureSlider && !logic.isPaymentDetailsLoading) ...[
          TenureSlider(),
          const SizedBox(
            height: 10,
          ),
        ]
      ],
    );
  }

  _tenureEmiCard() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TenureEmiCard(
              tenure: logic.defaultTenure,
              tenureType: TenureType.defaultTenure,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Visibility(
              visible: logic.tenureRange.length > 1,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TenureEmiCard(
                tenureType: TenureType.recommendedTenure,
                tenure: logic.recomendedTenure),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Visibility(
              visible: _getTenureRangeVisibility(),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TenureEmiCard(
                tenureType: TenureType.customTenure,
                tenure: logic.recomendedTenure,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _getTenureRangeVisibility() {
    Get.log("${logic.tenureRange.length}");
    return logic.tenureRange.length > 2;
  }
}
