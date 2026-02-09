import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../theme/app_colors.dart';

class RoundOutlineBadgeWidget extends StatelessWidget {
  const RoundOutlineBadgeWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decoration(),
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 12.w,
      ),
      child: Text(
        title,
        style: _textStyle(),
      ),
    );
  }

  TextStyle _textStyle() {
    return AppTextStyles.bodyXSMedium(color: secondaryYellow800);
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      border: Border.all(
        color: secondaryYellow800,
        width: 1.r,
      ),
      borderRadius: BorderRadius.circular(20.r),
    );
  }
}
