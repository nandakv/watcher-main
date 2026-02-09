import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../app/utils/app_text_styles.dart';

enum PillButtonIconPosition {
  left(padding: EdgeInsets.only(right: 4)),
  right(padding: EdgeInsets.only(left: 4));

  const PillButtonIconPosition({required this.padding});

  final EdgeInsets padding;
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.icon,
    this.iconPosition = PillButtonIconPosition.left,
  });

  final String text;
  final GestureTapCallback onTap;
  final bool isSelected;
  final Widget? icon;
  final PillButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? darkBlueColor : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: darkBlueColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPosition == PillButtonIconPosition.left) _iconWidget(),
              _textWidget(),
              if (iconPosition == PillButtonIconPosition.right) _iconWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWidget() {
    if (icon == null) return const SizedBox();
    return Padding(padding: iconPosition.padding, child: icon!);
  }

  Widget _textWidget() {
    return isSelected
        ? Text(
            text,
            style: AppTextStyles.bodyXSSemiBold(
              color: Colors.white,
            ),
          )
        : Text(
            text,
            style: AppTextStyles.bodyXSMedium(
              color: darkBlueColor,
            ),
          );
  }
}
