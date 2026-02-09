import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/modules/fin_sights/widgets/new_intro/finsights_intro_model.dart';

import '../../../../../components/button.dart';
import '../../../../../res.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../components/top_navigation_bar.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../non_eligible_finsights/non_eligible_finsights_carousal_model.dart';
import '../social_proof_card.dart';

class NewIntroScreen extends StatelessWidget {
  NewIntroScreen({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              TopNavigationBar(
                title: "FinSights",
                onBackPressed: () => Get.back(),
                enableShadow: true,
              ),
              _buildHeaderSection(),
              VerticalSpacer(32.h),
              _buildContent(),
              VerticalSpacer(19.h),
              const SocialProofCard(
                imageAssetPath: Res.finsightsIntroSocialProofPNG,
                text:
                    "Users are already experiencing the \nupgraded dashboard — now it’s your turn!",
                bgColor: primaryLightColor,
              ),
              VerticalSpacer(19.h),
              Button(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.large,
                enabled: true,
                onPressed: () {
                  logic.onTapGetStarted();
                },
                title: "See insights",
                isLoading: false,
              ),
              VerticalSpacer(12.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What’s new for you:",
            style: AppTextStyles.headingSSemiBold(color: darkBlueColor),
          ),
          VerticalSpacer(16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logic.newIntroList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                // Add some padding
                child: newIntroUpdatesWidget(
                  model: logic.newIntroList[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          VerticalSpacer(32.h),
          Text(
            "We’ve upgraded your dashboard!",
            style: AppTextStyles.headingMSemiBold(color: AppTextColors.primaryNavyBlueHeader),
            textAlign: TextAlign.center,
          ),
          // VerticalSpacer(50.h),
          Center(child: SvgPicture.asset(Res.ignosisBg)),
        ],
      ),
    );
  }

  Widget newIntroUpdatesWidget({required FinSightsIntroModel model}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: preRegistrationEnabledGradientColor2.withOpacity(0.10),
            borderRadius: BorderRadius.circular(28),
          ),
          child: SvgPicture.asset(
            model.img,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          model.title,
          style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
        ),
      ],
    );
  }
}
