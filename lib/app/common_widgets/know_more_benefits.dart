import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class KnowMoreBenefits extends StatelessWidget {
  KnowMoreBenefits({super.key,required this.smartBenefits});

  List<SmartBenefitsModel> smartBenefits;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Smart benefits for you",
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w500, color: navyBlueColor),
        ),
        const VerticalSpacer(4),
        ...List.generate(
          smartBenefits.length,
          (index) => _benefitTile(index),
        )
      ],
    );
  }

  Padding _benefitTile(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(smartBenefits[index].icon),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smartBenefits[index].title,
                  style: _titleTextStyle(),
                ),
                const VerticalSpacer(4),
                Text(
                  smartBenefits[index].subTitle,
                  style: subTitleTextStyle(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextStyle subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: secondaryDarkColor);
  }

  TextStyle _titleTextStyle() {
    return GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w600, color: darkBlueColor);
  }
}

class SmartBenefitsModel {
  String title;
  String icon;
  String subTitle;

  SmartBenefitsModel(
      {required this.title, required this.icon, required this.subTitle});
}
