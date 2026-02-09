import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class CLPDisabledCard extends StatelessWidget {
  const CLPDisabledCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: blue1200, width: 1),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _bgImage(),
          Padding(
            padding: EdgeInsets.only(
                top: 16.h, bottom: 27.h, left: 20.w, right: 64.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privo Instant Loan",
                  style: AppTextStyles.headingSMedium(color: blue1200),
                ),
                VerticalSpacer(12.h),
                _infoText(
                    "Credit Line applications are no longer available on the app. "),
                VerticalSpacer(4.h),
                _infoText(
                    "We appreciate your support and will keep you informed about future updates. Thank you for being with us!"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText(String info) {
    return Text(
      info,
      style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
    );
  }

  Widget _bgImage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SvgPicture.asset(
        Res.clpDisabledBackground,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
