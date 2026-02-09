import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class WithdrawalPausedBottomSheet extends StatelessWidget {
  const WithdrawalPausedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
        enableCloseIconButton: false,
        childPadding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SvgPicture.asset(
              Res.alertFilledIcon,
            ),
            VerticalSpacer(16.h),
            _title(),
            VerticalSpacer(16.h),
            _info(),
            VerticalSpacer(32.h),
            _button(),
          ],
        ));
  }

  Widget _title() {
    return Text(
      "Further Withdrawals Paused",
      style: AppTextStyles.headingSMedium(color: AppTextColors.brandBlueTitle),
    );
  }

  Widget _info() {
    return Text(
      "New Withdrawals are no longer available on the app. We appreciate your support and will keep you informed about future updates. Thank you for being with us!",
      style: AppTextStyles.bodySRegular(
        color: AppTextColors.neutralBody,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _button() {
    return Button(
      buttonSize: ButtonSize.medium,
      buttonType: ButtonType.primary,
      title: "Got it",
      onPressed: () {
        Get.back();
      },
    );
  }
}
