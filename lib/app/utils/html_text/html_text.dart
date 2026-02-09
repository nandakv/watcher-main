import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
// import 'package:privo/app/utils/screen_size_extension.dart';

import 'helper.dart';
import 'html_text_model.dart';

class HtmlText extends StatelessWidget {
  final String value;
  final TextStyle textStyle;

  const HtmlText(
    this.value, {
    Key? key,
    this.textStyle = const TextStyle(
      fontSize: 10,
      color: secondaryDarkColor,
      fontWeight: FontWeight.w500,
      // height: 1.5,
      // letterSpacing: 0.3,
      fontFamily: 'Figtree',
    ),
  }) : super(key: key);

  FontWeight get _normal => FontWeight.w400;

  FontWeight _getFontWeight(HtmlTextFormat value) {
    switch (value) {
      case HtmlTextFormat.bold:
      case HtmlTextFormat.h1:
        return FontWeight.bold;
      default:
        return _normal;
    }
  }

  double? _getFontSize(HtmlTextFormat value) {
    switch (value) {
      case HtmlTextFormat.h1:
        return 20.sp;
      default:
        return textStyle.fontSize?.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    var texts = HtmlTextHelper.mountText(value);

    var first = texts.first;
    texts = texts.where((e) => e.text != first.text).toList();

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: first.text,
        style: _computeTextStyle(first),
        children: texts.map((e) {
          return TextSpan(
            text: e.text,
            style: _computeTextStyle(e),
          );
        }).toList(),
      ),
    );
  }

  TextStyle _computeTextStyle(HtmlTextModel textModel) {
    return textStyle.copyWith(
      fontSize: _getFontSize(textModel.format),
      height: _getFontSize(textModel.format) == null
          ? null
          : 16.8.sp / _getFontSize(textModel.format)!,
      fontWeight: _getFontWeight(textModel.format),
      decoration: textModel.format == HtmlTextFormat.underline
          ? TextDecoration.underline
          : TextDecoration.none,
      fontStyle: textModel.format == HtmlTextFormat.italic
          ? FontStyle.italic
          : FontStyle.normal,
    );
  }
}
