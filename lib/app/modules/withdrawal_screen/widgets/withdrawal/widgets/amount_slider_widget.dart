import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';


class AmountSliderWidget extends StatelessWidget {
  AmountSliderWidget({Key? key}) : super(key: key);
  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalLogic>(
      id: logic.LOAN_AMOUNT_TEXTFIELD_ID,
      builder: (logic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(Res.dollar),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: KeyboardVisibilityBuilder(
                    builder: (context, isKeyBoardVisible) {
                      return TextFormField(
                        enabled: !logic.isCallingApi,
                        inputFormatters: [
                          NumberToRupeesFormatter(),
                        ],
                        controller: logic.loanAmountTextController,
                        onChanged: (value) =>
                            logic.onLoanAmountTextChanged(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            logic.validateLoanAmountTextFiled(value),
                        style: _inputTextStyle,
                        onEditingComplete: () =>
                            logic.onLoanAmountEditingComplete(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 12,
                        decoration: InputDecoration(
                            labelText: "Loan Amount (₹)",
                            counterText: '',
                            errorMaxLines: 3,
                            errorStyle: const TextStyle(
                              fontSize: 10,
                            ),
                            helperStyle: const TextStyle(
                              fontSize: 10,
                            ),
                            isDense: true,
                            labelStyle: _labelTextStyle),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  TextStyle get _labelTextStyle => const TextStyle(
      fontSize: 14,
      letterSpacing: 0.22,
      color: accountSummaryTitleColor,
      fontWeight: FontWeight.w400);

  TextStyle get _inputTextStyle => const TextStyle(
      fontSize: 14,
      letterSpacing: 0.22,
      color: Color(0xFF404040),
      fontWeight: FontWeight.w400);
}
