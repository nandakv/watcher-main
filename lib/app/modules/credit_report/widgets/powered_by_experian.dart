import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class PoweredByExperian extends StatelessWidget {
  const PoweredByExperian({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Powered by",
            style: TextStyle(fontSize: 12, color: secondaryDarkColor),
          ),
          const SizedBox(
            width: 8,
          ),
          SvgPicture.asset(
            Res.experian,
            height: 18,
          ),
        ],
      ),
    );
  }
}
