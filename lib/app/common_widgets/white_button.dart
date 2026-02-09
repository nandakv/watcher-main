import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  const WhiteButton(
      {Key? key,
      this.title = "Continue",
      required this.onPressed,
      this.enabled = true})
      : super(key: key);

  final String title;
  final Function onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: enabled ? Colors.white : const Color(0xffAAAAAA),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: darkBlueButtonTextStyle(enabled),
            ),
          ),
        ),
      ),
    );
  }
}
