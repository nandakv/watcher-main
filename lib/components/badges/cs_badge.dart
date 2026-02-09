import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

/// Defines the visual style of the badge.
enum CSBadgeType {
  /// A solid background color.
  fill,

  /// A transparent background with a colored border.
  outlined,
}

///Badges
///As per the design page we have 5 types of badges
///Special -> Golden color badge for offers
///Positive -> Indicates a success scenario
///Neutral -> Grey color badge for non important changes
///Negative -> Rejected and other negative scenarios
///Primary -> Blue color badge for normal badges
extension BadgeStyle on CSBadge {
  CSBadge special({CSBadgeType type = CSBadgeType.fill, bool showLeadingIcon = true}) {
    return CSBadge(
      text: text,
      type: type,
      showLeadingIcon: showLeadingIcon,
      bgColor: secondaryYellow800,
      textColor: type == CSBadgeType.fill ? Colors.white : secondaryYellow800,
      borderColor: secondaryYellow800,
      leading: _buildLeadingIcon(
        type: type,
        fillIconColor: Colors.white,
        outlinedCircleColor: secondaryYellow800,
      ),
    );
  }

  CSBadge positive({CSBadgeType type = CSBadgeType.fill, bool showLeadingIcon = true}) {
    return CSBadge(
      text: text,
      type: type,
      showLeadingIcon: showLeadingIcon,
      bgColor: green500,
      textColor: type == CSBadgeType.fill ? Colors.white : green500,
      borderColor: green500,
      leading: _buildLeadingIcon(
        type: type,
        fillIconColor: Colors.white,
        outlinedCircleColor: green500,
      ),
    );
  }

  CSBadge neutral({CSBadgeType type = CSBadgeType.fill, bool showLeadingIcon = true}) {
    return CSBadge(
      text: text,
      type: type,
      showLeadingIcon: showLeadingIcon,
      bgColor: grey300,
      textColor: grey900,
      borderColor: grey300,
      leading: _buildLeadingIcon(
        type: type,
        fillIconColor: grey900,
        outlinedCircleColor: grey900,
      ),
    );
  }

  CSBadge negative({CSBadgeType type = CSBadgeType.fill, bool showLeadingIcon = true}) {
    return CSBadge(
      text: text,
      type: type,
      showLeadingIcon: showLeadingIcon,
      bgColor: red200,
      textColor: red700,
      borderColor: red700,
      leading: _buildLeadingIcon(
        type: type,
        fillIconColor: red700,
        outlinedCircleColor: red700,
      ),
    );
  }

  CSBadge primary({CSBadgeType type = CSBadgeType.fill, bool showLeadingIcon = true}) {
    return CSBadge(
      text: text,
      type: type,
      showLeadingIcon: showLeadingIcon,
      bgColor: blue1200,
      textColor: type == CSBadgeType.fill ? Colors.white : blue1200,
      borderColor: blue1200,
      leading: _buildLeadingIcon(
        type: type,
        fillIconColor: Colors.white,
        outlinedCircleColor: blue1200,
      ),
    );
  }

  Widget _buildLeadingIcon({
    required CSBadgeType type,
    required Color fillIconColor,
    required Color outlinedCircleColor,
  }) {
    if (type == CSBadgeType.outlined) {
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: outlinedCircleColor, shape: BoxShape.circle),
        child: SvgPicture.asset(
          Res.badgeCheck,
          height: 10.h,
          width: 10.w,
          color: Colors.white, // Check is always white on a colored circle
        ),
      );
    }
    // Otherwise, it's a simple icon for the fill style.
    return SvgPicture.asset(
      Res.badgeCheck,
      height: 16.h,
      width: 16.w,
      color: fillIconColor,
    );
  }
}

class CSBadge extends StatelessWidget {
  final Color? bgColor;
  final String text;
  final Color? textColor;
  final Color? borderColor;
  final Widget? leading;
  final CSBadgeType type;
  final bool showLeadingIcon;
  final TextStyle? textStyle;

  const CSBadge({
    super.key,
    required this.text,
    this.bgColor,
    this.textStyle,
    this.textColor,
    this.borderColor,
    this.leading,
    this.type = CSBadgeType.fill,
    this.showLeadingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: type == CSBadgeType.outlined
          ? BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor ?? textColor ?? Colors.red),
      )
          : BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLeadingIcon && leading != null) ...[
            leading!,
            HorizontalSpacer(4.w),
          ],
          Text(
            text,
            style: textStyle ?? AppTextStyles.bodyXSRegular(color: textColor ?? Colors.white),
          )
        ],
      ),
    );
  }
}