import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/circle_icon_widget.dart';
import '../../on_boarding_logic.dart';

class BankStatementSelector extends StatelessWidget {
  final logic = Get.find<VerifyBankStatementLogic>();

  BankStatementSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  "Upload your bank statement",
                  textAlign: TextAlign.center,
                  style: buildBankStatementInfoTextStyle(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: logic.configureWidgetAlignment(),
            children: [

              if (logic.selectedBank.statementSupported)
                GetBuilder<VerifyBankStatementLogic>(
                    id: 'upload_pdf_ic',
                    builder: (logic) {
                      return CircleIconWidget(
                        index: 1,
                        title: "Upload PDF",
                        subTitle: "Last 3 Months Statement",
                        currentIndex: logic.getbankSelectorIndex,
                        onTap: (){
                          logic.setbankSelectorIndex(1);
                        },
                        asset_path: Res.pdf,
                      );
                    }),
              // if (logic.selectedBank!.statementSupported &&
              //     logic.selectedBank!.netbankingSupported)
              //   const Spacer(
              //     flex: 2,
              //   ),
              SizedBox(width: 30,),
              if (logic.selectedBank.netbankingSupported)
                GetBuilder<VerifyBankStatementLogic>(builder: (logic) {
                  return CircleIconWidget(
                    index: 2,
                    title: "Net Banking",
                    currentIndex: logic.getbankSelectorIndex,
                    onTap: (){
                      logic.setbankSelectorIndex(2);
                    },
                    subTitle: "Login to your account",
                    asset_path: Res.world_wide_web,
                  );
                },
                  id: 'net_banking_ic',
                ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle buildBankStatementInfoTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Color(0xFF969697),
      letterSpacing: 0.11,
    );
  }
}

