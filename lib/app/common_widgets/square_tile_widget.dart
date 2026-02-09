import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'golden_badge.dart';

class SquareTileWidget extends StatelessWidget {
  const SquareTileWidget({
    Key? key,
    required this.isRecommended,
    required this.onTap,
    required this.isSelected,
    required this.title,
    required this.icon,
    this.autoIconColor = true,
    this.iconHorizontalPadding = 20,
    this.iconSize = 25,
  }) : super(key: key);

  final bool isSelected;
  final bool isRecommended;
  final String title;
  final String icon;
  final Function() onTap;
  final bool autoIconColor;
  final double iconHorizontalPadding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: _containerDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    _icon(),
                    const SizedBox(
                      height: 5,
                    ),
                    _titleText(),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isRecommended) _recommendedBatch(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: isSelected ? navyBlueColor : Colors.transparent,
      border: Border.all(
        color: navyBlueColor,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Padding _icon() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: iconHorizontalPadding,
      ),
      child: SvgPicture.asset(
        icon,
        height: iconSize,
        colorFilter: autoIconColor
            ? ColorFilter.mode(
                isSelected ? offWhiteColor : navyBlueColor,
                BlendMode.srcATop,
              )
            : null,
      ),
    );
  }

  Text _titleText() {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? offWhiteColor : navyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 10,
      ),
    );
  }

  Positioned _recommendedBatch() {
    return const Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 10,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: GoldenBadge(
              title: "RECOMMENDED",
            ),
          ),
        ),
      ),
    );
  }
}
