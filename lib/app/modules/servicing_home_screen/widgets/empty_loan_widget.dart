import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class EmptyLoanWidget extends StatelessWidget {
  const EmptyLoanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Res.noLoansSVG),
          const SizedBox(
            height: 20,
          ),
           Text(
            "No Active Loans?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: navyBlueColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Secure Top Rates with a New Loan on Homepage!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: darkBlueColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                color: navyBlueColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "Go to Homepage",
                  style: TextStyle(
                    color: offWhiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
