import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

InputDecoration textFieldDecoration({
  required String label,
  String hint = "",
  bool isMandatory = false,
  Widget? prefix,
  Widget? suffixIcon,
  Widget? counterWidget,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xffA8A8A8),
      fontFamily: "Figtree",
    ),
    label: RichText(
      text: TextSpan(
          text: label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: secondaryDarkColor,
              letterSpacing: 0.16,
              fontFamily: "Figtree"),
          children: [
            if (isMandatory)
              const TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.red,
                  )),
          ]),
    ),
    prefix: prefix,
    suffixIcon: suffixIcon,
    errorMaxLines: 2,
    counter: counterWidget,
    contentPadding: const EdgeInsets.only(bottom: 5),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: secondaryDarkColor,
      ),
    ),
  );
}
