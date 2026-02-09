import 'package:flutter/material.dart';

class CardTitleAndValueWidget extends StatelessWidget {
  final String title;
  final String value;
  final String? previousValue;
  final Widget? iconWidget;

  const CardTitleAndValueWidget(this.title, this.value,
      {Key? key, this.previousValue, this.iconWidget})
      : super(key: key);

  TextStyle _titleTextStyle(
      {double fontSize = 8, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        color: const Color(0xFF404040));
  }

  TextStyle get _previousValueTextStyle {
    return const TextStyle(
        fontSize: 8,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
        color: Color(0xFF404040));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: _titleTextStyle(),
                ),
              ),
              if (iconWidget != null) iconWidget!,
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          RichText(
            text: TextSpan(
              text: value,
              style: _titleTextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              children: [
                if (previousValue != null)
                  TextSpan(
                    text: ' / $previousValue',
                    style: _previousValueTextStyle,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
