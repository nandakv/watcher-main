import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/non_eligible_finsights/non_eligible_finsights_carousal_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../res.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../components/page_indicator.dart';
import '../polling/polling_screen.dart';
import 'non_eligible_finsights_bottom_widget.dart';
import 'non_eligible_finsights_logic.dart';

class NonEligibleFinSightScreen extends StatefulWidget {
  NonEligibleFinSightScreen({super.key});

  @override
  State<NonEligibleFinSightScreen> createState() =>
      _NonEligibleFinSightScreenState();
}

class _NonEligibleFinSightScreenState extends State<NonEligibleFinSightScreen>
    with AfterLayoutMixin {
  final logic = Get.find<NonEligibleFinsightLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NonEligibleFinsightLogic>(builder: (logic) {
      return Scaffold(
          body:
          _bodyWidget(logic)
      );
    });
  }

  Widget _bodyWidget(NonEligibleFinsightLogic logic) {
    switch (logic.nonEligibleState) {
      case NonEligibleState.nonFinSightScreen:
        return logic.isPageLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            children: [_computeBuildVariant(type: logic.variantName)],
          ),
        );
      case NonEligibleState.polling:
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
          child: const SafeArea(
            child: PollingScreen(
              isClosedEnable: false,
              enableTitleSpacer: false,
              enableHelpIcon: false,
              bodyTexts: ['Adding you to the waitlist..'],
              titleLines: ['Hold Tight!'],
              isV2: true,
              progressIndicatorText:
              "It usually takes less than a minute to complete",
              assetImagePath: Res.offer_polling,
            ),
          ),
        );
    }
  }

  Widget _buildLightContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, top: 20.h),
                child: const Icon(Icons.arrow_back),
              )),
          VerticalSpacer(16.h),
          Column(
            children: [
              Text(
                'Welcome to',
                style: AppTextStyles.headingMSemiBold(color: appBarTitleColor),
              ),
              Text(
                'FinSights',
                style: AppTextStyles.displayFigtreeBold(
                    color: appBarTitleColor,
                    shadowColor: Colors.black.withOpacity(0.5)),
              ),
              VerticalSpacer(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  "Hooray! You’ve an exclusive invite to join our waitlist",
                  style: AppTextStyles.bodyMRegular(color: secondaryDarkColor),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalSpacer(40.h),
              _pageView(),
              GetBuilder<NonEligibleFinsightLogic>(
                id: logic.NON_FINSIGHTS_PAGE_INDICATOR,
                builder: (logic) {
                  return PageIndicator(
                    currentIndex: logic.currentIndex,
                  );
                },
              ),
              NonEligibleFinSightsBottomWidget()
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageView() {
    return CarouselSlider(
      items: logic.carouselSlides
          .map<Widget>((e) => NonEligibleFinsightsCarouselWidget(
          nonEligibleFinsightsCarousalModel: e))
          .toList(),
      carouselController: logic.nonEligibleFinSightsPageController,
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          logic.onCarouselPageChange(index);
        },
        height: 260.h,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }

  Widget NonEligibleFinsightsCarouselWidget(
      {required NonEligibleFinsightsCarousalModel
      nonEligibleFinsightsCarousalModel}) {
    return Column(
      children: [
        SvgPicture.asset(
          nonEligibleFinsightsCarousalModel.img,
        ),
        VerticalSpacer(8.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 32.w),
          child: Text(
            nonEligibleFinsightsCarousalModel.title,
            style: AppTextStyles.headingSMedium(color: blue1600),
            textAlign: TextAlign.center,
          ),
        ),
        VerticalSpacer(16.h),
      ],
    );
  }

  Widget _computeBuildVariant({required NonEligibleFinSightsType type}) {
    switch (type) {
      case NonEligibleFinSightsType.lightVariant:
        return _buildLightContent();
      case NonEligibleFinSightsType.darkVariant:
        return _buildDarkContent();
    }
  }

  Widget _buildDarkContent() {
    return Column(
      children: [
        Stack(children: [
          Positioned.fill(
            child: Image.asset(
              Res.bgsparkles,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                )),
          ),
          SafeArea(
            child: Column(
              children: [
                VerticalSpacer(34.h),
                Text(
                  'Welcome to',
                  style: AppTextStyles.headingMSemiBold(color: Colors.white),
                ),
                Text(
                  'FinSights',
                  style: AppTextStyles.displayFigtreeBold(
                      color: whiteTextColor,
                      shadowColor: grey700.withOpacity(1)),
                ),
                VerticalSpacer(8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "Hooray! You’re among our top customers\nwith exclusive access to this feature",
                    style: AppTextStyles.bodyMRegular(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                VerticalSpacer(30.h),
                SvgPicture.asset(
                  Res.nonFinSightDarkImg,
                ),
                Container(
                  margin:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff1a1b45),
                        Color(0xff36375d),
                        Color(0xff535473),
                      ],
                      stops: [0.0, 0.63, 1.0],
                      begin: Alignment.centerRight,
                      end: Alignment.bottomCenter,
                    ),
                    // color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xffAF8E2F)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "What’s in it for you?",
                        style:
                        AppTextStyles.headingXSMedium(color: Colors.white),
                      ),
                      VerticalSpacer(16.h),
                      _pageViewDark(),
                      GetBuilder<NonEligibleFinsightLogic>(
                        id: logic.NON_FINSIGHTS_PAGE_INDICATOR_DARK,
                        builder: (logic) {
                          return PageIndicator(
                            indicatorCount: 2,
                            currentIndex: logic.currentIndexDark,
                            indicatorActiveColor: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
        NonEligibleFinSightsBottomWidget()
      ],
    );
  }

  Widget _pageViewDark() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: CarouselSlider(
        items: logic.carouselSlidesDark
            .map<Widget>((e) => _darkCaroselWidget(e))
            .toList(),
        carouselController: logic.nonEligibleFinSightsPageController,
        options: CarouselOptions(
          onPageChanged: (index, reason) {
            logic.currentIndexDark = index;
          },
          height: 80.h,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
        ),
      ),
    );
  }

  Row _darkCaroselWidget(List<NonEligibleFinsightsCarousalModel> slide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: slide.map((model) {
        return Expanded(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Column(
              children: [
                SvgPicture.asset(model.img, height: 32.h),
                VerticalSpacer(10.h),
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyXSRegular(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    return logic.afterLayout();
  }
}
