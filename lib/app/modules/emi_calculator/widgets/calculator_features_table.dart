import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class CalculatorFeaturesTable extends StatelessWidget {
  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: _gradientBorderDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(logic.emiCalculatorFeatures.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        logic.emiCalculatorFeatures[index].icon,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        logic.emiCalculatorFeatures[index].title,
                        style: const TextStyle(
                            color: primaryDarkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                logic.emiCalculatorFeatures.length - 1 == index
                    ? SizedBox()
                    : const Divider(
                        color: Color(0xFF8FD1EC),
                        height: 1.0,
                      )
              ],
            );
          }),
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
