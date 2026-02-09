import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/components/skeletons/skeletons.dart';
import 'package:privo/res.dart';

import '../../../../../firebase/analytics.dart';

class TenureEmiCard extends StatefulWidget {
  const TenureEmiCard(
      {Key? key, required this.tenure, required this.tenureType})
      : super(key: key);

  final int tenure;
  final TenureType tenureType;

  @override
  State<TenureEmiCard> createState() => _TenureEmiCardState();
}

class _TenureEmiCardState extends State<TenureEmiCard> with AfterLayoutMixin {
  final logic = Get.find<WithdrawalLogic>();

  WithdrawalCalculationModel? withdrawalCalculationModel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalLogic>(builder: (logic) {
      if (withdrawalCalculationModel != null) {
        return InkWell(
            onTap: () {
              AppAnalytics.trackWebEngageEventWithAttribute(
                  eventName:
                      logic.computeTenureTypeEventName(widget.tenureType));
              logic.onTenureEmiCardTapped(
                widget.tenureType,
              );
            },
            child: _onWithdrawalCalculationNotNull(logic));
      }
      return const SkeletonItem(
        child: SizedBox(
          height: 40,
        ),
      );
    });
  }

  Widget _onWithdrawalCalculationNotNull(WithdrawalLogic logic) {
    switch (widget.tenureType) {
      case TenureType.defaultTenure:
      case TenureType.customTenure:
        return _emiCardWidget(logic);
      case TenureType.recommendedTenure:
        return recommendedTenure(logic);
    }
  }

  SizedBox recommendedTenure(WithdrawalLogic logic) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          _emiCardWidget(logic),
          _recommendedBanner(),
        ],
      ),
    );
  }

  Widget _recommendedBanner() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IntrinsicHeight(
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFAF8E2F),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.singleSpark),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  "RECOMMENDED",
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Figtree',
                      color: Color(0xFFFFF3EB),
                      fontSize: 8,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emiCardWidget(WithdrawalLogic logic) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: logic.selectedTenureType == widget.tenureType
            ? const Color(0xFF161742)
            : Colors.transparent,
        border: Border.all(color: const Color(0xFF161742), width: 0.6),
      ),
      height: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.tenureType == TenureType.customTenure) ...[
            SvgPicture.asset(
              Res.sparkleIcon,
            ),
            FittedBox(
              child: Text(
                "Customise",
                maxLines: 1,
                style: GoogleFonts.poppins(
                    color: _computeTextColor(logic),
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
          !(widget.tenureType == TenureType.customTenure)
              ? Text(
                  "${logic.rupeeSymbol}${_fetchEmiAmount(logic)}",
                  style: GoogleFonts.poppins(
                      color: _computeTextColor(logic),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              : const SizedBox(
                  height: 0,
                ),
          Text(
            !(widget.tenureType == TenureType.customTenure)
                ? "${widget.tenure} months"
                : "EMI tenure",
            style: TextStyle(
                fontSize: 10,
                color: _computeTextColor(logic),
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Color _computeTextColor(WithdrawalLogic logic) {
    return logic.selectedTenureType == widget.tenureType
        ? Colors.white
        : const Color(0xFF161742);
  }

  _fetchEmiAmount(WithdrawalLogic logic) {
    if (withdrawalCalculationModel != null &&
        withdrawalCalculationModel!.emiAmount != null) {
      return AppFunctions().parseIntoCommaFormat(
          withdrawalCalculationModel!.emiAmount.toString());
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    withdrawalCalculationModel = await logic.getWithdrawalCacheFromKey(
        key: "${logic.loanAmountSliderValue.toInt()},${widget.tenure}");
    logic.update();
  }
}
