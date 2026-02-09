import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_logic.dart';
import 'package:privo/app/modules/emi_calculator/widgets/info_widget.dart';
import 'package:privo/app/modules/emi_calculator/widgets/interest_widget.dart';
import 'package:privo/app/modules/emi_calculator/widgets/loan_amount_widget.dart';
import 'package:privo/app/modules/emi_calculator/widgets/tenure_widget.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/slider_circle_thumb_shape.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

class CalculatorScreen extends StatelessWidget {
  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _titleWidget(),
          verticalSpacer(10),
          InfoWidget(),
          verticalSpacer(10),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Stress-Free Loan Planning Starts Here!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: navyBlueColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: _gradientBorderDecoration(),
              child: Column(
                children: [
                  LoanAmountWidget(
                    decoration: _textFieldDecoration(),
                    sliderThemeData: _sliderThemeData(),
                  ),
                  TenureWidget(
                    decoration: _tenureTextDecoration(),
                    sliderThemeData: _sliderThemeData(),
                  ),
                  InterestWidget(
                    decoration: _interestTextDecoration(),
                    sliderThemeData: _sliderThemeData(),
                  ),
                  Container(
                    decoration: _topBorderDecoration(),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5FCFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "₹${AppFunctions().parseIntoCommaFormat(logic.monthlyEmi)}",
                            style: const TextStyle(
                                color: darkBlueColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          const Text(
                            "Monthly EMI",
                            style: TextStyle(
                                color: darkBlueColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.5),
                            child: _titleAndValueWidget(
                                "Total interest payable",
                                logic.totalInterestPayable),
                          ),
                          _titleAndValueWidget("Loan amount",
                              logic.loanAmountSliderValue.toString()),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7.5),
                            child: Divider(
                              color: darkBlueColor,
                            ),
                          ),
                          _titleAndValueWidget(
                              "Total amount payable", logic.totalAmountPayable),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _poweredByCs(),
          verticalSpacer(10)
        ],
      ),
    );
  }

  Row _titleWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          logic.selectedLpc.title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 5,
        ),
        _infoIcon(),
      ],
    );
  }

  Widget _poweredByCs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: SvgPicture.asset(
          Res.poweredByCS,
          height: 20,
          colorFilter: const ColorFilter.mode(
            navyBlueColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Row _titleAndValueWidget(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
                color: darkBlueColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ),
        Flexible(
          child: Text(
            "₹${AppFunctions().parseIntoCommaFormat(value)}",
            style: const TextStyle(
                color: darkBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  BoxDecoration _topBorderDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFF8FD1EC),
        Color(0xFF229ACE),
      ]),
      color: Colors.transparent,
      border: Border(
          top: BorderSide(
        color: Color(0xFF8FD1EC),
        width: 1,
      )),
    );
  }

  InputDecoration _tenureTextDecoration() {
    return _textFieldDecoration().copyWith(prefixText: '');
  }

  InputDecoration _interestTextDecoration() {
    return _textFieldDecoration().copyWith(prefixText: '', suffixText: '%');
  }

  InputDecoration _textFieldDecoration() {
    return InputDecoration(
      counterText: "",
      prefixText: "₹ ",
      isDense: true,
      errorMaxLines: 3,
      errorStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Color(0xFFEE3D4B),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: navyBlueColor
        )
      ),
      prefixStyle: _loanAmountTextStyle(),
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      suffixStyle: _loanAmountTextStyle(),
    );
  }

  SliderThemeData _sliderThemeData() {
    return SliderThemeData(
      trackHeight: 5,
      activeTrackColor: goldColor,
      activeTickMarkColor: goldColor,
      inactiveTrackColor: lightGrayColor,
      inactiveTickMarkColor: offWhiteColor,
      disabledActiveTrackColor: goldColor,
      disabledActiveTickMarkColor: goldColor,
      disabledInactiveTrackColor: offWhiteColor,
      thumbColor: darkBlueColor.withOpacity(1),
      thumbShape: const SliderCircleThumbShape(
          thumbRadius: 8,
          fillColor: Color(0xffE1B22B),
          borderColor: Color(0xffAF8E2F),
          strokeWidth: 2),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1),
      overlayShape: SliderComponentShape.noThumb,
    );
  }

  TextStyle _loanAmountTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: navyBlueColor,
    );
  }

  InkWell _infoIcon() {
    return InkWell(
      onTap: logic.onInfoTapped,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: SvgPicture.asset(
          Res.info_icon,
        ),
      ),
    );
  }

  BoxDecoration _gradientBorderDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      gradient: const LinearGradient(colors: [
        Color(0xFF8FD1EC),
        Color(0xFF229ACE),
      ]),
      border: Border.all(
        color: Color(0xFF8FD1EC),
        width: 1,
      ),
    );
  }
}