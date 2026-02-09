import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_helper.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_app_bar.dart';
import 'package:privo/app/modules/on_boarding/model/privo_app_bar_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class CreditScoreKnowMoreV2Widget extends StatelessWidget {
  KnowMoreHelper knowMoreHelper;

  CreditScoreKnowMoreV2Widget({super.key, required this.knowMoreHelper});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (knowMoreHelper.knowMoreBackground != null)
          Positioned.fill(
            child: SvgPicture.asset(
              knowMoreHelper.knowMoreBackground!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        _bodyWidget(),
      ],
    );
  }

  Widget _appbar() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 16.h),
      child: Row(
        children: [
          if (knowMoreHelper.backButton != null)
            knowMoreHelper.backButton!
          else
            GestureDetector(
              onTap: () => knowMoreHelper.onKnowMoreBackPressed(),
              child: SvgPicture.asset(
                Res.arrowBack,
                height: 15.h,
                width: 15.w,
              ),
            ),
          HorizontalSpacer(16.w),
          Text(
            knowMoreHelper.knowMoreAppBarTitle,
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.primaryNavyBlueHeader,),
          ),
          const Spacer(),
          if (knowMoreHelper.closeButton != null)
            knowMoreHelper.closeButton!
          else
            IconButton(
              onPressed: () => knowMoreHelper.onClosePressed(),
              icon: SvgPicture.asset(Res.close_mark_svg),
            ),
        ],
      ),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        _appbar(),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            children: [
              knowMoreHelper.consentWidget,
              VerticalSpacer(12.h),
              knowMoreHelper.knowMoreButton,
              VerticalSpacer(12.h),
              knowMoreHelper.poweredByWidget
            ],
          ),
        )
      ],
    );
  }
}
