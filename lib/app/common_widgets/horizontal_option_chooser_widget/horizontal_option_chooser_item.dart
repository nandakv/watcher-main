import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_item.dart';

import '../../theme/app_colors.dart';

class HorizontalOptionChooserItem extends StatelessWidget {
  const HorizontalOptionChooserItem({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.index,
    this.width = 80,
    this.height = 68,
  }) : super(key: key);

  final HorizontalOptionItem item;
  final bool isSelected;
  final double? width;
  final double? height;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? 0 : 12,
        right: index == 3 ? 0 : 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            decoration: _containerDecoration(),
            child: Center(
              child: _icon(),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _titleText(),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: isSelected ? darkBlueColor : Colors.transparent,
      border: Border.all(
        color: isSelected ? darkBlueColor : secondaryDarkColor,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _icon() {
    return SvgPicture.asset(
      item.icon,
      height: 32,
      width: 32,
      colorFilter: item.autoIconColor
          ? ColorFilter.mode(
              isSelected ? Colors.white : secondaryDarkColor,
              BlendMode.srcATop,
            )
          : null,
    );
  }

  Text _titleText() {
    return Text(
      item.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isSelected ? darkBlueColor : secondaryDarkColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        fontSize: 12,
      ),
    );
  }
}
