import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

enum HorizontalTimelineStepWidgetState { active, inActive, success, failure }

class HorizontalTimelineStepWidget extends StatelessWidget {
  const HorizontalTimelineStepWidget({
    Key? key,
    required this.label,
    required this.step,
    required this.state,
    this.circleSize = 16,
    this.isLastStep = false,
    this.dividerColor = secondaryDarkColor,
    this.textColor = darkBlueColor,
    this.circleColor = darkBlueColor,
    this.circleTextColor = darkBlueColor,
  }) : super(key: key);

  final String label;
  final String step;
  final HorizontalTimelineStepWidgetState state;
  final double circleSize;
  final bool isLastStep;
  final Color dividerColor;
  final Color textColor;
  final Color circleColor;
  final Color circleTextColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isLastStep ? 0 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyXSRegular(color: textColor),
            // style: TextStyle(
            //   color: textColor,
            //   fontSize: 10,
            //   fontWeight: FontWeight.w400,
            // ),
          ),
          const SizedBox(
            width: 6,
          ),
          _computeCircleWidget(),
          if (!isLastStep) ...[
            Expanded(
              child: Divider(
                indent: 6,
                endIndent: 6,
                color: state == HorizontalTimelineStepWidgetState.success
                    ? verifiedGreenColor
                    : dividerColor,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _computeCircleWidget() {
    switch (state) {
      case HorizontalTimelineStepWidgetState.active:
        return _activeWidget();
      case HorizontalTimelineStepWidgetState.inActive:
        return _notActiveWidget();
      case HorizontalTimelineStepWidgetState.success:
        return _successWidget();
      case HorizontalTimelineStepWidgetState.failure:
        return _failedWidget();
    }
  }

  Widget _successWidget() {
    return Center(
      child: SvgPicture.asset(
        Res.success_icon,
        width: circleSize,
        height: circleSize,
      ),
    );
  }

  Widget _failedWidget() {
    return SvgPicture.asset(
      Res.warning,
      height: circleSize,
      width: circleSize,
    );
  }

  Widget _notActiveWidget() {
    return Container(
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: circleColor,
          width: 0.8,
        ),
      ),
      child: Center(
        child: Text(
          step,
          style: TextStyle(
            color: circleTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _activeWidget() {
    return Container(
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        color: verifiedGreenColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          const CircularProgressIndicator(
            strokeWidth: 0.8,
            value: 0.75,
            color: verifiedGreenColor,
          ),
          Center(
            child: Text(
              step,
              style: const TextStyle(
                color: verifiedGreenColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
