import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class InfoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _gradientBorderDecoration(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF5FCFC),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: navyBlueColor,
              child: SvgPicture.asset(
                Res.info_bulb,
                fit: BoxFit.scaleDown,
                height: 12,
                width: 12,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Flexible(
              flex: 5,
              child: Text(
                "The EMI Calculator provides estimates for demonstration purposes only. It doesn't guarantee loan eligibility or actual loan terms.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    height: 1.2,
                    color: navyBlueColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _gradientBorderDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        gradient: const LinearGradient(colors: [
          Color(0xFF8FD1EC),
          Color(0xFF229ACE),
        ]),
        border: Border.all(
          color: Color(0xFF8FD1EC),
          width: 1,
        ));
  }
}
