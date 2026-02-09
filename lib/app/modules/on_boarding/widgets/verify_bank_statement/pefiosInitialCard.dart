import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../res.dart';

class PerfiosInitialCard extends StatelessWidget {
  PerfiosInitialCard({Key? key}) : super(key: key);
  final logic = Get.find<VerifyBankStatementLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                  "Hey there!",
                  style: buildTextStyle(),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Text(
                    "We can offer you a credit line upto",
                    textAlign: TextAlign.center,
                    style: buildOfferTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    logic.getIOFOAmount(logic.initialResponseModel.offerSection!.limitAmount),
                    textAlign: TextAlign.center,
                    style: buildAmountInfoTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: RichText(
                    text: TextSpan(
                      text: 'at ',
                      style: buildRichTextStyle(),
                      children: [
                        TextSpan(
                            text:
                                "${logic.initialResponseModel.offerSection!.interest}% ",
                            style: buildIntrestTextStyle()),
                         TextSpan(
                            text: "Interest Rate",
                            style: buildIntrestTitleTextStyle())
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 35,
          ),
          Expanded(child: SvgPicture.asset(Res.bank_statement_illustration)),
        ],
      ),
    );
  }

  TextStyle buildIntrestTextStyle() {
    return const TextStyle(
                              color: Color(0xff0E9823),
                              fontSize: 10,
                              letterSpacing: 0.08,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal);
  }

  TextStyle buildIntrestTitleTextStyle() {
    return const TextStyle(
                              color: Color(0xff5E6066),
                              fontSize: 10,
                              letterSpacing: 0.08,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal);
  }

  TextStyle buildRichTextStyle() {
    return const TextStyle(
                        color: Color(0xff5E6066),
                        fontSize: 10,
                        letterSpacing: 0.08,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal);
  }

  TextStyle buildAmountInfoTextStyle() {
    return const TextStyle(
                      color: Color(0xff0E9823),
                      fontSize: 16,
                      letterSpacing: 0.15,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600);
  }

  TextStyle buildOfferTextStyle() {
    return const TextStyle(
                      color: mainTextColor,
                      fontSize: 12,
                      letterSpacing: 0.09,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal);
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
                    color: subTextColor,
                    fontSize: 16,
                    letterSpacing: 0.12,
                    fontWeight: FontWeight.w600);
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF8FFFB),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
