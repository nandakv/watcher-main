import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res.dart';

class UPLPreFulfillmentWaitHomePageWidget extends StatelessWidget {
  final String title;
  final String subTitle;

  const UPLPreFulfillmentWaitHomePageWidget(
      {Key? key, this.title = "", this.subTitle = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                Container(
                  color: const Color(0xff1D478E),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    title,
                    style: _titleTextStyle(const Color(0xffFFF3EB)),
                    // textAlign: TextAlign.center
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(subTitle, style: _messageTextStyle
                    //   textAlign: TextAlign.center
                    ),
                const SizedBox(
                  height: 60,
                ),
                SvgPicture.asset(Res.applicationInProgressFull),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _titleTextStyle(Color color) {
    return GoogleFonts.poppins(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: .08);
  }

  TextStyle get _messageTextStyle {
    return const TextStyle(
        color: Color(0xff1D478E),
        fontSize: 14,
        fontWeight: FontWeight.w300,
        fontFamily: 'Figtree');
  }
}
