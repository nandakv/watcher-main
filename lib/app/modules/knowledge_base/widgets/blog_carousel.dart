import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/privo_blogs.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../theme/app_colors.dart';
import 'blog_carousel_logic.dart';

class CarouselWithIndicator extends StatelessWidget {
  final List<Blog> items;
  final Function(Blog) onTap;

  CarouselWithIndicator({Key? key, required this.items, required this.onTap})
      : super(key: key);

  final logic = Get.put(BlogCarouselLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _carouselSlider(),
        SizedBox(height: 11.h),
        _carouselPageIndicator()
      ],
    );
  }

  Widget _carouselPageIndicator() {
    return GetBuilder<BlogCarouselLogic>(
        id: logic.CAROUSEL_INDICATOR_KEY,
        builder: (logic) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _pageIndicatorDot(index),
              ),
            ),
          );
        });
  }

  Container _pageIndicatorDot(int index) {
    return Container(
      width: logic.carouselIndex == index ? 12.w : 4.w,
      height: 5.h,
      decoration: BoxDecoration(
          color: logic.carouselIndex == index ? darkBlueColor : Colors.grey,
          borderRadius: BorderRadius.circular(5.r)),
    );
  }

  Widget _carouselSlider() {
    return CarouselSlider(
      options: _carouselOptions(),
      items: items.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return _carouselItem(item);
          },
        );
      }).toList(),
    );
  }

  CarouselOptions _carouselOptions() {
    return CarouselOptions(
        height: 200.0,
        padEnds: false,
        autoPlay: true,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          logic.carouselIndex = index;
        });
  }

  Widget _carouselItem(Blog item) {
    return InkWell(
      onTap: () {
        onTap(item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: 4.r,
            )
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: _imageDecoration(item),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(8.sp),
              child: Container(
                width: double.infinity,
                decoration: _titleDecoration(),
                padding: const EdgeInsets.all(10),
                child: Text(
                  item.blogTitle,
                  style: AppTextStyles.bodySSemiBold(color: grey900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _titleDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(8.r),
      ),
    );
  }

  BoxDecoration _imageDecoration(Blog item) {
    return BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(item.blogImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.r));
  }
}
