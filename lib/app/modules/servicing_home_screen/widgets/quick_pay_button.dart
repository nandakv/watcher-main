import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class QuickPayButton extends StatelessWidget {
  const QuickPayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 240,
      child: Text(
        "Quick Pay",
        style: overPassStyle(
            color: quickPayButtonColor,
            fontsize:12,
            fontWeight: FontWeight.w900
        ),
      ),
      decoration: BoxDecoration(
          borderRadius:
             const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
              color: quickPayButtonColor,
              width: 1)),
    );
  }
}
