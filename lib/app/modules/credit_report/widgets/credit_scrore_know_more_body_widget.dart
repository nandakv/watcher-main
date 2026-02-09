import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common_widgets/rich_text_widget.dart';
import '../../../common_widgets/spacer_widgets.dart';
import '../../../models/rich_text_model.dart';
import '../../../theme/app_colors.dart';
import '../credit_report_logic.dart';
import '../model/key_benefits_model.dart';

class CreditScoreKnowMoreBodyWidget extends StatelessWidget {
  CreditScoreKnowMoreBodyWidget({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _creditAwarenessWidget(),
        const VerticalSpacer(40),
        _keyBenefitsWidget(),
        const VerticalSpacer(28),
      ],
    );
  }

  Widget _keyBenefitsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Key Benefits ",
          style: _subTitleTextStyle(),
        ),
        const VerticalSpacer(12),
        ..._keyBenefitsList(),
      ],
    );
  }

  List<Widget> _keyBenefitsList() {
    return logic.keyBenefits
        .map((KeyBenefits keyBenefit) => _keyBenefitsTile(keyBenefit))
        .toList();
  }

  Widget _keyBenefitsTile(KeyBenefits keyBenefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(keyBenefit.iconPath),
          const HorizontalSpacer(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyBenefit.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: darkBlueColor,
                    height: 16 / 12,
                  ),
                ),
                const VerticalSpacer(4),
                Text(
                  keyBenefit.description,
                  style: const TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _subTitleTextStyle() {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: navyBlueColor,
      height: 22 / 16,
    );
  }

  Widget _creditAwarenessWidget() {
    return RichTextWidget(
      textAlign: TextAlign.center,
      infoList: [
        RichTextModel(
          text: "Level Up Your Credit Awareness\n",
          textStyle: _subTitleTextStyle(),
        ),
        RichTextModel(
          text:
          "Access your credit score instantly and keep track of your financial health with ease, without any impact on your score",
          textStyle: const TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

}
