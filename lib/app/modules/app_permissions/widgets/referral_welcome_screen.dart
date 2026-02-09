import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class ReferralWelcomeScreen extends StatelessWidget {
  ReferralWelcomeScreen({super.key});

  final List<BenefitItem> benefits = [
    BenefitItem(
        title: "Credit Score",
        subTitle: "Monitor and check your credit score for free",
        icon: Res.referralCreditScore),
    BenefitItem(
        title: "Business Loan",
        subTitle: "Discover offers and access easy credit",
        icon: Res.referralBusiness),
    BenefitItem(
        title: "EMI Calculator",
        subTitle: "Plan better with repayment breakdowns",
        icon: Res.referralEmiCalculator),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _closeButton(),
              _topWidget(),
              SvgPicture.asset(Res.welcomeCelebration),
              VerticalSpacer(32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.h),
                child: Text(
                  "Here’s what we have for you:",
                  style: AppTextStyles.headingXSMedium(
                      color: AppTextColors.primaryNavyBlueHeader),
                ),
              ),
              ...List.generate(
                  benefits.length, (index) => _benefitsItem(benefits[index])),
              VerticalSpacer(36.h),
              Center(
                child: Button(
                  buttonType: ButtonType.primary,
                  buttonSize: ButtonSize.large,
                  title: "Let’s go",
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME_SCREEN);
                  },
                ),
              ),
              VerticalSpacer(32.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding _topWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          VerticalSpacer(48.h),
          Text(
            "Welcome to Credit Saison India!",
            style: AppTextStyles.headingSSemiBold(
                color: AppTextColors.primaryNavyBlueHeader),
          ),
          Text(
            "You’ve successfully unlocked exclusive financial benefits",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMMedium(color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(16.h),
          Container(
            decoration: BoxDecoration(
              color: AppBackgroundColors.primarySubtle,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 40.w),
            child: Text(
              "Your friend got you early access!",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMMedium(
                  color: AppTextColors.neutralDarkBody),
            ),
          ),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

  Widget _benefitsItem(BenefitItem benefitItem) {
    return Padding(
      padding: EdgeInsets.only(right: 32.w, left: 32.w, top: 16.h),
      child: Row(
        children: [
          SvgPicture.asset(benefitItem.icon),
          HorizontalSpacer(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                benefitItem.title,
                style: AppTextStyles.headingXSMedium(
                    color: AppTextColors.brandBlueTitle),
              ),
              Text(
                benefitItem.subTitle,
                style: AppTextStyles.bodySRegular(
                    color: AppTextColors.neutralBody),
              )
            ],
          )
        ],
      ),
    );
  }

  Padding _closeButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, right: 16.w),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            Res.close_mark_svg,
          ),
        ),
      ),
    );
  }
}

class BenefitItem {
  String title;
  String subTitle;
  String icon;

  BenefitItem(
      {required this.title, required this.subTitle, required this.icon});
}
