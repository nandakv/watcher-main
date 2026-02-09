import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class SimpleBottomSheet extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? body;

  const SimpleBottomSheet({
    Key? key,
    required this.title,
    this.subTitle,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: AppTextStyles.headingSMedium(
              color: AppTextColors.brandBlueTitle,
            ),
          ),
          VerticalSpacer(12.h),
          if (subTitle != null)
            Text(
              subTitle!,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralBody,
              ),
            ),
          if (body != null) body!,
          VerticalSpacer(12.h),
        ],
      ),
    );
  }
}
