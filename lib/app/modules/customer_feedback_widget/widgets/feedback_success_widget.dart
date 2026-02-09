import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/res.dart';

import '../../../theme/app_colors.dart';

class FeedBackSuccessWidget extends StatelessWidget {
  const FeedBackSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 50,
          ),
          SvgPicture.asset(Res.feedback_success),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Text(
              "We’re constantly working on improving your experience. Thank you for sharing your feedback.",
              textAlign: TextAlign.center,
              style: textStyle(),
            ),
          )
        ],
      ),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(fontSize: 14, color: titleTextColor);
  }
}
