import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/aa_stand_alone_journey/aa_stand_alone_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../../components/button.dart';
import '../../../../res.dart';
import '../../../common_widgets/bank_details_column_widget.dart';
import 'aa_stand_alone_bank_account_model.dart';

class AAStandAloneInitiationScreen extends StatelessWidget {
  final AAStandAloneBankReport aaStandAloneBankReport;

  AAStandAloneInitiationScreen({super.key, required this.aaStandAloneBankReport});

  final logic = Get.find<AAStandAloneLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteTextColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Expanded(child: _buildBodyContent()), _bottomWidget()],
      ),
    );
  }

  Column _bottomWidget() {
    return Column(
      children: [
        _serviceProviderText(),
        VerticalSpacer(18.h),
        _continueButton(),
        VerticalSpacer(32.h)
      ],
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SvgPicture.asset(
            Res.evaluatingBankDetailsImgSvg,
            width: 178.w,
            height: 164.h,
          ),
          _buildTitleAndDescription(),
          _benefitsSectionWidget(),
          VerticalSpacer(12.h),
          _buildKnowMore(),
          _bankAccountDetails(),
        ],
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      children: [
        VerticalSpacer(24.h),
        Text("Provide account consent",
            style: AppTextStyles.headingSMedium(color: blue1200)),
        VerticalSpacer(8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 41.w),
          child: Text(
            "Borrow with exclusive benefits and become eligible for your future loans",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(color: blue1200),
          ),
        )
      ],
    );
  }

  Widget _benefitsSectionWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _benefitItem(img: Res.loans, title: "Higher credit \nlimits"),
          _benefitItem(img: Res.finance, title: "Access bank \ninsights"),
          _benefitItem(img: Res.clock2, title: "Faster future \nloans"),
        ],
      ),
    );
  }

  Widget _benefitItem({required String img, required String title}) {
    return Column(
      children: [
        VerticalSpacer(24.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: preRegistrationEnabledGradientColor2.withOpacity(.10),
            border: Border.all(color: const Color(0xFF229ACE), width: 1.w),
            borderRadius: BorderRadius.circular(28),
          ),
          child: SvgPicture.asset(img),
        ),
        VerticalSpacer(4.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyXSSemiBold(color: blue1200),
        ),
      ],
    );
  }

  Widget _buildKnowMore() {
    return InkWell(
      onTap: () {
        logic.onKnowMoreClicked();
      },
      child: Text(
        "Know more",
        style: AppTextStyles.bodyXSMedium(color: blue600),
      ),
    );
  }

  Widget _bankAccountDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          VerticalSpacer(24.h),
          Text(
            "Bank account details",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySSemiBold(color: navyBlueColor),
          ),
          VerticalSpacer(8.h),
          Container(
            decoration: _containerDecoration(),
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: BankDetailsColumnWidget(
                bankName: aaStandAloneBankReport.bankName,
                accountNumber: aaStandAloneBankReport.accountNumber,
                ifscCode: aaStandAloneBankReport.ifscCode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceProviderText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Account aggregator is enabled by",
          style: TextStyle(fontSize: 12, color: secondaryDarkColor),
        ),
        SizedBox(
          width: 4.w,
        ),
        SvgPicture.asset(
          Res.sahamatiLogo1,
          height: 16.h,
          width: 56.w,
        ),
      ],
    );
  }

  Widget _continueButton() {
    return Button(
      buttonType: ButtonType.primary,
      buttonSize: ButtonSize.large,
      title: "Continue",
      onPressed: () {
        logic.onBankConsentContinueCTA();
      },
      fillWidth: true,
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: preRegistrationEnabledGradientColor3,
        width: 0.6.w,
      ),
      borderRadius: BorderRadius.circular(8.w),
    );
  }
}
