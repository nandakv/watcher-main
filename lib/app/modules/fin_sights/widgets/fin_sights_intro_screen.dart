import 'package:carousel_slider/carousel_slider.dart' as carouselSlider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/page_indicator.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/modules/fin_sights/widgets/social_proof_card.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/corner_radius.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

import '../../../../components/button.dart';
import '../../../theme/app_colors.dart';
import 'finsights_intro_screen_model.dart';

class FinSightsIntroScreen extends StatelessWidget {
  FinSightsIntroScreen({super.key});

  final logic = Get.find<FinSightsLogic>();

  final pageController = carouselSlider.CarouselSliderController();

  final introPageList = [
    FinSightsIntroScreenModel(
      title: "One view of your money",
      subTitle:
          "Link your bank account and get an\noverall view of your finances",
      image: Res.finsightsIntroOnePNG,
    ),
    FinSightsIntroScreenModel(
      title: "Summary of your transactions",
      subTitle: "Know your money better, see what\ncomes in and what goes out",
      image: Res.finsightsIntroTwoPNG,
    ),
    FinSightsIntroScreenModel(
      title: "Breakdown of your expenses",
      subTitle: "Monitor your spending and\nexpenses over time",
      image: Res.finsightsIntroThreePNG,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (!didPop) {
          await logic.onFinSightsIntroScreenPopped();
        }
      },
      child: SafeArea(
        child: Container(
          color: AppBackgroundColors.primarySubtle,
          child: Column(
            children: [
              TopNavigationBar(
                title: 'FinSights',
                onBackPressed: () => logic.finSightsBackClicked(
                    "Finsights Intro Screen",
                    addFriction: true),
                enableShadow: false,
              ),
              VerticalSpacer(24.h),
              _pageView(),
              VerticalSpacer(24.h),
              GetBuilder<FinSightsLogic>(
                id: logic.INTRO_SCREEN_ID,
                builder: (logic) {
                  return PageIndicator(currentIndex: logic.introScreenIndex);
                },
              ),
              // _infoContainer(),
              const Spacer(),
              VerticalSpacer(5.h),
              const SocialProofCard(
                imageAssetPath: Res.finsightsIntroSocialProofPNG,
                text:
                    "Users have gained insights to take control\nof their finances — now it’s your turn!",
              ),
              VerticalSpacer(40.h),
              GetBuilder<FinSightsLogic>(
                id: logic.GET_STARTED_CTA_ID,
                builder: (logic) {
                  return Button(
                    buttonType: ButtonType.primary,
                    buttonSize: ButtonSize.large,
                    title: logic.computeIntroScreenCTAText(),
                    isLoading: logic.getStartedCTALoading,
                    onPressed: logic.onTapGetStarted,
                  );
                },
              ),
              VerticalSpacer(24.h),
            ],
          ),
        ),
      ),
    );
  }

  Container _infoContainer() {
    return Container(
      width: 312.w,
      decoration: BoxDecoration(
        color: blue200,
        borderRadius: CornerRadius.small(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Res.blueBulbSVG,
              width: 22.w,
              height: 22.w,
            ),
            HorizontalSpacer(12.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "10,000+",
                  style: AppTextStyles.bodyXSSemiBold(
                    color: AppTextColors.primaryNavyBlueHeader,
                  ),
                  children: [
                    TextSpan(
                      text:
                          " users gained insights to take control of their finances — so can you!",
                      style: AppTextStyles.bodyXSRegular(
                        color: AppTextColors.primaryNavyBlueHeader,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageView() {
    return carouselSlider.CarouselSlider(
      items: introPageList.map<Widget>((e) => _pageItem(e)).toList(),
      carouselController: pageController,
      options: carouselSlider.CarouselOptions(
        onPageChanged: (index, reason) {
          logic.introScreenIndex = index;
        },
        height: 472.h,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }

  Widget _pageItem(FinSightsIntroScreenModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              model.image,
              // height: 257.h,
            ),
          ),
          VerticalSpacer(15.h),
          Text(
            model.title,
            style: AppTextStyles.headingSSemiBold(
              color: AppTextColors.primaryNavyBlueHeader,
            ),
            textAlign: TextAlign.center,
          ),
          VerticalSpacer(12.h),
          Text(
            model.subTitle,
            style: AppTextStyles.bodySRegular(
              color: AppTextColors.neutralBody,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _socialProofContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: CornerRadius.medium(),
      ),
      child: Row(
        children: [
          Image.asset(
            Res.finsightsIntroSocialProofPNG,
            width: 72.w,
          ),
          HorizontalSpacer(12.w),
          Expanded(
            child: Text(
              "Users have gained insights to take control\nof their finances — now it’s your turn!",
              style: AppTextStyles.bodyXSRegular(
                color: AppTextColors.primaryNavyBlueHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
