import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class PageSwipeIndicator extends StatelessWidget {
  final double currentIndex;
  final int dotsCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageSwipeIndicator(
      {Key? key,
      required this.currentIndex,
      this.dotsCount = 4,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 1, bottom: 15),
        child: DotsIndicator(
          dotsCount: dotsCount,
          position: currentIndex,
          decorator: DotsDecorator(
            color: inactiveColor ?? Colors.grey.withOpacity(0.3),
            activeColor: activeColor ?? const Color(0xffAF8E2F),
            size: const Size.square(6),
            activeSize: const Size(15.0, 6),
            spacing: const EdgeInsets.only(
              left: 5,
              right: 5,
              bottom: 10,
            ),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
