import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/components/page_indicator.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';

import '../../../components/button.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../data/provider/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'finsights_popup_model.dart';

class FinSightsCarouselSlider extends StatelessWidget {
  FinSightsModel finSightsModel;

  FinSightsCarouselSlider({super.key, required this.finSightsModel});

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
              borderRadius: BorderRadius.circular(8.0.w),
              child: Column(children: [
                _pageView(),
                GetBuilder<HomeScreenLogic>(
                  id: logic.FINSIGHTS_PAGE_INDICATOR,
                  builder: (logic) {
                    return PageIndicator(currentIndex: logic.currentIndex,);
                  },
                ),
                VerticalSpacer(24.h),
                _buttonWidget(context),
                VerticalSpacer(20.h)
              ])),
        ],
      ),
    );
  }

  Widget _pageView() {
    return CarouselSlider(
      items: logic.finSightsScrollList
          .map<Widget>((e) => finSightsCarouselWidget(finSightsPopUpModel: e))
          .toList(),
      carouselController: logic.finSightsPageController,
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          logic.currentIndex = index;
        },
        height: 300.h,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }

  Row _buttonWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button(
          buttonType: ButtonType.secondary,
          buttonSize: ButtonSize.small,
          title: "Not now",
          onPressed: () {
            logic.logStoryModeNotNowClicked();
            Navigator.pop(context);
            AppAuthProvider.setShowFinSightsStoryMode();
          },
          fillWidth: true,
        ),
        SizedBox(
          width: 16.w,
        ),
        Button(
          buttonType: ButtonType.primary,
          buttonSize: ButtonSize.small,
          title: "Explore",
          onPressed: () {
            Navigator.pop(context);
            AppAuthProvider.setShowFinSightsStoryMode();
            logic.logStoryModeExploreClicked();
            logic.onTapFinSights(finSightsModel);
          },
          fillWidth: true,
        ),
      ],
    );
  }

  Widget finSightsCarouselWidget(
      {required FinSightsPopUpModel finSightsPopUpModel}) {
    return Column(
      children: [
        VerticalSpacer(20.h),
        SvgPicture.asset(
          finSightsPopUpModel.img,
          width: 280.w,
          fit: BoxFit.fitWidth,
        ),
        VerticalSpacer(12.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 32.w),
          child: Text(
            finSightsPopUpModel.title,
            style: AppTextStyles.bodyLSemiBold(color: blue1600),
            textAlign: TextAlign.center,
          ),
        ),
        VerticalSpacer(6.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 32.w),
          child: Text(
            finSightsPopUpModel.subTitle,
            maxLines: 2,
            style: AppTextStyles.bodySRegular(color: blue1600),
            textAlign: TextAlign.center,
          ),
        ),
        VerticalSpacer(16.h),
      ],
    );
  }
}
