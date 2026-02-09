import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(Res.logoutSVG),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Logout?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: darkBlueColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Are you sure you want to logout?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _stayCTA(),
            const SizedBox(
              width: 15,
            ),
            _logoutCTA()
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  InkWell _logoutCTA() {
    return InkWell(
      onTap: () {
        Get.back(result: true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: darkBlueColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: darkBlueColor,
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(
            "Logout",
            style: TextStyle(
              color: offWhiteColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  InkWell _stayCTA() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: darkBlueColor,
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(
            "Stay",
            style: TextStyle(
              color: darkBlueColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
