import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';
import '../../../../components/button.dart';
import '../../../common_widgets/bottom_sheet_widget.dart';
import 'aa_stand_alone_know_more_model.dart';
import 'aa_stand_alone_logic.dart';

class AAStandAloneKnowMoreBottomSheet extends StatelessWidget {
  AAStandAloneKnowMoreBottomSheet({super.key});

  final logic = Get.find<AAStandAloneLogic>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      onCloseClicked: logic.onAABotfBenefitsCrossClicked,
      childPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      enableCloseIconButton: true,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Secure your eligibility today",
          style: AppTextStyles.headingSMedium(color: navyBlueColor),
        ),
        verticalSpacer(8.h),
        Text(
          "Give consent to your bank details now and unlock exclusive opportunities",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySRegular(color: grey700),
        ),
        VerticalSpacer(32.h),
        ..._contentListView(),
        verticalSpacer(8.h),
        Button(
          buttonType: ButtonType.primary,
          buttonSize: ButtonSize.medium,
          title: "Continue",
          onPressed: logic.onKnowMoreCTA,
        ),
        VerticalSpacer(8.h),
      ],
    );
  }

  List<Widget> _contentListView() {
    return logic.knowMoreList
        .map<Widget>((e) => _knowMoreTile(aaStandAloneKnowMoreModel: e))
        .toList();
  }

  Widget _knowMoreTile({required AAStandAloneKnowMoreModel aaStandAloneKnowMoreModel}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: preRegistrationEnabledGradientColor2.withOpacity(0.10),
              border: Border.all(color: const Color(0xFF229ACE), width: 1.w),
              borderRadius: BorderRadius.circular(28),
            ),
            child: SvgPicture.asset(aaStandAloneKnowMoreModel.icon),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              aaStandAloneKnowMoreModel.title,
              style: AppTextStyles.bodySMedium(color: blue1600),
            ),
          ),
        ],
      ),
    );
  }
}
