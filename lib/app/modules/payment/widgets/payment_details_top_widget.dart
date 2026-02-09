import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../res.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';

class PaymentDetailsTopWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onCloseClicked;
  const PaymentDetailsTopWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onCloseClicked,
  }) : super(key: key);

  Widget _closeButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: onCloseClicked,
        icon: const Icon(
          Icons.clear_rounded,
          color: infoTextColor,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff151742),
              Color(0xff1C468B),
              Color(0xff1C478D),
            ],
            stops: [0.0, 0.63, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _closeButton(),
            SvgPicture.asset(
              Res.lowGrowSuccessImg,
              width: 175,
              height: 175,
            ),
            verticalSpacer(8),
            _topTitleWidget(),
            verticalSpacer(6),
            _topSubtitleWidget(),
            verticalSpacer(24),
          ],
        ));
  }

  Widget _topTitleWidget() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: offWhiteColor,
      ),
    );
  }

  Widget _topSubtitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: offWhiteColor,
          height: 1.6,
        ),
      ),
    );
  }
}
