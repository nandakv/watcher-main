import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class CheckBoxWithText extends StatelessWidget {
  final String consentText;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const CheckBoxWithText(
      {Key? key,
        required this.consentText,
        required this.value,
        this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: SizedBox(
              width: 15,
              height: 15,
              child: Checkbox(
                activeColor: activeButtonColor,
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              consentText,
              style: _consentTextStyle,
            ),
          )
        ],
      ),
    );
  }

  TextStyle get _consentTextStyle {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.08,
        fontFamily: 'Figtree',
        color: primaryDarkColor);
  }
}
