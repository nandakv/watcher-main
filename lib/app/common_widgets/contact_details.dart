import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/res.dart';

class ContactDetails extends StatelessWidget {
  final Function()? onTap;
  const ContactDetails({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          imgContainer(Res.phoneImg),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  "1800-1038-961",
                  style: boldTextStyle,
                ),
              ),
              Flexible(
                child: Text(
                  "Monday to Saturday | 9:30 AM to 6:30 PM",
                  style: lightTextStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextStyle get lightTextStyle {
    return GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: const Color(0xff707070),
    );
  }

  TextStyle get boldTextStyle {
    return GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: .11,
        color: const Color(0xff004097));
  }

  Widget imgContainer(String img) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff284689),
        borderRadius: BorderRadius.circular(9),
      ),
      height: 40,
      width: 37,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(img),
      ),
    );
  }
}
