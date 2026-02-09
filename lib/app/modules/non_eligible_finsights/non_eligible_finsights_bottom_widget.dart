import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/non_eligible_finsights/work_type_specific_questions.dart';
import '../../../components/button.dart';
import '../../../res.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../data/provider/auth_provider.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'non_eligible_finsights_logic.dart';

class NonEligibleFinSightsBottomWidget extends StatelessWidget {
  NonEligibleFinSightsBottomWidget({super.key});

  final logic = Get.find<NonEligibleFinsightLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 40.h),
      child: Column(
        children: [
          Text(
            'Help us refine your experience',
            style: AppTextStyles.headingSMedium(color: darkBlueColor),
          ),
          VerticalSpacer(8.h),
          Text(
            'Select the right options for personalised financial recommendations',
            style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
            textAlign: TextAlign.center,
          ),
          if (logic.variantName == NonEligibleFinSightsType.lightVariant)
            VerticalSpacer(32.h),
          WorkTypeSpecificQuestions(),
          VerticalSpacer(16.h),
          Row(
            children: [
              SvgPicture.asset(Res.security),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "This data won’t be used for promotions or shared with anyone else",
                  style: AppTextStyles.bodySRegular(color: darkBlueColor),
                ),
              ),
            ],
          ),
          VerticalSpacer(65.h),
          GetBuilder<NonEligibleFinsightLogic>(
              id: logic.JOIN_NOW_BUTTON,
              builder: (logic) {
                return Button(
                  isLoading: logic.isLoading,
                  buttonType: ButtonType.primary,
                  buttonSize: ButtonSize.large,
                  title: "Join now",
                  onPressed: () {
                    logic.onTapJoinNow();
                  },
                  fillWidth: true,
                  enabled: logic.isFormComplete,
                );
              }),
        ],
      ),
    );
  }


}
