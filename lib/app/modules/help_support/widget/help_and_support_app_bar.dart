import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/app_bar_bottom_divider.dart';

import '../../../theme/app_colors.dart';

class HelpAndSupportAppBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function()? onClosePressed;
  const HelpAndSupportAppBar({
    Key? key,
    required this.title,
    this.subTitle = "",
    this.onClosePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        color: navyBlueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  _closeButton(),
                ],
              ),
              if (subTitle.isNotEmpty) _subtitleWidget()
            ],
          ),
        ),
        const AppBarBottomDivider(),
      ],
    );
  }

  Widget _closeButton() {
    return InkWell(
      onTap: () => onClosePressed?.call() ?? Get.back(),
      child: const Icon(
        Icons.clear_rounded,
        color: appBarTitleColor,
      ),
    );
  }

  Widget _subtitleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        subTitle,
        style: GoogleFonts.poppins(
            color: darkBlueColor, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
