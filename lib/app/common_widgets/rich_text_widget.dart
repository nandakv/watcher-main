import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/rich_text_model.dart';

class RichTextWidget extends StatelessWidget {
  final List<RichTextModel> infoList;
  final TextAlign textAlign;

  const RichTextWidget({
    Key? key,
    required this.infoList,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          children: infoList
              .map(
                (info) => _computeTextWidget(info),
              )
              .toList()),
      textAlign: textAlign,
    );
  }

  TextSpan _computeTextWidget(RichTextModel info) {
    if (info.link.isNotEmpty) {
      return TextSpan(
        text: info.text,
        recognizer: TapGestureRecognizer()
          ..onTap = () =>onHyperlinkTapped(info),
        style: info.textStyle ?? _hyperLinkTextStyle,
      );
    }
    return TextSpan(
      text: info.text,
      recognizer: TapGestureRecognizer()..onTap = () => info.onTap?.call(),
      style: (info.textStyle ?? _assignmentParaTextStyle),
    );
  }

  onHyperlinkTapped(RichTextModel info) {
    info.onHyperlinkClicked?.call();
    launchUrlString(
      info.link.trim(),
      mode: LaunchMode.externalApplication,
    );
  }

  TextStyle get _assignmentParaTextStyle {
    return const TextStyle(
        color: Color(0xff404040),
        fontSize: 8,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
        letterSpacing: 0.24);
  }

  TextStyle get _hyperLinkTextStyle {
    return const TextStyle(
        color: Color(0xff91D5EA),
        decoration: TextDecoration.underline,
        fontSize: 8);
  }
}
