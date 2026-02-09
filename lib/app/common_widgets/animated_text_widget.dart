import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextWidget extends StatelessWidget {
  final List<String> bodyTexts;
  final TextStyle textStyle;
  final int flex;
  final Alignment alignment;
  final TextAlign textAlign;
  final double horizontalPadding;

  const AnimatedTextWidget(
      {Key? key,
      required this.bodyTexts,
      this.flex = 3,
      this.horizontalPadding = 0,
      this.textStyle = const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.08,
          color: Color(0xff1D478E),
          fontFamily: 'Figtree'),
      this.alignment = Alignment.center,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            child: bodyTexts.length > 1
                ? AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    animatedTexts: bodyTexts
                        .map(
                          (e) => FadeAnimatedText(
                            e,
                            textAlign: textAlign,
                            duration: const Duration(seconds: 3),
                            fadeInEnd: 0.1,
                            fadeOutBegin: 0.9,
                            textStyle: textStyle,
                          ),
                        )
                        .toList(),
                  )
                : Text(
                    bodyTexts.first,
                    style: textStyle,
                    textAlign: textAlign,
                  ),
          ),
        ),
      ),
    );
  }
}
