import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

enum AppStepOvalPosition { top, bottom }

class AppStep {
  late Widget child;

  ///[inBetweenChild] is the state when it comes between two success
  ///in progress state. for e.g.: when app stepper state is 2.5
  late Widget? inBetweenChild;
  late Widget? successChild;

  ///[stepOvalPosition] is the position of the oval to be placed
  ///in top or bottom of the vertical line
  late AppStepOvalPosition stepOvalPosition;

  AppStep({
    required this.child,
    this.inBetweenChild,
    this.successChild,
    this.stepOvalPosition = AppStepOvalPosition.top,
  });
}

class AppStepper extends StatelessWidget {
  const AppStepper(
      {Key? key,
      required this.currentStep,
      required this.appSteps,
      this.isCurrentStepBordered = true,
      this.ovalSize = const Size(16, 16),
      this.lineWidth = 0.5,
      this.horizantalPadding = 24})
      : super(key: key);

  final double currentStep;
  final List<AppStep> appSteps;
  final Size ovalSize;
  final bool isCurrentStepBordered;
  final double lineWidth;
  final double horizantalPadding;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: appSteps.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AppStepperItem(
            appStep: appSteps[index],
            currentStep: currentStep,
            index: index,
            isLast: index == appSteps.length - 1,
            isCurrentStepBordered: isCurrentStepBordered,
            ovalHeight: ovalSize.height,
            ovalWidth: ovalSize.width,
            lineWidth: lineWidth,
          );
        },
      ),
    );
  }
}

class AppStepperItem extends StatelessWidget {
  const AppStepperItem({
    Key? key,
    required this.appStep,
    this.currentStep = 0,
    required this.index,
    required this.isLast,
    required this.isCurrentStepBordered,
    required this.ovalHeight,
    required this.ovalWidth,
    required this.lineWidth,
  }) : super(key: key);

  final AppStep appStep;
  final double currentStep;
  final int index;
  final bool isLast;
  final double ovalHeight;
  final double ovalWidth;
  final bool isCurrentStepBordered;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerticalProgressLine(
            currentStep: currentStep,
            index: index,
            isLastStep: isLast,
            isCurrentStepBordered: isCurrentStepBordered,
            ovalWidth: ovalWidth,
            ovalHeight: ovalHeight,
            lineWidth: lineWidth,
          ),
          horizontalSpacer(16),
          Expanded(child: _computeSuccessWidgets()),
        ],
      ),
    );
  }

  Widget _computeSuccessWidgets() {
    return appStep.child;
    // return currentStep == 0
    //     ? appStep.child
    //
    //     ///below is the computation
    //     ///to show the success widget
    //     : (index + 1.5).isLowerThan(currentStep)
    //         ? appStep.successChild ?? appStep.child
    //
    //         ///below is the computation to check
    //         /// for the in-between widget
    //         : ((index + 1.5) == currentStep && appStep.inBetweenChild != null)
    //             ? appStep.inBetweenChild!
    //             : appStep.child;
  }
}

///[VerticalProgressLine] widget will have the oval and the vertical line
class VerticalProgressLine extends StatelessWidget {
  const VerticalProgressLine(
      {Key? key,
      required this.currentStep,
      required this.index,
      required this.isLastStep,
      required this.isCurrentStepBordered,
      required this.ovalHeight,
      required this.ovalWidth,
      required this.lineWidth})
      : super(key: key);

  final double currentStep;
  final int index;
  final bool isLastStep;
  final bool isCurrentStepBordered;
  final double ovalHeight;
  final double ovalWidth;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLastStep) ...[
          _ovalWidget(ovalHeight: ovalHeight, ovalWidth: ovalWidth)
        ] else ...[
          if (currentStep > index) ...[
            SvgPicture.asset(
              Res.greenCheckStepper,
              width: 18,
              height: 18,
            ),
          ] else
            _ovalWidget(ovalHeight: ovalHeight, ovalWidth: ovalWidth),
          _verticalLineWidget(),
        ]
      ],
    );
  }

  Expanded _verticalLineWidget() {
    return Expanded(
      child: Container(
        width: lineWidth,
        color: _computeColor(),
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
    );
  }

  Color _computeColor() {
    if ((currentStep != 0 && index < currentStep)) {
      return Colors.green;
    }
    return lightGrayColor;
  }

  Widget _ovalWidget({required double ovalHeight, required double ovalWidth}) {
    return Container(
      height: ovalHeight,
      width: ovalWidth,
      decoration: BoxDecoration(
        color: isCurrentStepBordered ? Colors.white : darkBlueColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(25),
        border: isCurrentStepBordered
            ? Border.all(
                color: darkBlueColor,
                width: 1,
              )
            : null,
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: const TextStyle(
            fontSize: 10,
            color: darkBlueColor,
          ),
        ),
      ),
    );
  }
}
