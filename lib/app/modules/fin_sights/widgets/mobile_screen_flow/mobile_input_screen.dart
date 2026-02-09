import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../../../components/button.dart';
import '../../../../../components/svg_icon.dart';
import '../../../../../res.dart';
import '../../../../common_widgets/gradient_border_container.dart';
import '../../../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../components/top_navigation_bar.dart';
import '../finsights_exit_dialog.dart';

class MobileInputScreen extends StatefulWidget {
  const MobileInputScreen({super.key});

  @override
  State<MobileInputScreen> createState() => _MobileInputScreenState();
}

class _MobileInputScreenState extends State<MobileInputScreen> {
  var logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Get.bottomSheet(FinsightsExitDialog());
      },
      child: GetBuilder<FinSightsLogic>(
          id: logic.MOBILE_FLOW,
          builder: (logic) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _appBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalSpacer(32.h),
                            Text(
                              "Add mobile number to get started",
                              style: AppTextStyles.headingSMedium(
                                  color: darkBlueColor),
                            ),
                            VerticalSpacer(48.h),
                            _illustration(),
                            VerticalSpacer(40.h),
                            Text(
                              "Mobile Number",
                              style: AppTextStyles.headingXSMedium(
                                  color: appBarTitleColor),
                            ),
                            Text(
                              "Ensure this number is linked to your bank account for verification",
                              style: AppTextStyles.bodySMedium(
                                  color: secondaryDarkColor),
                            ),
                            _buildMobileNumberTextField(logic),
                            VerticalSpacer(40.h),
                            _infoContainer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalSpacer(32.h),
                  _ctaButton(),
                  VerticalSpacer(28.h),
                ],
              ),
            );
          }),
    );
  }

  GetBuilder<FinSightsLogic> _buildMobileNumberTextField(FinSightsLogic logic) {
    return GetBuilder<FinSightsLogic>(
        id: logic.MOBILE_NUMBER_TEXT_FIELD,
        builder: (logic) {
          return PrivoTextFormField(
            controller: logic.mobileNumberController,
            style: AppTextStyles.bodyMMedium(
              color: AppTextColors.neutralDarkBody,
            ),
            decoration: InputDecoration(
              prefix: Text(
                "+91 ",
                style: AppTextStyles.bodyMMedium(
                  color: AppTextColors.neutralDarkBody,
                ),
              ),
              counter: const SizedBox.shrink(),
            ),
            onChanged: (_) => logic.onMobileNumberChanged(),
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: logic.validateMobileNumber,
            id: logic.MOBILE_NUMBER_TEXT_FIELD,
          );
        });
  }

  TopNavigationBar _appBar() {
    return TopNavigationBar(
      title: "Finsights",
      onBackPressed: () async => await Get.bottomSheet(FinsightsExitDialog()),
    );
  }

  Widget _illustration() {
    return Center(
      child: SvgPicture.asset(
        Res.mobileEWallet,
        height: 192.h,
      ),
    );
  }

  Widget _infoContainer() {
    return GradientBorderContainer(
      width: 312.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SVGIcon(
                  size: SVGIconSize.small,
                  icon: Res.mobileInfo,
                ),
                HorizontalSpacer(8.w),
                Text(
                  "Why link mobile number?",
                  style: AppTextStyles.bodySSemiBold(
                      color: AppTextColors.primaryNavyBlueHeader),
                ),
              ],
            ),
            VerticalSpacer(9.h),
            _buildBulletPoint(
              "It helps us discover your bank accounts and decide which ones to link for FinSights.",
            ),
            VerticalSpacer(9.h),
            _buildBulletPoint(
              "Get personalised insights into your bank account effortlessly",
            ),
            VerticalSpacer(9.h),
            _buildBulletPoint(
              "No more juggling multiple apps—manage everything hassle-free!",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalSpacer(7.w),
        Container(
          margin: EdgeInsets.symmetric(vertical: 7.h),
          width: 4.w,
          height: 4.w,
          decoration: const BoxDecoration(
            color: AppBackgroundColors.primaryFocus,
            shape: BoxShape.circle,
          ),
        ),
        HorizontalSpacer(6.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySRegular(
              color: AppTextColors.neutralDarkBody,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ctaButton() {
    return GetBuilder<FinSightsLogic>(
      id: logic.MOBILE_NUMBER_CTA,
      builder: (logic) {
        return Center(
            child: Button(
          enabled: logic.isMobileNumberCTAEnabled,
          buttonSize: ButtonSize.large,
          buttonType: ButtonType.primary,
          onPressed: logic.onMobileScreenCTAClicked,
          isLoading: logic.initiatingWebview,
          title: "Continue",
        ));
      },
    );
  }
}
