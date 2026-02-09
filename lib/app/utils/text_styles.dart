import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

extension TextStyles on Text {
  Text bodyXSRegular({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: color,
    ),
  );

  Text bodyXSMedium({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: color,
      height: 14 / 10,
      fontFamily: 'Figtree',
    ),
  );

  Text bodyXSSemiBold({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 10,
      color: color,
      height: 14 / 10,
    ),
  );

  Text bodySRegular({required Color color}) => Text(
    data!,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: color,
      fontFamily: 'Figtree',
    ),
  );

  Text bodyLSemiBold({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );

  Text headingLSemiBold({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontSize: 24,
      height: 34 / 24,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );

  Text bodyMMedium({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color,
      height: 20 / 14,
    ),
  );


  Text bodyLMedium({required Color color}) => Text(
    data!,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: color,
      height: 22 / 16,
    ),
  );

  Text headingSMedium({required Color color}) => Text(
    data!,
    textAlign: textAlign,
    style: GoogleFonts.poppins(
      fontSize: 16,
      height: 22 / 16,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );

  Text displayM({
    bool poppins = false,
    bool addShadow = false,
    required Color color,
  }) {
    double fontSize = 40;
    FontWeight fontWeight = FontWeight.w600;
    double lineHeight = 56;
    List<Shadow>? shadows = addShadow
        ? [
      const Shadow(
        color: lightGreyColor,
        offset: Offset(2, 2),
      )
    ]
        : null;
    return Text(
      data!,
      style: poppins
          ? GoogleFonts.poppins(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        height: lineHeight / fontSize,
        shadows: shadows,
      )
          : TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        height: lineHeight / fontSize,
        shadows: shadows,
      ),
    );
  }
}