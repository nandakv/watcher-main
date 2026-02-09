import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/modules/emi_calculator/widgets/info_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class LpcGridScreen extends StatelessWidget {
  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoWidget(),
          verticalSpacer(30),
          Text(
            "Choose Loan Type",
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          verticalSpacer(10),
          _lpcGrid(),
          verticalSpacer(10),
          _poweredByCs(),
          verticalSpacer(10),
        ],
      ),
    );
  }

  Widget _lpcGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      padding: EdgeInsets.zero,
      mainAxisSpacing: 3,
      crossAxisSpacing: 30,
      children: List.generate(logic.lpcList.length, (index) {
        return InkWell(
          onTap: (){
            logic.onLpcCardTapped(logic.lpcList[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              decoration: _gradientBorderDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: SvgPicture.asset(
                    logic.lpcList[index].icon,
                    fit: BoxFit.scaleDown,
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      logic.lpcList[index].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: navyBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
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

  BoxDecoration _gradientBorderDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        gradient: const LinearGradient(colors: [
          Color(0xFF8FD1EC),
          Color(0xFF229ACE),
        ]),
        border: Border.all(
          color: Color(0xFF8FD1EC),
          width: 1,
        ));
  }
}
