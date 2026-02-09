import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/custom_page_indicator/custom_page_indicator_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

class CustomPageIndicator extends StatefulWidget {
  final int itemCount;

  final PageController pageController;

  const CustomPageIndicator({
    Key? key,
    required this.itemCount,
    required this.pageController,
  }) : super(key: key);

  @override
  State<CustomPageIndicator> createState() => _CustomPageIndicatorState();
}

class _CustomPageIndicatorState extends State<CustomPageIndicator> {
  final logic = Get.put(CustomPageIndicatorLogic());

  late final double selectedIndicatorSize = 12;
  late final double unSelectedIndicatorSize = 5;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomPageIndicatorLogic>(
      builder: (logic) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.itemCount,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _pageIndicatorDot(index),
            ),
          ),
        );
      },
    );
  }

  Widget _pageIndicatorDot(int index) {
    return Container(
      width: logic.currentIndex == index
          ? selectedIndicatorSize
          : unSelectedIndicatorSize,
      height: 5,
      decoration: BoxDecoration(
          color: logic.currentIndex == index ? darkBlueColor : Colors.grey,
          borderRadius: BorderRadius.circular(5)),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      logic.didChangePage(widget.pageController);
    });
  }
}
