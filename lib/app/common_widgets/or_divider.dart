import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFF8F8F8).withOpacity(0.5),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "Or",
          style: overPassStyle(
            fontsize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFF8F8F8).withOpacity(0.5),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFF8F8F8).withOpacity(0.5),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
