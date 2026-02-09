import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/rounded_circular_progress_indicator.dart';
import 'package:privo/app/theme/app_colors.dart';

class LimitProgressIndicator extends StatelessWidget {
  LimitProgressIndicator(
      {Key? key,
      this.height = 100,
      this.width = 100,
      this.progress = 0.01,
      this.text = "",
      this.secondaryText = "",
      this.textStyle = const TextStyle(color: Colors.white, fontSize: 12),
      this.strokeWidth = 7})
      : super(key: key);

  double height;
  double width;
  double progress;
  double strokeWidth;
  String text;
  String secondaryText;
  TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SizedBox(
              child: RoundedCircularProgressIndicator(
                color: Colors.white,
                value: 1,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _computeProgress()),
              duration: const Duration(seconds: 3),
              builder: (context, value, _) => RoundedCircularProgressIndicator(
                color: Colors.green,
                value: value,
                strokeWidth: 5, // Change this value to update the progress
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: _computePercentText(), style: textStyle,),
                    if (secondaryText.isNotEmpty)
                      TextSpan(
                        text: secondaryText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 0.14),
                      ),
                  ],
                ),
              ),
              // child: Text(
              //   _computePercentText(),
              //   style: TextStyle(color: Colors.white, fontSize: 12),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  String _computePercentText() {
    if (text.isEmpty) {
      if (progress == 0.01) return "0% utilised";
      return "${(progress * 100).toInt()}% utilised";
    }
    return text;
  }

  _computeProgress() {
    if(progress == 0.0){
      return 0.01;
    }
    return progress;
  }
}
