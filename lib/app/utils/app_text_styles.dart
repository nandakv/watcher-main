import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

class AppTextStyles {
  static TextStyle bodyXSRegular({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10.sp,
      color: color,
      letterSpacing: 0.05,
      height: 14.sp / 10.sp,
      fontFamily: "Figtree",
    );
  }

  static TextStyle bodyXSLight({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 10.sp,
      letterSpacing: 0.05,
      color: color,
      height: 14.sp / 10.sp,
    );
  }

  static TextStyle bodyXSMedium({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10.sp,
      color: color,
      letterSpacing: 0.05,
      height: 14.sp / 10.sp,
    );
  }

  static TextStyle bodyXSSemiBold({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 10.sp,
      letterSpacing: 0.05,
      color: color,
      height: 14.sp / 10.sp,
      fontFamily: "Figtree",
    );
  }

  static TextStyle bodySRegular({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      height: 17.sp / 12.sp,
      letterSpacing: 0.05,
      color: color,
      fontFamily: 'Figtree',
    );
  }

  static TextStyle bodySMedium({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: color,
      letterSpacing: 0.05,
      height: 16.sp / 12.sp,
    );
  }

  static TextStyle bodySSemiBold({required Color color}) {
    return GoogleFonts.figtree(
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      color: color,
      letterSpacing: 0.05,
      height: 16.h / 12.sp,
    );
  }

  static TextStyle bodyMRegular({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      color: color,
      letterSpacing: 0.05,
      height: 20.sp / 14.sp,
      fontFamily: 'Figtree',
    );
  }

  static TextStyle bodyLSemiBold({required Color color}) {
    return TextStyle(
      fontSize: 16.sp,
      height: 22.sp / 16.sp,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle bodyMMedium({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
      color: color,
      letterSpacing: 0.05,
      height: 20.sp / 14.sp,
    );
  }

  static TextStyle bodyMLight({required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 14.sp,
      color: color,
      letterSpacing: 0.05,
      height: 20.sp / 14.sp,
    );
  }

  static TextStyle headingSMedium({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 16.sp,
      height: 22.sp / 16.sp,
      color: color,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle headingSSemiBold({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 16.sp,
      height: 22.sp / 16.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingXSSemiBold({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 12.sp,
      height: 16.sp / 12.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingXSMedium({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 12.sp,
      height: 22.sp / 12.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle headingXSBold({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 12.sp,
      letterSpacing: 0.05,
      height: 22.sp / 12.sp,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingMedium({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 20.sp,
      height: 28.sp / 20.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle headingMSemiBold({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 20.sp,
      letterSpacing: 0.05,
      height: 28.sp / 20.sp,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingLarge({required Color color}) {
    return TextStyle(
      fontSize: 24.sp,
      height: 34.sp / 24.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle headingLSemiBold({required Color color}) {
    return TextStyle(
      fontSize: 24.sp,
      height: 34.sp / 24.sp,
      color: color,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingXLSemiBold({required Color color}) {
    return TextStyle(
      fontSize: 32.sp,
      height: 44.sp / 32.sp,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle poppinsHeadingXL({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 32.sp,
      height: 34.sp / 32.sp,
      color: color,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle poppinsHeadingXLMedium({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 32.sp,
      height: 34.sp / 32.sp,
      color: color,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle figtreeXL({required Color color}) {
    return TextStyle(
      fontSize: 32.sp,
      height: 34.sp / 32.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle figTreeXLMedium({required Color color}) {
    return TextStyle(
      fontSize: 32.sp,
      height: 34.sp / 32.sp,
      color: color,
      letterSpacing: 0.05,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bodyXL({required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 32.sp,
      letterSpacing: 0.05,
      height: 34.sp / 32.sp,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyLarge({required Color color}) {
    return TextStyle(
      fontSize: 24.sp,
      letterSpacing: 0.05,
      height: 34.sp / 24.sp,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyLMedium({required Color color}) {
    return TextStyle(
      fontSize: 16.sp,
      height: 22.sp / 16.sp,
      letterSpacing: 0.05,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle displayM({
    bool poppins = false,
    bool addShadow = false,
    required Color color,
  }) {
    double fontSize = 40.sp;
    FontWeight fontWeight = FontWeight.w600;
    double lineHeight = 56.sp;
    List<Shadow>? shadows = addShadow
        ? [
      const Shadow(
        color: lightGreyColor,
        offset: Offset(2, 2),
      )
    ]
        : null;
    return poppins
        ? GoogleFonts.poppins(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
      letterSpacing: 0.05,
      height: lineHeight / fontSize,
      shadows: shadows,
    )
        : TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
      letterSpacing: 0.05,
      height: lineHeight / fontSize,
      shadows: shadows,
    );
  }

  static TextStyle displayFigtreeBold(
      {required Color color, required Color shadowColor}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 40.sp,
      color: color,
      letterSpacing: 0.05,
      height: 56.sp / 40.sp,
      shadows: [
        Shadow(
          offset: const Offset(2, 2),
          blurRadius: 4,
          color: shadowColor,
        ),
      ],
    );
  }
}
