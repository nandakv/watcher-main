import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import 'arrow_pointer.dart';
import 'slider_circle_thumb_shape.dart';

class TenureSlider extends StatelessWidget {
  TenureSlider({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible:
              !(logic.tenureRange.length == 2 || logic.tenureRange.length == 1),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3EB),
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<WithdrawalLogic>(
                  id: logic.tenureTextId,
                  builder: (logic) {
                    return Text(
                      "${logic.tenureSliderValue} months",
                      style: _inputTextStyle.copyWith(
                          fontSize: 12,
                          fontFamily: 'Figtree',
                          color: darkBlueColor,
                          fontWeight: FontWeight.w600),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 20,
                  child: SliderTheme(
                    data: _sliderThemeData(context),
                    child: GetBuilder<WithdrawalLogic>(
                      id: logic.tenureSliderId,
                      builder: (logic) {
                        return Slider(
                          min: logic.tenureRange.first.toDouble(),
                          max: logic.tenureRange.last.toDouble(),
                          divisions: logic.tenureRange.length - 1,
                          value: logic.tenureSliderValue.ceil().toDouble(),
                          onChangeEnd: (value) {
                            _onSliderChanged(logic, value);
                          },
                          onChanged: logic.isCallingApi ||
                                  logic.loanAmountErrorValidator()
                              ? null
                              : (value) {
                                  logic.onTenureChanged(value);
                                },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Min : ${logic.tenureRange.first} months",
                      style: _minAndMaxTenureTextStyle(),
                    ),
                    Text(
                      "Max : ${logic.tenureRange.last} months",
                      style: _minAndMaxTenureTextStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: CustomPaint(
              painter: ArrowPainter(color: const Color(0xFFFFF3EB)),
              child: const SizedBox(
                width: 16, // Adjust the size as needed
                height: 8,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onSliderChanged(WithdrawalLogic logic, double value) {
    logic.customTenureSliderValue = value.round().toInt();
    logic.calculateTenureText(value);
    logic.getWithdrawalCalculations(
        key:
            "${logic.loanAmountSliderValue.toInt()},${logic.tenureSliderValue}");
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawTenureSelected,
        attributeName: {"Tenure": value});
  }

  SliderThemeData _sliderThemeData(BuildContext context) {
    return SliderThemeData(
      trackHeight: 5,
      activeTrackColor: darkBlueColor,
      activeTickMarkColor: darkBlueColor,
      inactiveTrackColor: lightGrayColor,
      inactiveTickMarkColor: lightGrayColor,
      disabledActiveTrackColor: darkBlueColor,
      disabledActiveTickMarkColor: darkBlueColor,
      disabledInactiveTrackColor: lightGrayColor,
      thumbColor: darkBlueColor.withOpacity(1),
      thumbShape: const SliderCircleThumbShape(
          thumbRadius: 10,
          fillColor: skyBlueColor,
          borderColor: darkBlueColor,
          strokeWidth: 2),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1),
      overlayShape: SliderComponentShape.noThumb,
    );
  }

  TextStyle _minAndMaxTenureTextStyle() {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Color(0xFF161742),
    );
  }

  TextStyle get _inputTextStyle => const TextStyle(
      fontSize: 14,
      letterSpacing: 0.22,
      color: Color(0xFF404040),
      fontWeight: FontWeight.w400);
}
