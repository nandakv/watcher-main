import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/slider_circle_thumb_shape.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class LoanAmountWidget extends StatelessWidget {
  SliderThemeData sliderThemeData;
  InputDecoration? decoration;

  LoanAmountWidget({required this.sliderThemeData, required this.decoration});

  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Loan amount",
            style: TextStyle(
                color: secondaryDarkColor,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          IntrinsicWidth(
            child: GetBuilder<EmiCalculatorLogic>(
              id: logic.LOAN_AMOUNT_TEXTFIELD_ID,
              builder: (logic) {
                return TextFormField(
                  controller: logic.loanAmountTextController,
                  style: _loanAmountTextStyle(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    NumberToRupeesFormatter(),
                  ],
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  cursorColor: navyBlueColor,
                  decoration: decoration,
                  onChanged: logic.onLoanAmountTextChanged,
                );
              },
            ),
          ),
          logic.loanErrorText.isNotEmpty ? _errorText() : const SizedBox(),
          const SizedBox(
            height: 15,
          ),
          _loanAmountSlider(),
        ],
      ),
    );
  }

  Column _errorText() {
    return Column(
      children: [
        verticalSpacer(10),
        Text(
          logic.loanErrorText,
          style: _errorTextStyle(),
        ),
      ],
    );
  }

  TextStyle _errorTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: Color(0xFFEE3D4B),
    );
  }

  TextStyle _loanAmountTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: navyBlueColor,
    );
  }

  Widget _loanAmountSlider() {
    return Column(
      children: [
        SliderTheme(
          data: sliderThemeData,
          child: GetBuilder<EmiCalculatorLogic>(
            id: logic.LOAN_AMOUNT_SLIDER_ID,
            builder: (logic) {
              return Slider(
                value: logic.loanAmountSliderValue,
                onChangeEnd: logic.onLoanAmountSliderChangeEnd,
                onChanged: logic.onLoanAmountSliderChanged,
                min: logic.selectedLpc.minAndMaxAmount[logic.MIN_INDEX],
                max: logic.selectedLpc.minAndMaxAmount[logic.MAX_INDEX],
              );
            },
          ),
        ),
        verticalSpacer(5),
        _minMaxValueLabel()
      ],
    );
  }

  Row _minMaxValueLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          logic.formatAmountWithSuffix(
              logic.selectedLpc.minAndMaxAmount[logic.MIN_INDEX].toInt()),
          style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
        Text(
          logic.formatAmountWithSuffix(
              logic.selectedLpc.minAndMaxAmount[logic.MAX_INDEX].toInt()),
          style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
