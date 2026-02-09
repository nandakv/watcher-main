import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';

class FinsightsEmptyWidget extends StatelessWidget {
  const FinsightsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(Res.finsightsNoTransactionsSvg),
        const Padding(
          padding: EdgeInsets.only(top: 12.0, left: 41, right: 41, bottom: 50),
          child: Text(
              "Uh oh! Looks like there are no transactions to show at this moment",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: secondaryDarkColor,
              )),
        ),
      ],
    );
  }
}
