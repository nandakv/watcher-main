import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/slider_circle_thumb_shape.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

import '../../loan_details/widgets/info_bottom_sheet.dart';

class InterestWidget extends StatelessWidget {
  SliderThemeData sliderThemeData;
  InputDecoration? decoration;

  InterestWidget({required this.sliderThemeData, required this.decoration});

  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Rate of interest (p.a.)",
                style: TextStyle(
                    color: secondaryDarkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
              const SizedBox(width: 6,),
              _infoIcon(),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          IntrinsicWidth(
            child: GetBuilder<EmiCalculatorLogic>(
              id: logic.INTEREST_TEXTFIELD_ID,
              builder: (logic) {
                return TextFormField(
                  controller: logic.interestTextController,
                  style: _loanAmountTextStyle(),
                  maxLength: 12,
                  inputFormatters: [
                    DecimalInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  cursorColor: navyBlueColor,
                  decoration: decoration,
                  onChanged: logic.onInterestTextChanged,
                );
              },
            ),
          ),
          logic.interestErrorText.isNotEmpty ? _errorText() : const SizedBox(),
          verticalSpacer(15),
          _interestSlider(),
        ],
      ),
    );
  }

  InkWell _infoIcon() {
    return InkWell(
      onTap: (){
        Get.bottomSheet(InfoBottomSheet(
            title: "Rate Of Interest", text: "The rate of interest is essentially the cost of borrowing money. It's a percentage of the loan amount that you pay back to the lender on top of the original amount borrowed (principal)."));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: SvgPicture.asset(
          Res.info_icon,
        ),
      ),
    );
  }

  Column _errorText() {
    return Column(
          children: [
            verticalSpacer(10),
            Text(
              logic.interestErrorText,
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

  Widget _interestSlider() {
    return Column(
      children: [
        SliderTheme(
          data: sliderThemeData,
          child: GetBuilder<EmiCalculatorLogic>(
            id: logic.INTEREST_SLIDER_ID,
            builder: (logic) {
              return Slider(
                value: logic.interestSliderValue,
                onChangeEnd: logic.onInterestAmountChangedEnd,
                onChanged: logic.onInterestAmountChanged,
                min: logic.selectedLpc.minAndMaxInterest[logic.MIN_INDEX],
                max: logic.selectedLpc.minAndMaxInterest[logic.MAX_INDEX],
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
      children:  [
        Text(
          "${logic.selectedLpc.minAndMaxInterest[logic.MIN_INDEX]}%",
          style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
        Text(
          "${logic.selectedLpc.minAndMaxInterest[logic.MAX_INDEX]}%",
          style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
