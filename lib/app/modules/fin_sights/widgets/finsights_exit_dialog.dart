import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/info_bulb_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class FinsightsExitDialog extends StatelessWidget {
  FinsightsExitDialog({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
      onCloseClicked: _onCloseClicked,
      childPadding: EdgeInsets.zero,
      child: Column(
        children: [
          VerticalSpacer(16.h),
          SvgPicture.asset(Res.dropOffIllustration),
          VerticalSpacer(16.h),
          _titleText(),
          VerticalSpacer(16.h),
          _bodyTextWidget(),
          _buttons(),
          _infoWidget(),
        ],
      ),
    );
  }

  Widget _bodyTextWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Text(
        "You're missing out on the ability to track your bank accounts and access a personalised finance dashboard",
        style: AppTextStyles.bodySRegular(color: grey700),
        textAlign: TextAlign.center,
      ),
    );
  }

  Text _titleText() {
    return Text(
      "Leaving already?",
      style: AppTextStyles.headingSMedium(color: blue1600),
    );
  }

  InfoBulbWidget _infoWidget() {
    return InfoBulbWidget(
      text: " ",
      padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 16.h),
      richTextModel: [
        RichTextModel(
            text: "10,000+",
            textStyle: AppTextStyles.bodySSemiBold(
                color: AppTextColors.primaryNavyBlueHeader)),
        RichTextModel(
            text:
                " users are successfully tracking their bank accounts — so can you!",
            textStyle: AppTextStyles.bodySRegular(
                color: AppTextColors.primaryNavyBlueHeader)),
      ],
    );
  }

  Widget _buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Button(
              buttonSize: ButtonSize.modifiedMedium,
              buttonType: ButtonType.secondary,
              onPressed: _onTrackLaterPressed,
              title: "Track later",
              height: 40.h,

            ),
          ),
          HorizontalSpacer(16.w),
          Expanded(
            child: Button(
              buttonSize: ButtonSize.modifiedMedium,
              buttonType: ButtonType.primary,
              onPressed: _onTrackNowPressed,
              height: 40.h,
              title: "Track now",
            ),
          )
        ],
      ),
    );
  }

  _onTrackNowPressed() {
    logic.logffTrackNowClicked();
    Get.back();
  }

  _onTrackLaterPressed() {
    logic.logffTrackLaterClicked();
    Get.back();
    Get.back();
  }

  _onCloseClicked() {
    logic.logffCrossButtonClicked();
    Get.back();
  }
}
