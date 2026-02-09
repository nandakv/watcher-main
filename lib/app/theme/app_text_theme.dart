import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'package:flutter/material.dart';

TextStyle cardTextStyle(double fontsize) => TextStyle(
      color: exampleColor,
      fontSize: fontsize,
      fontWeight: FontWeight.bold,
    );

TextStyle overPassStyle(
        {double? fontsize,
        FontWeight? fontWeight,
        double? letterSpacing,
        Color? color,
        FontStyle? fontStyle}) =>
    GoogleFonts.montserrat(
        fontSize: fontsize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color,
        fontStyle: fontStyle ?? FontStyle.normal);

TextStyle darkBlueButtonTextStyle(bool enabled) => TextStyle(
    color: enabled ? darkBlueButtonTextColor : Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600);

TextStyle get signUpHeadingTextStyle => GoogleFonts.poppins(
      fontSize: 18,
      color: Colors.white,
      letterSpacing: 0.14,
      fontWeight: FontWeight.w600,
    );

TextStyle get errorRichTextStyle => GoogleFonts.montserrat(
    color: const Color(0xffE35959), fontSize: 11, letterSpacing: 0.08);

TextStyle poppinsTextStyle(TextStyle textStyle) {
  return GoogleFonts.poppins(textStyle: textStyle);
}

TextStyle hyperlinkStyle({double size = 10}) {
  return TextStyle(
    color: skyBlueColor,
    fontSize: size,
  );
}

TextStyle get homePageCardTitleTextStyle {
  return const TextStyle(
    color: goldColor,
    fontSize: 10,
    height: 1.4,
  );
}

TextStyle get appBarTextStyle => GoogleFonts.poppins(
      fontSize: 14,
      color: const Color(0xFF161742),
      letterSpacing: 0.11,
      fontWeight: FontWeight.w500,
    );

TextStyle get homePageCardHighlightedTitleTextStyle {
  return TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: yellowColor.withOpacity(0.85),
  );
}

TextStyle sectionHeaderTextStyle({Color color = navyBlueColor}) {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
  );
}
