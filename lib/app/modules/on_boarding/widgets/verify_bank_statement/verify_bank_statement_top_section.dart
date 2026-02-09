import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/pefiosInitialCard.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/perfiosErrorCard.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../res.dart';
import '../../on_boarding_logic.dart';

class VerifyBankStatementTopSection extends StatelessWidget {
  VerifyBankStatementTopSection({Key? key}) : super(key: key);
  final logic = Get.find<VerifyBankStatementLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        GetBuilder<VerifyBankStatementLogic>(
            id: "perfios_card",
            builder: (logic) {
              if(logic.isPerfiosFailed == false){
                return  PerfiosInitialCard();
              }
              else{
                return const PerfiosErrorCard();
              }
        }),
         Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 10),
          child: Text(
            "Please provide your salary account bank statement to get the best offer",
            textAlign: TextAlign.start,
            style: buildTextStyle(),
          ),
        ),
      ],
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
              color:  Color(0xff363840),
              fontSize: 12,
              letterSpacing: 0.09,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300
          );
  }
}
