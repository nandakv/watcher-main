import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

class PollingTitleWidget extends StatelessWidget {
  final String title;

  const PollingTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        height: 1.25,
        fontSize: 20,
        color: navyBlueColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.16,
      ),
    );
  }
}
