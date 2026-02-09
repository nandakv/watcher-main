import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/modules/fin_sights/widgets/mask_data_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/res.dart';

class FinsightsAccountOverviewWidget extends StatelessWidget {
  FinsightsAccountOverviewWidget({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.default_bank),
                const HorizontalSpacer(8),
                const Text('Account Overview').headingSMedium(
                  color: navyBlueColor,
                ),
                const HorizontalSpacer(4),
                Text(logic.accountOverviewMonths)
                    .bodyXSRegular(color: secondaryDarkColor),
              ],
            ),
          ),
          const VerticalSpacer(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HorizontalSpacer(24),
                _avgWidget(
                  icon: Res.finsightsAvgBalanceIconSvg,
                  title: "Avg. Balance",
                  value: logic.finSightsViewModel.avgBalance?.removeAllWhitespace??"0.0",
                ),
                const HorizontalSpacer(16),
                _avgWidget(
                  icon: Res.finsightsAvgCreditIconSvg,
                  title: "Avg. Credit",
                  value: logic.finSightsViewModel.avgCredit?.removeAllWhitespace??"0.0",
                ),
                const HorizontalSpacer(16),
                _avgWidget(
                  icon: Res.finsightsAvgDebitIconSvg,
                  title: "Avg. Debit",
                  value: logic.finSightsViewModel.avgDebit?.removeAllWhitespace??"0.0",
                ),
                const HorizontalSpacer(24),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _avgWidget({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                const HorizontalSpacer(4),
                Text(title).bodyXSRegular(color: secondaryDarkColor),
              ],
            ),
            const VerticalSpacer(9),
            MaskDataWidget(
              text: value,
              styleBuilder: (text) => Text(text).bodyLSemiBold(
                color: primaryDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
