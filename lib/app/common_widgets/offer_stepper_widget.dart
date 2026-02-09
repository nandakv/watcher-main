import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../res.dart';
import 'horizontal_timeline_step_widget.dart';

class OfferStepper extends StatelessWidget {
  const OfferStepper({Key? key}) : super(key: key);

  Widget _titleTextWidget() {
    return Text(
      "You’re few steps away from withdrawal",
      style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: .11,
          color: const Color(0xff161742)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _titleTextWidget(),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: const [
                HorizontalTimelineStepWidget(
                  label: 'Get offer',
                  step: '1',
                  state: HorizontalTimelineStepWidgetState.success,
                  circleSize: 24,
                ),
                HorizontalTimelineStepWidget(
                  label: 'KYC',
                  step: '2',
                  state: HorizontalTimelineStepWidgetState.active,
                  circleSize: 24,
                ),
                HorizontalTimelineStepWidget(
                  label: 'Withdraw',
                  step: '3',
                  state: HorizontalTimelineStepWidgetState.inActive,
                  isLastStep: true,
                  circleSize: 24,
                ),
              ],
            ),
          ),
          // OfferStepperWidget(
          //   stepperValue: 1,
          // ),
        ],
      ),
    );
  }
}

class OfferStepperWidget extends StatelessWidget {
  final double stepperValue;
  final List<String> steps = getStepperData();

  OfferStepperWidget({Key? key, required this.stepperValue}) : super(key: key);

  TextStyle _bottomTextStyle() {
    return const TextStyle(
        color: Color(0xff161742),
        fontSize: 10,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return OfferStepperItem(
                    index: index,
                    bottomText: "",
                    isLast: index == (steps.length - 1),
                    value: stepperValue,
                  );
                }),
          ),

          /// To display bottom text
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  if (steps[index].isNotEmpty) {
                    return Text(
                      steps[index],
                      style: _bottomTextStyle(),
                    );
                  }
                  return SizedBox(
                    width: screenWidth * 0.17,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class OfferStepperItem extends StatelessWidget {
  final int index;
  final String bottomText;
  final bool isLast;
  final double value;

  const OfferStepperItem(
      {Key? key,
      required this.index,
      required this.bottomText,
      required this.isLast,
      required this.value})
      : super(key: key);

  TextStyle _textStyle() {
    return TextStyle(
        color: computeStepColor(),
        fontSize: 12,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  Color computeStepColor() {
    // Need to change to Enum once we make this dynamic
    if (value < index) {
      return const Color(0x33161742);
    } else if (value == index) {
      return const Color(0xff161742);
    } else {
      return const Color(0xff32B353);
    }
  }

  Color computeStepDividerColor() {
    // Need to change to Enum once we make this dynamic
    if (value <= index) {
      return const Color(0x33161742);
    } else {
      return const Color(0xff32B353);
    }
  }

  Widget _divider(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      color: computeStepDividerColor(),
      height: 0.8,
      width: screenWidth * 0.1,
    );
  }

  Widget _numberWidget() {
    return Center(
      child: Text(
        "${index + 1}",
        style: _textStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 0.8, color: computeStepColor()),
          ),
          child: value > index
              ? SvgPicture.asset(Res.greenCheckStepper)
              : _numberWidget(),
        ),
        isLast ? const SizedBox() : _divider(context),
      ],
    );
  }
}

List<String> getStepperData() {
  return [
    "",
    "Verify your identity",
    "",
    "",
  ];
}
