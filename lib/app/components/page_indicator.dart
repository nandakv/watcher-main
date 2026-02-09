import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int indicatorCount;
  final Color indicatorActiveColor;

  const PageIndicator(
      {super.key, required this.currentIndex, this.indicatorCount = 3,this.indicatorActiveColor=blue1600});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        indicatorCount,
        (index) => AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          duration: const Duration(milliseconds: 500),
          height: 4.w,
          width: currentIndex == index ? 12.w : 4.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: currentIndex == index ? indicatorActiveColor : grey500,
          ),
        ),
      ),
    );
  }
}
