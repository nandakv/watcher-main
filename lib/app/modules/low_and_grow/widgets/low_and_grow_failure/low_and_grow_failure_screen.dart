import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../res.dart';

class LowAndGrowFailureScreen extends StatelessWidget {
  const LowAndGrowFailureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xffFFF3EB),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(result: true),
              icon: SvgPicture.asset(Res.lowGrowCancelSign),
            ),
          ),
          failureImageAndTitleWidget(),
          const SizedBox(
            height: 100,
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(
              "Go to Home",
              style: _textButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget failureImageAndTitleWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Res.lowGrowFailureImg),
        const SizedBox(
          height: 25,
        ),
        Text("No longer available",
            style: _titleTextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
              "Based on your credit assessment, we are unable to provide you with an upgrade at this time",
              textAlign: TextAlign.center,
              style: _subTitleTextStyle),
        ),
      ],
    );
  }

  TextStyle _textButtonStyle() {
    return const TextStyle(
      decoration: TextDecoration.underline,
      letterSpacing: 0.47,
      color: skyBlueColor,
      fontSize: 12,
    );
  }

  TextStyle _titleTextStyle(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xff1D478E),
    );
  }

  TextStyle get _subTitleTextStyle {
    return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: Color(0xff1D478E),
        fontFamily: 'Figtree');
  }
}
