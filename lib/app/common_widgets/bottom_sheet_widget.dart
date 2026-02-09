import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/components/svg_icon.dart';

import '../../res.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
    required this.child,
    this.enableCloseIconButton = true,
    this.onCloseClicked,
    this.childPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.margin = const EdgeInsets.all(8),
    this.borderRadius,
    this.backgroundImage,
  }) : super(key: key);

  final Widget child;
  final String? backgroundImage;
  final bool enableCloseIconButton;
  final Function? onCloseClicked;
  final EdgeInsets childPadding;
  final EdgeInsets margin;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: margin,
      child: backgroundImage != null
          ? Stack(
              children: [
                _backgroundImage(),
                _bottomSheetChild(),
              ],
            )
          : _bottomSheetChild(),
    );
  }

  Widget _backgroundImage() {
    return Positioned.fill(
      child: SvgPicture.asset(
        backgroundImage!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _bottomSheetChild() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (enableCloseIconButton)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    if (onCloseClicked != null) {
                      onCloseClicked!();
                    } else {
                      Get.back();
                    }
                  },
                  child: const SVGIcon(
                    icon: Res.crossMarkIcon,
                    size: SVGIconSize.medium,
                  ),
                ),
              ),
            ),
          Padding(
            padding: childPadding,
            child: child,
          ),
        ],
      ),
    );
  }
}
