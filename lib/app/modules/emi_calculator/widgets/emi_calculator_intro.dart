import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/modules/emi_calculator/widgets/calculator_features_table.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class EmiCalculatorIntro extends StatelessWidget {
  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _topWidget(),
          _whatsNewBanner(),
          Flexible(
            child: Text(
              "Plan smarter with our EMI Calculator!",
              style: GoogleFonts.poppins(
                  color: navyBlueColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Simply enter the loan amount, tenure, and interest rate to see how your repayment plan will look.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Flexible(
            child: Text(
              "Why do you need our EMI Calculator?",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: primaryDarkColor),
            ),
          ),
          verticalSpacer(12),
          CalculatorFeaturesTable(),
          verticalSpacer(52),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GradientButton(
              onPressed: logic.onCalculatorIntroContinuePressed,
            ),
          ),
          _poweredByCs(),
        ],
      ),
    );
  }


  Container _topWidget() {
    return Container(
        width: double.infinity,
        decoration: _imageGradientDecoration(),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      Res.close_x_mark_svg,
                      color: navyBlueColor,
                    )),
              ),
            ),
            SvgPicture.asset(Res.autoPaySuccessSVG),
          ],
        ));
  }

  Widget _poweredByCs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: SvgPicture.asset(
          Res.poweredByCS,
          height: 20,
          colorFilter: const ColorFilter.mode(
            navyBlueColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _whatsNewBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        decoration: BoxDecoration(
            color: goldColor, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Res.sparkleIcon,
              color: Color(0xFFFFD325),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "What’s New!",
              maxLines: 1,
              style: GoogleFonts.poppins(
                  color: offWhiteColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _imageGradientDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFFFF3EB), Color(0xFFFFFFFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight));
  }
}
