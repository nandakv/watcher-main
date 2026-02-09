import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../firebase/analytics.dart';
import '../../../theme/app_colors.dart';

///on click of info icon
///

class InfoBottomSheet extends StatelessWidget {
  String title;
  String text;
  String closedEvent = '';
  String yesEvent = '';
  String noEvent = '';
  Map<String, dynamic>? attributeName;

  InfoBottomSheet(
      {required this.title,
      required this.text,
      this.closedEvent = '',
      this.yesEvent = '',
      this.noEvent = '',
      this.attributeName});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
      childPadding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueTitle),
          ),
          VerticalSpacer(12.h),
          Text(
            text,
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(16.h)
        ],
      ),
    );
  }

  Align _closeIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: closedEvent,
          );
          Get.back();
        },
        icon: const Icon(
          Icons.clear_rounded,
          color: Color(0xFF161742),
          size: 15,
        ),
      ),
    );
  }
}
