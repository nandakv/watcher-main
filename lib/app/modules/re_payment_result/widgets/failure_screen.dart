import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/re_payment_result/re_payment_result_logic.dart';
import 'package:privo/res.dart';
import 'package:privo/app/theme/app_colors.dart';


class FailureScreen extends StatelessWidget {
  FailureScreen({Key? key}) : super(key: key);
  final logic = Get.find<RePaymentResultLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        SvgPicture.asset(
          Res.bank_verify_failure,
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          "Could not complete the payment.",
          textAlign: TextAlign.center,
          style: textStyle(),
        ),
        TextButton(
          onPressed: logic.onTryAgainClicked,
          child: Text(
            "Try Again",
            style: _textButtonStyle(),
          ),
        ),
      ],
    );
  }


  TextStyle textStyle() {
    return const TextStyle(
        fontSize: 16,
        letterSpacing: 0.11,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: Color(0xFF344157));
  }

  TextStyle _textButtonStyle() {
    return const TextStyle(
      decoration: TextDecoration.underline,
      letterSpacing: 0.47,
      color: skyBlueColor,
      fontSize: 12,
    );
  }
}
