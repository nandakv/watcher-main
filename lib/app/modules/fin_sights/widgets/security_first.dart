import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class SecurityFirst extends StatelessWidget {
  const SecurityFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          SvgPicture.asset(Res.securityFirst),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Security first!",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: navyBlueColor),
                ),
                const Text(
                  "Your data is safe with us. We prioritise your privacy and security at every step",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: secondaryDarkColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
