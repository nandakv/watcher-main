import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class DocumentConsentBottomSheet extends StatelessWidget {
  final String title;
  final String consentText;
  final Function() onBackClicked;

  DocumentConsentBottomSheet(
      {Key? key, required this.title, required this.consentText,required this.onBackClicked})
      : super(key: key);

  final logic = Get.find<AdditionalBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackClicked(),
      child: BottomSheetWidget(
        childPadding: const EdgeInsets.all(24),
        onCloseClicked: onBackClicked,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
             VerticalSpacer(8.h),
            _consentTextWidget(),
             VerticalSpacer(24.h),
            _ctaWidget(),
          ],
        ),
      ),
    );
  }

  Widget _ctaWidget() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.CONSENT_BUTTON_ID,
        builder: (logic) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: PrivoButton(
              onPressed: logic.onConsentAgreed,
              title: "Agree and confirm",
              isLoading: logic.isConsentButtonLoading,
            ),
          );
        });
  }

  Widget _consentTextWidget() {
    return Text(
      consentText,
      style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      style: AppTextStyles.headingSMedium(color: appBarTitleColor)
    );
  }
}
