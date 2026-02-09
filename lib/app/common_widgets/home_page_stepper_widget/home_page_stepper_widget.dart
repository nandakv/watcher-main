import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../horizontal_timeline_step_widget.dart';
import 'home_page_stepper_logic.dart';
import 'model/home_page_stepper_model.dart';

class HomePageStepperWidget extends StatefulWidget {
  final HomePageStepperModel homePageStepperModel;
  const HomePageStepperWidget({
    Key? key,
    required this.homePageStepperModel,
  }) : super(key: key);

  @override
  State<HomePageStepperWidget> createState() => _HomePageStepperWidgetState();
}

class _HomePageStepperWidgetState extends State<HomePageStepperWidget> {
  final logic = Get.put(HomePageStepperLogic());

  @override
  void initState() {
    logic.init(
        appState: widget.homePageStepperModel.appState,
        loanProductCode: widget.homePageStepperModel.loanProductCode,
        isPartnerFlow: widget.homePageStepperModel.isPartnerFlow,
        isBrowserToAppFlow: widget.homePageStepperModel.isBrowserToAppFlow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _timelineStep(
            label: logic.stepOneLabel, step: "1", state: logic.stepOneState),
        _divider(
          color: _computeDividerColor(stepState: logic.stepOneState),
        ),
        _timelineStep(
            label: logic.stepTwoLabel, step: "2", state: logic.stepTwoState),
        _divider(
          color: _computeDividerColor(stepState: logic.stepTwoState),
        ),
        _timelineStep(
            label: logic.stepThreeLabel,
            step: "3",
            state: logic.stepThreeState),
      ],
    );
  }

  Color _computeDividerColor(
      {required HorizontalTimelineStepWidgetState stepState}) {
    return stepState == HorizontalTimelineStepWidgetState.success
        ? greenColor
        : navyBlueColor;
  }

  Widget _timelineStep(
      {required String label,
      required String step,
      required HorizontalTimelineStepWidgetState state}) {
    return HorizontalTimelineStepWidget(
      label: label,
      step: step,
      textColor: navyBlueColor,
      circleColor: navyBlueColor,
      dividerColor: navyBlueColor,
      circleTextColor: navyBlueColor,
      state: state,
      isLastStep: true,
    );
  }

  Widget _divider({required Color color}) {
    return Expanded(
      child: Divider(
        indent: 6,
        endIndent: 6,
        color: color,
        height: 1.6,
      ),
    );
  }
}
