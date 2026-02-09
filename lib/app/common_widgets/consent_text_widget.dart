import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../firebase/analytics.dart';
import '../modules/low_and_grow/widgets/low_and_grow_offer/widgets/low_and_grow_terms_and_condition_widget.dart';
import '../utils/web_engage_constant.dart';

enum ConsentType { lowAndGrow, none }

enum CheckBoxState { preRegCheckBox, postRegCheckBox }

class ConsentTextWidget extends StatefulWidget {
  final String consentText;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final double letterSpacing;
  final CheckBoxState checkBoxState;
  final double horizontalGap;
  final double horizontalPadding;
  final List<String> policyList;
  final ConsentType consentType;

  const ConsentTextWidget(
      {Key? key,
      required this.consentText,
      required this.value,
      this.onChanged,
      this.fontSize = 10,
      this.fontWeight = FontWeight.normal,
      this.fontColor = Colors.white,
      this.letterSpacing = .16,
      this.horizontalGap = 10,
      this.horizontalPadding = 5,
      required this.checkBoxState,
      this.policyList = const [],
      this.consentType = ConsentType.none})
      : super(key: key);

  @override
  State<ConsentTextWidget> createState() =>
      _ConsentTextWidgetState(checkBoxState);
}

class _ConsentTextWidgetState extends State<ConsentTextWidget> {
  final CheckBoxState checkBoxState;

  _ConsentTextWidgetState(this.checkBoxState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            visualDensity: const VisualDensity(
              horizontal: -4.0,
              vertical: -4.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            checkColor: checkBoxState == CheckBoxState.preRegCheckBox
                ? const Color(0xff284689)
                : const Color(0xffffffff),
            side: BorderSide(
                color: checkBoxState == CheckBoxState.preRegCheckBox
                    ? Colors.transparent
                    : const Color(0xff002F7D),
                width: 1),
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: checkBoxState == CheckBoxState.preRegCheckBox
                ? Colors.white
                : const Color(0xff1D478E),
          ),
          SizedBox(
            width: widget.horizontalGap,
          ),
          Expanded(child: onConsentDisplay(widget.consentType))
        ],
      ),
    );
  }

  Text consentText() {
    return Text(
      widget.consentText,
      style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          letterSpacing: widget.letterSpacing,
          color: checkBoxState == CheckBoxState.preRegCheckBox
              ? widget.fontColor
              : const Color(0xff707070)),
    );
  }

  RichText lowAndGrowConsentText() {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text:
                "I hereby authorise Credit Saison India to upgrade my credit line offer and agree to ",
            style: _assignmentParaTextStyle,
          ),
          TextSpan(
            text: "Terms and Condition",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.bottomSheet(
                  Wrap(
                    children: [
                      LowAndGrowTermsAndConditionWidget(
                        title: "Terms and Conditions",
                        policyList: widget.policyList,
                        policyStatus: true,
                        bulletStatus: false,
                      )
                    ],
                  ),
                );
                AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.lgTncClicked);

                AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.lgTncBottomUpLoaded);
              },
            style: _hyperLinkTextStyle,
          )
        ]));
  }

  TextStyle get _hyperLinkTextStyle {
    return const TextStyle(
        color: Color(0xff91D5EA),
        decoration: TextDecoration.underline,
        fontSize: 8);
  }

  TextStyle get _assignmentParaTextStyle {
    return const TextStyle(
        color: Color(0xff404040),
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
        letterSpacing: 0.24);
  }

  Widget onConsentDisplay(ConsentType consentType) {
    switch (consentType) {
      case ConsentType.lowAndGrow:
        return lowAndGrowConsentText();
      case ConsentType.none:
        return consentText();
    }
  }
}
