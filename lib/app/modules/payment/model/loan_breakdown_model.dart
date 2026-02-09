import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class LoanBreakdownModel {
  final String? title;
  final Widget? titleSuffixWidget;
  final TextStyle? titleTextStyle;
  final List<LoanBreakdownRowData> breakdownRowData;
  final Widget? bottomWidget;
  final Color? backgroundColor;
  final Color? bottomBarColor;
  final bool showDivider;
  final EdgeInsets padding;
  final EdgeInsets bottomWidgetPadding;
  final BorderRadiusGeometry? borderRadiusGeometry;

  LoanBreakdownModel({
    this.title,
    this.titleTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryDarkColor,
    ),
    this.bottomWidget,
    this.titleSuffixWidget,
    this.backgroundColor = offWhiteColor,
    this.bottomBarColor = navyBlueColor,
    this.showDivider = false,
    this.borderRadiusGeometry,
    required this.breakdownRowData,
    this.padding = const EdgeInsets.only(
      top: 20,
      left: 20,
      right: 20,
      bottom: 12,
    ),
    this.bottomWidgetPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 24,
    ),
  });
}

class LoanBreakdownRowData {
  final String key;
  final String value;
  final TextStyle? keyTextStyle;
  final TextStyle? valueTextStyle;
  final Widget? suffixWidget;

  LoanBreakdownRowData({
    required this.key,
    required this.value,
    this.keyTextStyle = const TextStyle(
      color: primaryDarkColor,
      fontSize: 12,
    ),
    this.valueTextStyle = const TextStyle(
      fontSize: 12,
      color: primaryDarkColor,
    ),
    this.suffixWidget,
  });
}
