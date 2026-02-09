import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';

class OurLegacy extends StatelessWidget {
  final logic = Get.find<HomeScreenLogic>();

  OurLegacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Legacy",
            style: AppTextStyles.headingXSMedium(color: appBarTitleColor),
          ),
          verticalSpacer(14),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              logic.legacyData.length,
              (index) => Container(
                width: 98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFeff9fe),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        logic.legacyData[index].title,
                        style: GoogleFonts.poppins(
                          color: darkBlueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          // height: 19.6 / 14,
                        ),
                      ),
                      Text(
                        logic.legacyData[index].value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: darkBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          // height: 14 / 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _gradientBorderDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(colors: [
          Color(0xFF8FD1EC),
          Color(0xFF229ACE),
        ]),
        border: Border.all(
          color: const Color(0xFF8FD1EC),
          width: 0.3,
        ));
  }
}
