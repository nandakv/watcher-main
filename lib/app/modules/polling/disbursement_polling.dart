import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'gradient_circular_progress_indicator.dart';

class DisbursementPolling extends StatelessWidget {
  const DisbursementPolling({
    Key? key,
    required this.titleText,
    required this.bodyTexts,
  }) : super(key: key);

  final String titleText;
  final List<String> bodyTexts;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //  mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff004097),
                    fontWeight: FontWeight.w600,
                    letterSpacing: .16,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          //  const Spacer(flex: 1),
            Column(
              children: [
                const RotationTransitionWidget(
                  loadingState: LoadingState.progressLoader,
                ),
                const SizedBox(height: 30,),

                AnimatedTextWidget(bodyTexts: bodyTexts),

              ],
            ),
            // SvgPicture.asset(Res.progressBar),

          ],
        ),
      ),
    );
  }
}

class AnimatedTextWidget extends StatelessWidget {
  const AnimatedTextWidget(
      {Key? key,
        required this.bodyTexts,
        this.textStyle = const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.08,
            color: Color(0xff1D478E),
            fontFamily: 'Figtree')})
      : super(key: key);

  final List<String> bodyTexts;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Center(
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
                textAlign: TextAlign.center,
                duration: const Duration(seconds: 3),
                fadeOutBegin: 0.9,
                fadeInEnd: 0.3,
                textStyle: textStyle,
              ),
            )
                .toList(),
          )
              : Text(
            bodyTexts.first,
            style: _progressTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  TextStyle get _progressTextStyle {
    return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.08,
        color: Color(0xff1D478E),
        fontFamily: 'Figtree');
  }

}
