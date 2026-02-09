import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/re_payment_result/re_payment_result_logic.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../../res.dart';
import 'package:privo/app/theme/app_colors.dart';


class SuccessWidget extends StatelessWidget {
  SuccessWidget({Key? key, required this.amount}) : super(key: key);

  final logic = Get.find<RePaymentResultLogic>();

  String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _headerTextWidget(),
        const SizedBox(
          height: 20,
        ),
        SvgPicture.asset(Res.withdraw_success),
        const SizedBox(
          height: 100,
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text(
            "Go to Loan details",
            style: _textButtonStyle(),
          ),
        ),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }

  Column _headerTextWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "₹ ${AppFunctions().parseIntoCommaFormat(amount.replaceAll(',', ''))}",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.11,
            color: Color(0xFF1D478E),
          ),
        ),
        Text(
          "Paid Successfully",
          style: _titleTextStyle(),
        ),
      ],
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      fontSize: 20,
      letterSpacing: 0.15,
      fontWeight: FontWeight.bold,
      color: Color(0xFF32B353),
    );
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
