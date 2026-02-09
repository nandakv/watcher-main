import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class OnboardingStepOfWidget extends StatelessWidget {
  const OnboardingStepOfWidget({
    Key? key,
    // required this.currentStep,
    // required this.totalStep,
    // required this.appState,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  // final String currentStep;
  // final String totalStep;
  // final String appState;
  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 30,
        ),
        // Text.rich(
        //   TextSpan(
        //     text: "Step $currentStep of $totalStep",
        //     children: [
        //       WidgetSpan(
        //         alignment: PlaceholderAlignment.middle,
        //         child: InkWell(
        //           onTap: () {
        //             //todo: Show a bottom sheet with onboarding progress stepper
        //           },
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 8),
        //             child: SvgPicture.asset(
        //               Res.infoIconSVG,
        //               width: 20,
        //               height: 20,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   style: const TextStyle(
        //     fontFamily: 'Figtree',
        //     color: darkBlueColor,
        //     fontWeight: FontWeight.w500,
        //     fontSize: 12,
        //   ),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: darkBlueColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subTitle != null) ...[
          const SizedBox(
            height: 40,
          ),
          Text(
            subTitle!,
            style: const TextStyle(
              color: primaryDarkColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
