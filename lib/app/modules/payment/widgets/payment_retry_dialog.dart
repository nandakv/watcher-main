import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

import '../../../../res.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';

class PaymentRetryDialog extends StatelessWidget {
  final Function onCancel;
  final Function onRetry;
  final String errorDescription;
  const PaymentRetryDialog(
      {Key? key,
      required this.onCancel,
      required this.onRetry,
      required this.errorDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalSpacer(16.h),
          SvgPicture.asset(
            Res.errorDialogIcon,
          ),
          VerticalSpacer(16.h),
          Text(
            "Payment Failed",
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueTitle),
          ),
          VerticalSpacer(12.h),
          Text(
            errorDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cancelButton(),
              HorizontalSpacer(16.w),
              Button(
                buttonSize: ButtonSize.medium,
                buttonType: ButtonType.primary,
                onPressed: () {
                  onRetry();
                },
                title: "Retry",
              ),
            ],
          ),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return Button(
      buttonSize: ButtonSize.medium,
      buttonType: ButtonType.secondary,
      title: "Cancel",
      onPressed: () {
        onCancel();
      },
    );
  }
}
