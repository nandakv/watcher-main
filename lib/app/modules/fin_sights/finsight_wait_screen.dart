import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

import '../../../res.dart';

class FinsightsWaitScreen extends StatelessWidget {
  final Function()? onClosePressed;

  const FinsightsWaitScreen({super.key, this.onClosePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _pollingCloseIcon(),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                    child: Text(
                      "Almost there!",
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.headingMSemiBold(color: appBarTitleColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 20.h),
                  child: Text(
                    "It is taking longer than expected to generate your financial summary. We’ll notify you once it’s ready",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySMedium(color: darkBlueColor),
                  ),
                ),
                verticalSpacer(10.h),
                SvgPicture.asset(
                  Res.waitObject,
                ),
                const Spacer(
                  flex: 2,
                ),
                _bottomInfoText(),
                VerticalSpacer(16.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Button(
                    buttonSize: ButtonSize.large,
                    buttonType: ButtonType.primary,
                    title: "Got it",
                    onPressed: () {
                      onClosePressed?.call();
                    },
                  ),
                ),
                verticalSpacer(30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Align _bottomInfoText() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Res.info),
            SizedBox(
              width: 4.w,
            ),
            Text(
              "Don’t worry, your progress is saved",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySMedium(color: darkBlueColor),
            )
          ],
        ));
  }

  Widget _pollingCloseIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            onClosePressed?.call();
          },
          icon: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        ),
      ],
    );
  }
}