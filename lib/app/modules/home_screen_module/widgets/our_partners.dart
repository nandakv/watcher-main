import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/res.dart';

class OurPartners extends StatelessWidget {
  final logic = Get.find<HomeScreenLogic>();

  OurPartners({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child:  Text(
            "Our Partners",
            style: AppTextStyles.headingXSMedium(color: appBarTitleColor),
          ),
        ),
        verticalSpacer(12),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              logic.partnerIcons.length,
              (index) => Padding(
                padding:  EdgeInsets.only(right: 16.w),
                child: SvgPicture.asset(logic.partnerIcons[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
