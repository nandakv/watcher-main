import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carouselSlider;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/common_widgets/spacer_widgets.dart';
import '../../app/components/page_indicator.dart';
import '../../app/theme/app_colors.dart';
import '../../app/utils/app_text_styles.dart';
import 'carousel_item_model.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required this.items,
    required this.widgetHeight,
    this.isImageSVG = true,
  });

  final List<CarouselItemModel> items;
  final double widgetHeight;
  final bool isImageSVG;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final pageController = carouselSlider.CarouselSliderController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        carouselSlider.CarouselSlider(
          items: widget.items.map<Widget>((e) => _pageItem(e)).toList(),
          carouselController: pageController,
          options: carouselSlider.CarouselOptions(
            onPageChanged: (index, reason) {
              _currentIndex = index;
              setState(() {});
            },
            height: widget.widgetHeight.h,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
          ),
        ),
        VerticalSpacer(24.h),
        PageIndicator(currentIndex: _currentIndex),
      ],
    );
  }

  Widget _pageItem(CarouselItemModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: widget.isImageSVG
                ? SvgPicture.asset(
                    model.image,
                    // height: 257.h,
                  )
                : Image.asset(
                    model.image,
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
          if (model.subTitle.isNotEmpty) ...[
            VerticalSpacer(12.h),
            Text(
              model.subTitle,
              style: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralBody,
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}
