import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';

import '../../res.dart';
import '../theme/app_colors.dart';

class OnBoardingStepWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function() onInfoTap;
  final String title;
  final bool showStepOfText;

  const OnBoardingStepWidget(
      {Key? key,
      required this.currentStep,
      required this.totalSteps,
      required this.onInfoTap,
      this.showStepOfText = true,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showStepOfText) ...[
          Row(
            children: [
              _stepTextWidget(),
              horizontalSpacer(10),
              _infoIcon(),
            ],
          ),
        ],
        verticalSpacer(6),
        _titleWidget(),
      ],
    );
  }

  Widget _stepTextWidget() {
    return Text(
      "Step $currentStep of $totalSteps",
      style: const TextStyle(
        color: darkBlueColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: darkBlueColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _infoIcon() {
    return InkWell(
      onTap: onInfoTap,
      child: SvgPicture.asset(
        Res.infoIconSVG,
        height: 16,
        width: 16,
      ),
    );
  }
}
