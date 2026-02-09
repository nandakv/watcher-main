import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/components/svg_icon.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = true,
    this.leading,
    this.trailing,
  });

  final String text;
  final GestureTapCallback onTap;
  final bool isSelected;
  final String? leading;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? darkBlueColor : Colors.transparent,
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(
            color: darkBlueColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                SVGIcon(size: SVGIconSize.small, icon: leading!),
                HorizontalSpacer(4.w)
              ],
              isSelected
                  ? Text(text,style: AppTextStyles.bodySMedium(color: whiteTextColor),)
                  : Text(text,style: AppTextStyles.bodySMedium(color: darkBlueColor),),
              if (trailing != null) ...[
                HorizontalSpacer(4.w),
                SVGIcon(size: SVGIconSize.small, icon: trailing!),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
