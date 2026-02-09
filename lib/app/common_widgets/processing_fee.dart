import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/models/processing_fee_model.dart';
import 'package:privo/res.dart';

class ProcessingFee extends StatelessWidget {
  ProcessingFee(
      {Key? key,
        required this.processingFeeModel})
      : super(key: key);




  ProcessingFeeModel processingFeeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

      ///To extend container only till 80% of the screen as per design
      margin: EdgeInsets.only(right: Get.width * 0.1),
      decoration: const BoxDecoration(
        color: Color(0xff161742),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: processingFeeModel.offerFirstHeaderTitle,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          letterSpacing: 0.41,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: processingFeeModel.offerSecondHeaderTitle,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 0.24,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: processingFeeModel.offerHeaderSubTitle,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          letterSpacing: 0.18,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}