import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/carousel_widget/carousel_widget.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/components/timeline_widget/timeline_widget.dart';

import '../../../components/button.dart';
import '../../../res.dart';
import 'referral_logic.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> with AfterLayoutMixin {
  final ReferralLogic logic = Get.put(ReferralLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          logic.onBackPressed();
          return false;
        },
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<ReferralLogic>(
                  id: logic.TOP_NAVIGATION_BAR_ID,
                  builder: (logic) {
                    return TopNavigationBar(
                      title:  logic.computeTitle(),
                      onBackPressed: ()=> logic.onBackPressed(),
                      trailing: InkWell(
                        onTap: logic.onFAQPressed,
                        child: const SVGIcon(
                          size: SVGIconSize.medium,
                          icon: Res.faqIcon,
                        ),
                      ),
                    );
                  }),
              Expanded(
                child: GetBuilder<ReferralLogic>(
                  id: logic.REFERRAL_SCREEN,
                  builder: (logic) {
                    switch (logic.referralPageState) {
                      case ReferralPageState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case ReferralPageState.success:
                        return SingleChildScrollView(
                          child: _bodyWidget(),
                        );
                      case ReferralPageState.tnc:
                        return _termsAndConditions();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        VerticalSpacer(32.h),
        Text(
          "Refer a friend",
          style: AppTextStyles.headingSSemiBold(
            color: AppTextColors.primaryNavyBlueHeader,
          ),
        ),
        VerticalSpacer(4.h),
        Text(
          "Financial freedom is better with friends.\nInvite them today and grow together!",
          style: AppTextStyles.bodyMMedium(
            color: AppTextColors.neutralBody,
          ),
          textAlign: TextAlign.center,
        ),
        VerticalSpacer(24.h),
        CarouselWidget(
          items: logic.carouselItems,
          widgetHeight: 243,
        ),
        VerticalSpacer(32.h),
        _myReferralsContainer(),
        VerticalSpacer(40.h),
        _timelineWidget(),
      ],
    );
  }

  Widget _myReferralsContainer() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.referralGiftBox),
                HorizontalSpacer(4.w),
                Text(
                  "My referrals",
                  style: AppTextStyles.bodyMMedium(
                    color: AppTextColors.neutralDarkBody,
                  ),
                ),
                HorizontalSpacer(4.w),
                InkWell(
                  onTap: logic.onMyReferralsInfoTapped,
                  child: const SVGIcon(
                    size: SVGIconSize.small,
                    icon: Res.informationFilledIcon,
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      logic.referralDataModel.referrals.length.toString(),
                      style: AppTextStyles.bodyMMedium(
                        color: AppTextColors.neutralDarkBody,
                      ),
                    ),
                    Text(
                      "Referrals joined",
                      style: AppTextStyles.bodyXSRegular(
                        color: AppBackgroundColors.neutralLightDisabled,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppBackgroundColors.primarySubtle,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Unique referral code",
                  style: AppTextStyles.bodySMedium(
                    color: AppTextColors.neutralBody,
                  ),
                ),
                VerticalSpacer(8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichTextWidget(
                        infoList: [
                          RichTextModel(
                            text: "Hi, use my code",
                            textStyle: AppTextStyles.bodySRegular(
                              color: AppTextColors.primaryNavyBlueHeader,
                            ),
                          ),
                          RichTextModel(
                            text: " ${logic.referralDataModel.referralCode} ",
                            textStyle: AppTextStyles.bodySSemiBold(
                              color: AppTextColors.primaryNavyBlueHeader,
                            ),
                          ),
                          RichTextModel(
                            text:
                                "to unlock exclusive features on Credit Saison India app",
                            textStyle: AppTextStyles.bodySRegular(
                              color: AppTextColors.primaryNavyBlueHeader,
                            ),
                          ),
                        ],
                      ),
                    ),
                    HorizontalSpacer(4.w),
                    InkWell(
                      onTap: logic.onCopyTapped,
                      child: const SVGIcon(
                        size: SVGIconSize.medium,
                        icon: Res.copyIcon,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _timelineWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How it works",
            style: AppTextStyles.headingSMedium(
              color: AppTextColors.neutralBody,
            ),
          ),
          VerticalSpacer(16.h),
          TimelineWidget(steps: logic.timelineSteps),
          VerticalSpacer(16.h),
          InkWell(
            onTap: logic.onTapTAC,
            child: Text(
              "Read Terms and Conditions",
              style: AppTextStyles.bodySRegular(
                color: AppTextColors.primaryInverseTitle,
              ),
            ),
          ),
          VerticalSpacer(40.h),
          GetBuilder<ReferralLogic>(
            id: logic.BUTTON_ID,
            builder: (logic) {
              return Button(
                title: "Refer now",
                buttonSize: ButtonSize.large,
                isLoading: logic.isButtonLoading,
                buttonType: ButtonType.primary,
                onPressed: logic.setAppInviteTemplate,
              );
            },
          ),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }

  Widget _termsAndConditions() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer(32.h),
          Text(
            "Terms and Conditions",
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.primaryNavyBlueHeader),
          ),
          VerticalSpacer(16.h),
          _termsAndConditionsItems(),
        ],
      ),
    );
  }
  Widget _termsAndConditionsItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(logic.termsAndConditions.length, (index) {
        final itemText = logic.termsAndConditions[index];
        final isLastItem = index == logic.termsAndConditions.length - 1;

        if (isLastItem) {
          const tapText = "Privacy Policy";
          final textParts = itemText.split(tapText);

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• ",
                  style: AppTextStyles.bodySRegular(color: grey700),
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySRegular(color: grey700),
                      children: [
                        TextSpan(text: textParts[0]),
                        TextSpan(
                          text: tapText,
                          style: AppTextStyles.bodySRegular(color: AppTextColors.primaryInverseTitle),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              logic.onPrivacyPolicyTapped();
                            },
                        ),
                        TextSpan(text: textParts.length > 1 ? textParts[1] : ""),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: AppTextStyles.bodySRegular(color: grey700),
              ),
              Flexible(
                child: Text(
                  itemText,
                  style: AppTextStyles.bodySRegular(color: grey700),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
