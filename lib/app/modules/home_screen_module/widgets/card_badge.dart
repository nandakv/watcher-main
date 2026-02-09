import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class CardBadge extends StatelessWidget {
  final CardBadgeType cardBadgeType;
  final String text;

  const CardBadge({
    super.key,
    required this.cardBadgeType,
    this.text = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _computeBoxColor(),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        child: Text(
          _computeTitle(),
          style: AppTextStyles.bodyXSSemiBold(
            color: _computeTextColor(),
          ),
        ),
      ),
    );
  }

  String _computeTitle() {
    if (text.isNotEmpty) return text;
    switch (cardBadgeType) {
      case CardBadgeType.none:
        return "";
      case CardBadgeType.progress:
        return "In progress";
      case CardBadgeType.active:
        return "Active";
      case CardBadgeType.overdue:
        return "Overdue";
      case CardBadgeType.rejected:
        return "Rejected";
      case CardBadgeType.expired:
        return "Expired";
      case CardBadgeType.closed:
        return "Closed";
      default:
        return "";
    }
  }

  _computeTextColor() {
    switch (cardBadgeType) {
      case CardBadgeType.none:
      case CardBadgeType.ownership:
        return Colors.transparent;
      case CardBadgeType.progress:
      case CardBadgeType.closed:
        return primaryDarkColor;
      case CardBadgeType.active:
        return green500;
      case CardBadgeType.overdue:
      case CardBadgeType.rejected:
      case CardBadgeType.expired:
        return red;
    }
  }

  _computeBoxColor() {
    switch (cardBadgeType) {
      case CardBadgeType.none:
      case CardBadgeType.ownership:
        return Colors.transparent;
      case CardBadgeType.progress:
        return lightGrayColor;
      case CardBadgeType.active:
        return green500.withOpacity(0.2);
      case CardBadgeType.overdue:
      case CardBadgeType.rejected:
      case CardBadgeType.expired:
        return red.withOpacity(0.2);
      case CardBadgeType.closed:
        return lightGrayColor;
    }
  }
}
