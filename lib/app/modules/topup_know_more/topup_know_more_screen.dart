import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/app_stepper.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_timeline_widget/onboarding_timeline_widget.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_app_bar.dart';
import 'package:privo/app/modules/on_boarding/widgets/consent_widget.dart';
import 'package:privo/app/modules/topup_know_more/model/topup_eligibility_details.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class TopUpKnowMoreScreen extends StatelessWidget {
  TopUpKnowMoreScreen({super.key});

  final TopUpKnowMoreLogic logic = Get.find<TopUpKnowMoreLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const KnowMoreAppBar(),
            Expanded(child: _computeBody()),
            if (logic.arguments.isEligible) _consentWidget(),
            _ctaButton(),
          ],
        ),
      ),
    );
  }

  Widget _consentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
      child: GetBuilder<TopUpKnowMoreLogic>(
          id: logic.CONSENT_CHECKBOX_ID,
          builder: (context) {
            return ConsentWidget(
              consentTextList: [
                RichTextModel(
                  text:
                      "I authorise Kisetsu Saison Finance India Private Limited to perform my Credit check & run a PAN validation through NSDL and use 3rd party systems for any additional verification.",
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.08,
                    color: Color(0xff727272),
                  ),
                )
              ],
              value: logic.isConsentChecked,
              onChanged: logic.onConsentValueChanged,
            );
          }),
    );
  }

  Widget _ctaButton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 32.0, right: 32, bottom: 32, top: 16),
      child: GetBuilder<TopUpKnowMoreLogic>(
          id: logic.BUTTON_ID,
          builder: (logic) {
            return GradientButton(
              enabled: logic.isConsentChecked,
              onPressed: logic.onButtonTapped,
              title: logic.computeButtonTitle(),
              isLoading: logic.isButtonLoading,
            );
          }),
    );
  }

  Widget _computeBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _topWidget(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: _bottomWidget(),
          ),
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    if (logic.arguments.isEligible) {
      return _eligileBottomWidget();
    }
    return _nonEligibleBottomWidget();
  }

  Widget _nonEligibleBottomWidget() {
    return Column(
      children: [
        _whatIsTopUpLoanSection(),
        const VerticalSpacer(48),
        _eligibleInfoWidget(),
      ],
    );
  }

  Widget _eligileBottomWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _howTopUpLoanWorksSection(),
        const VerticalSpacer(48),
        _getStartedSection(),
      ],
    );
  }

  Widget _howTopUpLoanWorksSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("How does a Top-up loan work?"),
        const VerticalSpacer(24),
        _howTopUpWorksStepper(),
        const VerticalSpacer(8),
        _howTopUpWorksIllustration(),
      ],
    );
  }

  Widget _howTopUpWorksIllustration() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        children: [
          _illustrationTopWidget(),
          const VerticalSpacer(6),
          _illustrationBottomWidget()
        ],
      ),
    );
  }

  Widget _illustrationBottomWidget() {
    return Container(
      decoration: BoxDecoration(
        color: lightSkyBlueColor,
        border: _containerBorder,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "New Loan Amount",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: primaryDarkColor,
            ),
          ),
          Text(
            "₹5,50,000",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: primaryDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _illustrationTopWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: _containerBorder,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _treeIllustrationWidget(
            title: "Outstanding Balance",
            imagePath: Res.topupOutstandingBalanceTree,
            amount: "₹1,50,000",
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              Res.rightArrow,
              color: secondaryDarkColor,
            ),
          ),
          _treeIllustrationWidget(
            imagePath: Res.topupAmountTree,
            title: "Top Up Amount",
            amount: "₹5,50,000",
          ),
        ],
      ),
    );
  }

  BoxBorder get _containerBorder => Border.all(
        color: borderSkyBlueColor,
        width: 0.4,
      );

  Widget _howTopUpWorksStepper() {
    return AppStepper(
      currentStep: 0,
      appSteps: [
        AppStep(
          child: const StepWidget(
            "Receive Offer",
            stepInfo: "You receive a pre-approved offer for a Top-up loan",
          ),
        ),
        AppStep(
          child: const StepWidget(
            "Apply for Loan",
            stepInfo: "You apply for the top-up loan in a few simple steps",
          ),
        ),
        AppStep(
          child: const StepWidget(
            "New Loan Amount",
            stepInfo:
                "Your existing loan will be closed and the top-up loan amount you choose will become your new loan balance",
          ),
        )
      ],
      isCurrentStepBordered: true,
    );
  }

  Widget _getStartedSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Steps to get started"),
        const VerticalSpacer(24),
        _topupStepperWidget(),
      ],
    );
  }

  Widget _topupStepperWidget() {
    return AppStepper(
      currentStep: 0,
      appSteps: [
        AppStep(
          child: const StepWidget(
            "Basic Details",
            subSteps: ["Bank Statement Verification", "Address Details"],
          ),
        ),
        AppStep(
          child: const StepWidget(
            "Final Offer",
            subSteps: ["Final offer", "Penny Drop", "E-mandate"],
          ),
        ),
        AppStep(
          child: const StepWidget(
            "Disbursal",
            subSteps: ["Agreement letter", "Disbursal"],
          ),
        )
      ],
      isCurrentStepBordered: true,
    );
  }

  Widget _topWidget() {
    return Container(
      decoration: BoxDecoration(
        color: skyBlueColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logic.arguments.isEligible) _titleWidget(),
            const VerticalSpacer(12),
            SvgPicture.asset(Res.knowMoreTopUp)
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return RichTextWidget(
      textAlign: TextAlign.center,
      infoList: [
        RichTextModel(
          text: "Top Up Loan Amount",
          textStyle: GoogleFonts.poppins(
            color: navyBlueColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        RichTextModel(
          text: "\n\nYou are eligible for a top-up amount upto\n",
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.6,
            color: secondaryDarkColor,
          ),
        ),
        RichTextModel(
          text: "₹ 10,00,000",
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 2.2,
            color: primaryDarkColor,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text, {double fontSize = 12}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: navyBlueColor,
        fontSize: fontSize,
        height: 1.4,
      ),
    );
  }

  Widget _eligibleInfoWidget() {
    return Column(
      children: [
        _sectionTitle("How to become eligible for a top-up loan?"),
        const VerticalSpacer(16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: logic.topUpEligibilityDetailsList
                .map((e) => _topUpEligibilityTile(e))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _topUpEligibilityTile(TopUpEligibilityDetails eligibilityDetails) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GradientBorderContainer(
        color: lightSkyBlueColor,
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  eligibilityDetails.iconPath,
                  height: 20,
                  width: 20,
                ),
              ),
              const VerticalSpacer(8),
              Text(
                eligibilityDetails.title,
                style: const TextStyle(
                  fontSize: 10,
                  color: darkBlueColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _whatIsTopUpLoanSection() {
    return Column(
      children: [
        _sectionTitle("What is a Top-up Loan?", fontSize: 16),
        const VerticalSpacer(8),
        const Text(
          "A top-up loan is an additional credit that can be availed of over and above an existing loan and when opting for a balance transfer. A top-up loan does not come with any end-use restrictions and requires minimum",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: secondaryDarkColor,
          ),
        )
      ],
    );
  }

  Widget _treeIllustrationWidget(
      {required String imagePath,
      required String title,
      required String amount}) {
    return Column(
      children: [
        SvgPicture.asset(imagePath),
        const VerticalSpacer(8),
        RichTextWidget(
          textAlign: TextAlign.center,
          infoList: [
            RichTextModel(
                text: "$title\n",
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  height: 1.7,
                  color: primaryDarkColor,
                )),
            RichTextModel(
              text: amount,
              textStyle: const TextStyle(
                color: primaryDarkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
