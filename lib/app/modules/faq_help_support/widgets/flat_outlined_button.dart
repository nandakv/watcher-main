import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class FlatOutlinedButton extends StatelessWidget {
  bool isFilled;
  String title;
  void Function()? onPressed;
  EdgeInsets? edgeInsets;

  FlatOutlinedButton(
      {this.isFilled = false,
      required this.title,
      required this.onPressed,
      this.edgeInsets})
      : super();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: _outlinedButtonStyle(isFilled),
      child: Text(
        title,
        style: _titleTextStyle(),
      ),
    );
  }

  TextStyle _titleTextStyle() {
    return TextStyle(
        color: isFilled ? Colors.white : const Color(0xFF1D478E),
        fontWeight: FontWeight.w600,
        fontSize: 10);
  }

  ButtonStyle _outlinedButtonStyle(bool isFilled) {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(
            width: 0.8,
            color: Color(0xFF1D478E),
          ),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 9,
        ),
      ),
      foregroundColor: MaterialStateProperty.all(darkBlueColor),
      backgroundColor: MaterialStateProperty.all(
          isFilled ? const Color(0xFF1D478E) : Colors.transparent),
      side: MaterialStateProperty.all(
        const BorderSide(color: Color(0xFF1D478E)),
      ),
    );
  }
}
