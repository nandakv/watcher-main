import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../res.dart';

class PerfiosErrorCard extends StatelessWidget {
  const PerfiosErrorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:   [
                buildTitleText(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Text(
                    "We were unable to verify your bank account",
                    textAlign: TextAlign.left,
                    style: buildSubTitleTextStyle(),
                  ),
                ),
                Text(
                  "Please Try Again",
                  textAlign: TextAlign.left,
                  style: buildBottomTextStyle(),
                ),
              ],
            ),
          ),
          Expanded(child: SvgPicture.asset(Res.sad_illustration)),
        ],
      ),
    );
  }

  TextStyle buildBottomTextStyle() {
    return const TextStyle(
                    color: subTextColor,
                    fontSize: 12,
                    letterSpacing: 0.09,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600
                );
  }

  TextStyle buildSubTitleTextStyle() {
    return const TextStyle(
                      color: mainTextColor,
                      fontSize: 12,
                      letterSpacing: 0.09,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                  );
  }

  Text buildTitleText() {
    return const Text(
                "Bank Verification Failed!",
                style: TextStyle(
                    color: redTextColor,
                    fontSize: 16,
                    letterSpacing: 0.12,
                    fontWeight: FontWeight.w600
                ),
              );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: perfiosErrorCardColor,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
