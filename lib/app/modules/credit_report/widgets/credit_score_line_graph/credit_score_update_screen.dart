import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/credit_report/credit_report_helper_mixin.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';

import '../../../../../components/button.dart';
import '../../../../../res.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../common_widgets/vertical_spacer.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class CreditScoreUpdateScreen extends StatelessWidget {
  CreditScoreUpdateScreen({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding:  EdgeInsets.all(24.0.w),
      child: Column(
        children: [
          _closeIcon(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.creditScoreImg),
                VerticalSpacer(50.h),
                _titleText(),
                VerticalSpacer(8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: _messageText(),
                ),
                VerticalSpacer(32.h),
                _ctaButton(),
                verticalSpacer(18.h),
              ],
            ),
          ),
          const PoweredByExperian(),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }

  RichText _messageText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text:
                'Your Experian score has ${logic.creditScoreUpdate.scoreChange} \nby ',
            style: AppTextStyles.bodyMMedium(color: darkBlueColor),
          ),
          TextSpan(
              text: '${logic.creditScoreUpdate.creditPoint} points',
              style: AppTextStyles.bodyMMedium(
                color: logic.creditScoreUpdate.textColor,
              )),
        ],
      ),
    );
  }

  Text _titleText() {
    return Text(logic.creditScoreUpdate.scoreTitle,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingMSemiBold(color: navyBlueColor));
  }

  Widget _ctaButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 56.0.w),
        child: Button(
          buttonType: ButtonType.primary,
          buttonSize: ButtonSize.small,
          title: "View Details",
          onPressed: () {
            logic.onTapViewDetails();
          },
          fillWidth: true,
        ));
  }

  Widget _closeIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
           logic.currentCreditReportState= CreditReportState.dashboard;
          },
          icon: SvgPicture.asset(Res.close_mark_svg),
        ),
      ],
    );
  }
}
