import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/rich_text_consent_checkbox.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/flavors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreditScoreConsentModalSheet extends StatelessWidget {
  final logic = Get.find<CreditReportLogic>();
  final bool isRefreshFlow;

  CreditScoreConsentModalSheet({this.isRefreshFlow = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        await logic.onBackClicked();
        return false;
      },
      child: BottomSheetWidget(
        enableCloseIconButton: true,
        onCloseClicked: () {
          Get.back();
          logic.onBackClicked(isExpiredConsent:isRefreshFlow);
        },
        child: Column(
          children: [
            ...isRefreshFlow
                ? _refreshConsentBodyWidget()
                : _freshConsentBodyWidget(),
            _consentWidget(),
            VerticalSpacer(12.h),
            _button(),
            VerticalSpacer(12.h),
            const PoweredByExperian(),
            VerticalSpacer(32.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _refreshConsentBodyWidget() {
    return [
      Text(
        "Consent Expired",
        style:
            AppTextStyles.headingSMedium(color: AppTextColors.brandBlueTitle),
      ),
      VerticalSpacer(12.h),
      Text(
        "Get bigger and better benefits. Re-authorise now for an updated credit score! Stay updated, stay rewarded!",
        style: AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
      ),
      VerticalSpacer(32.h),
    ];
  }

  List<Widget> _freshConsentBodyWidget() {
    return [
      SvgPicture.asset(Res.experianD2cFrame),
      VerticalSpacer(16.h),
      Text(
        "Know your Credit Score for free",
        style: AppTextStyles.headingSMedium(color: blue1600),
      ),
      VerticalSpacer(8.h),
      Text(
        "Access your credit score instantly and keep track of your financial health with ease, without any impact on your score",
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySRegular(color: grey700),
      ),
      VerticalSpacer(24.h),
    ];
  }

  GetBuilder<CreditReportLogic> _button() {
    return GetBuilder<CreditReportLogic>(
      id: logic.BUTTON_ID,
      builder: (logic) {
        return Button(
          buttonSize: ButtonSize.large,
          buttonType: ButtonType.primary,
          title: "Accept & Continue",
          enabled: logic.computeKnowMoreCTAEnabled(),
          isLoading: logic.isButtonLoading,
          onPressed: () => logic.onKnowMoreContinue(
            isFromBottomSheet: true,
            isExpiredConsent: isRefreshFlow
          ),
        );
      },
    );
  }

  GetBuilder<CreditReportLogic> _consentWidget() {
    return GetBuilder<CreditReportLogic>(
      id: logic.CONSENT_CHECKBOX_ID,
      builder: (logic) {
        return RichTextConsentCheckBox(
          consentCheckBoxValue: logic.isConsentChecked,
          onChanged: logic.onConsentValueChanged,
          consentTextList: [
            RichTextModel(
              text:
                  "I allow Kisetsu Saison Finance (India) Private Limited (KSF) to access my Experian D2C report to provide personalised financial insights. I also agree to Experian's ",
              textStyle: AppTextStyles.bodyXSRegular(color: blue1200),
            ),
            RichTextModel(
              text: "T&C.",
              onTap: _onTnCTapped,
              textStyle: _tncTextStyle(),
            )
          ],
        );
      },
    );
  }

  TextStyle _tncTextStyle() {
    return TextStyle(
      fontSize: 10.sp,
      letterSpacing: 0.112,
      color: darkBlueColor,
      decoration: TextDecoration.underline,
    );
  }

  _onTnCTapped() {
    launchUrlString(
      F.envVariables.experianTnCUrl,
      mode: LaunchMode.inAppWebView,
    );
  }
}
