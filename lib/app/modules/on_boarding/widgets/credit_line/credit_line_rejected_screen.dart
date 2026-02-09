import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../res.dart';

class CreditLineRejectedScreen extends StatelessWidget {
  const CreditLineRejectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 73),
        child: Column(
          children: [
            Text(
              "Uh-oh!",
              style: buildTitleTextStyle(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 23),
              child: Text(
                "Sorry, we cannot offer you a credit line",
                textAlign: TextAlign.center,
                style: buildSubTitleTextStyle,
              ),
            ),
            const SizedBox(
              height: 69,
            ),
            SvgPicture.asset(
              Res.credit_line_rejected,
              height: 117,
              width: 252,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 61),
              child: Text(
                "But it’s not all bad news, you can reapply in 90 days.",
                textAlign: TextAlign.center,
                style: buildSubTitleTextStyle,
              ),
            ),
            const SizedBox(
              height: 38,
            ),
            BlueButton(
              onPressed: () {
                Get.back();
              },
              buttonColor: const Color(0xFF004097),
              title: "Home",
            ),
            const SizedBox(
              height: 38,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle buildTitleTextStyle() {
    return const TextStyle(
        color: Color(0xFFD11313),
        fontSize: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.84);
  }

  TextStyle get buildSubTitleTextStyle {
    return const TextStyle(
        color: const Color(0xFF344157), fontSize: 18, letterSpacing: 0.14);
  }
}
