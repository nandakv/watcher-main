import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class BackArrowAppBar extends StatelessWidget {
  String title;
  Function() onBackPress;

  BackArrowAppBar({super.key, required this.title, required this.onBackPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              InkWell(
                  onTap: onBackPress,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      Res.arrowBack,
                      width: 15,
                      height: 15,
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: navyBlueColor),
              )
            ],
          ),
        ),
        const Divider(
          color: lightGrayColor,
          height: 0.6,
          thickness: 0.6,
        )
      ],
    );
  }
}
