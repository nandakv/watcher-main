import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';

import '../../../../res.dart';
import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_text_styles.dart';

class CreditScoreRedirectBottomSheet extends StatelessWidget {
  const CreditScoreRedirectBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BottomSheetWidget(
        childPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        enableCloseIconButton: false,
        child: _buildContent(),
      ),
    );
  }

  Column _buildContent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Res.redirectFailure),
          VerticalSpacer(16.h),
          _buildTitle(),
          VerticalSpacer(16.h),
          _buildSubTitle(),
          VerticalSpacer(16.h),
          _bottomTitle(),
        ],
      );
  }

  Widget _bottomTitle() {
    return Text(
      "Redirecting to home screen shortly...",
      style: AppTextStyles.bodySSemiBold(color: darkBlueColor),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Unable to proceed",
      style: AppTextStyles.headingSMedium(color: darkBlueColor),
    );
  }

  Widget _buildSubTitle() {
    return Text(
      "We couldn’t fetch your mobile number, so we are unable to continue. Sorry for the inconvenience",
      style: AppTextStyles.bodySRegular(color: primaryDarkColor),
    );
  }
}
