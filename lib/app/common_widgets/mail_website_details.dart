import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MailWebSiteDetails extends StatelessWidget {
  MailWebSiteDetails(
      {Key? key,
      required this.contactType,
      required this.img,
      required this.contactId,
      this.onTap})
      : super(key: key);

  String img;
  String contactType;
  String contactId;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          imgContainer(img),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  contactType,
                  style: lightTextStyle,
                ),
              ),
              Flexible(
                child: Text(
                  contactId,
                  style: boldTextStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
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
          padding: const EdgeInsets.all(10), child: SvgPicture.asset(img)),
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
}
