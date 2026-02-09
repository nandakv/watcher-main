import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../res.dart';
import '../../../../../theme/app_colors.dart';

class BrowserToAppBottomWidget extends StatelessWidget {
  final Widget? ctaButtonWidget;
  final String bottomTitleText;
  final String? bottomSubtitleText;
  const BrowserToAppBottomWidget(
      {Key? key,
      this.ctaButtonWidget,
      required this.bottomTitleText,
      this.bottomSubtitleText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Res.unlock_icon),
          _verticalSpacer(16),
          _bottomTitleText(),
          _verticalSpacer(8),
          _bottomSubtitleText(),
          _verticalSpacer(30),
          ctaButtonWidget ?? const SizedBox(),
        ],
      ),
    );
  }

  Widget _bottomTitleText() {
    if (bottomTitleText.isEmpty) {
      return const SizedBox();
    }
    return Text(
      bottomTitleText,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: navyBlueColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.7,
      ),
    );
  }

  SizedBox _verticalSpacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget _bottomSubtitleText() {
    if (bottomSubtitleText == null) {
      return const SizedBox();
    }
    return Text(
      bottomSubtitleText!,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: navyBlueColor,
        fontFamily: "Figtree",
        fontSize: 10,
        height: 1.4,
      ),
    );
  }
}
