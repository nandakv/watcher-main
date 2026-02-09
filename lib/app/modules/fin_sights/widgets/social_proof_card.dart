import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_widgets/spacer_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/corner_radius.dart';

class SocialProofCard extends StatelessWidget {
  final String imageAssetPath;
  final String text;
  final Color bgColor;

  const SocialProofCard(
      {super.key,
      required this.imageAssetPath,
      required this.text,
      this.bgColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: CornerRadius.medium(),
      ),
      child: Row(
        children: [
          Image.asset(
            imageAssetPath,
            width: 72.w,
          ),
          HorizontalSpacer(12.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyXSRegular(
                color: AppTextColors.primaryNavyBlueHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
