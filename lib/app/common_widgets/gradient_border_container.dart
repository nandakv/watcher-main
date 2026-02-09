import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? color;
  final double? width;
  final EdgeInsets? margin;
  final double? height;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadiusGeometry;


  const GradientBorderContainer({
    Key? key,
    required this.child,
    this.borderRadius = 4,
    this.color,
    this.width,
    this.margin,
    this.height,
    this.borderRadiusGeometry,
    this.padding = const EdgeInsets.all(0.6)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(0.6),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff8FD1EC),
            Color(0xff229ACE),
          ],
        ),
        borderRadius: borderRadiusGeometry ?? BorderRadius.circular(borderRadius + 0.6),
      ),
      child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: borderRadiusGeometry ?? BorderRadius.circular(borderRadius),
          ),
          child: child),
    );
  }
}
