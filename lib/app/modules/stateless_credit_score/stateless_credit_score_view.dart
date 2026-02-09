import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/button.dart';
import '../../../flavors.dart';
import '../../../res.dart';
import '../../common_widgets/common_text_fields/email_field.dart';
import '../../common_widgets/common_text_fields/full_name_field.dart';
import '../../common_widgets/common_text_fields/pan_field.dart';
import '../../common_widgets/forms/model/form_field_attributes.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../components/top_navigation_bar.dart';
import '../../models/rich_text_model.dart';
import '../../utils/app_text_styles.dart';
import '../credit_report/credit_report_logic.dart';
import '../credit_report/widgets/powered_by_experian.dart';
import '../on_boarding/widgets/consent_widget.dart';
import 'credit_score_applicant_form.dart';

class CreditScoreDetailsView extends StatelessWidget {
   CreditScoreDetailsView({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopNavigationBar(
              title: "Credit Score",
              onBackPressed: () => Get.back(),
              enableShadow: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    VerticalSpacer(19.h),
                    Text(
                      "This helps us ensure your report is accurate and secure",
                      style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _creditScoreApplicationDetailsForm(),
                    ),
                    VerticalSpacer(19.h),
                    _buildBottomConsentWidget(),
                    VerticalSpacer(12.h),
                    GetBuilder<CreditReportLogic>(
                        id: logic.STATELESS_BUTTON_ID,
                        builder: (logic) {
                          return Button(
                            buttonType: ButtonType.primary,
                            buttonSize: ButtonSize.large,
                            enabled: logic.coApplicantButtonEnabled,
                            onPressed: () {
                              logic.logEventOnAcceptAndContinue();
                              logic.fetchStatelessCreditReport();
                            },
                            title: "Accept & Continue",
                            isLoading: logic.isButtonLoading,
                          );
                        }),
                    VerticalSpacer(12.h),
                    const PoweredByExperian(),
                    VerticalSpacer(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //top section
  SizedBox _buildHeaderSection() {
    return SizedBox(
      width: double.infinity, // This
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: SvgPicture.asset(
                Res.spendingBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              VerticalSpacer(50.h),
              Center(child: SvgPicture.asset(Res.creditScoreDetailsImg)),
              VerticalSpacer(55.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "Add your details to get your score",
                  style: AppTextStyles.headingSMedium(color: darkBlueColor),
                ),
              ),
              //    VerticalSpacer(19.h),
            ],
          ),
        ],
      ),
    );
  }

//application form
  CreditScoreApplicantForm _creditScoreApplicationDetailsForm() {
    return CreditScoreApplicantForm(
      fullNameField: FullNameField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.fullNameController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
      ),
      panField: PanField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.panController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
      ),
      emailField: EmailField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.emailController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
      ),
    );
  }

  //bottom consent
  Padding _buildBottomConsentWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 24.h),
      child: GetBuilder<CreditReportLogic>(
          id: logic.STATELESS_CONSENT_CHECKBOX_ID,
          builder: (logic) {
            return ConsentWidget(
              horizontalPadding: 0,
              checkBoxColor: AppIconColors.primaryFocus,
              consentTextList: [
                RichTextModel(
                  text:
                  "I allow Kisetsu Saison Finance (India) Private Limited (KSF) to access my Experian D2C report to provide personalised financial insights. I also agree to Experian's ",
                  textStyle: AppTextStyles.bodyXSRegular(
                      color: AppTextColors.primaryNavyBlueHeader),
                ),
                RichTextModel(
                    text: "T&C",
                    onTap: () {
                      launchUrlString(
                        F.envVariables.experianTnCUrl,
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                    textStyle:
                        AppTextStyles.bodyXSRegular(color: AppTextColors.link))
              ],
              value: logic.isStatelessConsentChecked,
              onChanged: logic.onStatelessConsentValueChanged,
              color: darkBlueColor,
            );
          }),
    );
  }
}
