import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/theme/app_colors.dart';

enum SVGIconSize {
  small(size: 16),
  medium(size: 24),
  large(size: 32),
  extraLarge(size:48);

  final double size;

  const SVGIconSize({required this.size});
}

enum SVGIconDirection {

  up(angle: 0),
  right(angle: 1),
  down(angle: 2),
  left(angle: 3);

  final int angle;

  const SVGIconDirection({required this.angle});
}

class SVGIcon extends StatelessWidget {
  const SVGIcon({
    super.key,
    required this.size,
    required this.icon,
    this.color,
    this.direction = SVGIconDirection.up,
  });

  final SVGIconSize size;
  final SVGIconDirection direction;
  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: direction.angle,
      child: SvgPicture.asset(
        icon,
        fit: BoxFit.fill,
        width: size.size.w,
        height: size.size.w,
        colorFilter: color == null ? null : ColorFilter.mode(
          color!,
          BlendMode.srcATop,
        ),
      ),
    );
  }
}
