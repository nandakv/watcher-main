import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/app_stepper.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../modules/on_boarding/mixins/app_form_mixin.dart';
import 'onboarding_timeline_widget_logic.dart';

class OnBoardingTimelineWidget extends StatefulWidget {
  const OnBoardingTimelineWidget({
    Key? key,
    this.appState,
    this.removeButtons = false,
    this.titleText,
    this.loanProductCode = LoanProductCode.clp,
    this.isPartnerFlow = false,
  }) : super(key: key);

  final int? appState;
  final bool removeButtons;
  final Widget? titleText;
  final LoanProductCode loanProductCode;
  final bool isPartnerFlow;

  @override
  State<OnBoardingTimelineWidget> createState() =>
      _OnBoardingTimelineWidgetState();
}

class _OnBoardingTimelineWidgetState extends State<OnBoardingTimelineWidget>
    with AfterLayoutMixin {
  final logic = Get.put(OnboardingTimelineWidgetLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingTimelineWidgetLogic>(
      builder: (logic) {
        switch (logic.onboardingTimelineWidgetState) {
          case OnboardingTimelineWidgetState.loading:
            return const SkeletonLoadingWidget(
              skeletonLoadingType: SkeletonLoadingType.homeBottom,
            );
          case OnboardingTimelineWidgetState.success:
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.titleText != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: widget.titleText!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                AppStepper(
                  currentStep: logic.currentAppStepperState,
                  appSteps: logic.stepList,
                  isCurrentStepBordered: true,
                ),
              ],
            );
          case OnboardingTimelineWidgetState.error:
            return _errorWidget();
        }
      },
    );
  }

  Container _errorWidget() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            )
          ]),
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Something Went Wrong"),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GradientButton(
              onPressed: () => logic.onAfterLayout(
                widget.removeButtons,
                appState: widget.appState,
                loanProductCode: widget.loanProductCode,
                isPartnerFlow: widget.isPartnerFlow,
              ),
              title: "Retry",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(
      widget.removeButtons,
      appState: widget.appState,
      loanProductCode: widget.loanProductCode,
      isPartnerFlow: widget.isPartnerFlow,
    );
  }
}

class StepWidget extends StatelessWidget {
  const StepWidget(
    this.text, {
    Key? key,
    this.isSuccess = false,
    this.inBetween = false,
    this.removeButton = false,
    this.subSteps = const [],
    this.stepInfo = "",
    this.buttonText = "",
  }) : super(key: key);

  final String text;
  final List<String> subSteps;
  final String buttonText;
  final bool isSuccess;
  final bool inBetween;
  final bool removeButton;
  final String stepInfo;

  @override
  Widget build(BuildContext context) {
    Color stateColor = (isSuccess || inBetween) ? greenColor : darkBlueColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: _titleTextStyle()),
        verticalSpacer(4),
        Row(
          children: subSteps
              .map((e) => _subStepWidget(
                    text: e,
                    isLast: subSteps.last == e,
                    color: stateColor,
                  ))
              .toList(),
        ),
        Text(stepInfo, style: _infoTextStyle()),
        verticalSpacer(14),
      ],
    );
  }

  Widget _subStepWidget({
    required bool isLast,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: color,
            )),
        if (!isLast) _arrowWidget(),
      ],
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: goldColor,
      fontSize: 14,
      letterSpacing: 0.16,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _infoTextStyle() {
    return const TextStyle(
      color: secondaryDarkColor,
      fontSize: 10,
      height: 1.3,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _arrowWidget() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SvgPicture.asset(
        Res.rightDirectionArrow,
      ),
    );
  }
}
