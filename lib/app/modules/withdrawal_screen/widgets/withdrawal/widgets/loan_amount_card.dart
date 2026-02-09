import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/res.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../utils/app_functions.dart';
import '../../../../../utils/no_leading_space_formatter.dart';
import '../withdrawal_logic.dart';
import 'slider_circle_thumb_shape.dart';

class LoanAmountCard extends StatelessWidget {
  LoanAmountCard({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    ///container with blue gradient background
    return Container(
      width: double.infinity,
      decoration: _blueCardDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Choose an amount",
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: offWhiteColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _loanAmountTextField(),
            const SizedBox(
              height: 10,
            ),
            _loanAmountErrorWidget(),
            if (!logic.hideSlider) ...[
              _loanAmountSlider(),
              const SizedBox(
                height: 10,
              ),
            ],
            _minMaxAmountTextRow(),
            const SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }

  GetBuilder<WithdrawalLogic> _loanAmountErrorWidget() {
    return GetBuilder<WithdrawalLogic>(
      id: logic.LOAN_AMOUNT_ERROR_TEXT_ID,
      builder: (logic) {
        return logic.loanAmountErrorText.isNotEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info,
                        color: lightRedColor,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          logic.loanAmountErrorText,
                          style: _errorAmountTextStyle(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }

  TextStyle _errorAmountTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: lightRedColor,
    );
  }

  BoxDecoration _blueCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          postRegistrationEnabledGradientColor1,
          postRegistrationEnabledGradientColor2,
        ],
      ),
    );
  }

  Row _minMaxAmountTextRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _amountText(
          "Minimum",
          AppFunctions.getIOFOAmount(
            logic.withdrawalDetailsHomePageModel.availableMinLimit, //the entire widget
            // is only rendered if avalaible min limit and other values are not null
            // hence we can use null operator as its safe at this context.

          ),
        ),
        _amountText(
          "Available Limit",
          AppFunctions.getIOFOAmount(
            logic.withdrawalDetailsHomePageModel.availableLimit,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  RichText _amountText(
    String title,
    String label, {
    TextAlign textAlign = TextAlign.left,
  }) {
    return RichText(
      text: TextSpan(
        text: "$title\n",
        style: const TextStyle(
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w400,
          color: Color(0xffFFF3EB),
          fontSize: 8,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }

  Widget _loanAmountSlider() {
    return SliderTheme(
      data: _loanAmountSliderThemeData(),
      child: GetBuilder<WithdrawalLogic>(
        id: logic.LOAN_AMOUNT_SLIDER_ID,
        builder: (logic) {
          return Slider(
            value: logic.loanAmountSliderValue,
            onChangeEnd:
                logic.isCallingApi ? null : logic.onLoanAmountSliderChangeEnd,
            onChanged:
                logic.isCallingApi ? null : logic.onLoanAmountSliderChanged,
            min: logic.withdrawalDetailsHomePageModel.availableMinLimit!,
            max: logic.withdrawalDetailsHomePageModel.availableLimit,
            divisions: logic.computeLoanAmountSliderDivisions(),
          );
        },
      ),
    );
  }

  SliderThemeData _loanAmountSliderThemeData() {
    return SliderThemeData(
      trackHeight: 5,
      activeTrackColor: goldColor,
      activeTickMarkColor: goldColor,
      inactiveTrackColor: offWhiteColor,
      inactiveTickMarkColor: offWhiteColor,
      disabledActiveTrackColor: goldColor,
      disabledActiveTickMarkColor: goldColor,
      disabledInactiveTrackColor: offWhiteColor,
      thumbColor: darkBlueColor.withOpacity(1),
      thumbShape: const SliderCircleThumbShape(
          thumbRadius: 10,
          fillColor: Color(0xffE1B22B),
          borderColor: Color(0xffAF8E2F),
          strokeWidth: 2),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1),
      overlayShape: SliderComponentShape.noThumb,
    );
  }

  IntrinsicWidth _loanAmountTextField() {
    return IntrinsicWidth(
      child: GetBuilder<WithdrawalLogic>(
        id: logic.LOAN_AMOUNT_TEXTFIELD_ID,
        builder: (logic) {
          return TextField(
            controller: logic.loanAmountTextController,
            enabled: !logic.isCallingApi,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 28,
              color: offWhiteColor,
            ),
            inputFormatters: [
              NumberToRupeesFormatter(),
            ],
            maxLength: 12,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            cursorColor: offWhiteColor,
            decoration: _loanAmountTextFieldDecoration(),
            onChanged: logic.onLoanAmountTextChanged,
          );
        },
      ),
    );
  }

  InputDecoration _loanAmountTextFieldDecoration() {
    return InputDecoration(
      counterText: "",
      prefixText: "₹ ",
      prefixStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: offWhiteColor,
      ),
      contentPadding: EdgeInsets.zero,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFFF3EB)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFFF3EB)),
      ),
    );
  }
}
