import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueBorderButton extends StatelessWidget {
  const BlueBorderButton({
    Key? key,
    this.title = "Continue",
    required this.onPressed,
    required this.buttonColor,
    this.borderRadius = 10,
    this.contentPaddingVertical = 15,
  }) : super(key: key);

  final String? title;
  final Function onPressed;
  final Color buttonColor;
  final double borderRadius;
  final double contentPaddingVertical;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onPressed(),
        child: Container(
          width: double.infinity,
          // height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: buttonColor, width: 1),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: contentPaddingVertical),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: buttonColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
