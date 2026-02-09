import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'home_screen_app_bar.dart';

class HomePageFlowBlockerScreen extends StatelessWidget {
  HomePageFlowBlockerScreen({
    Key? key,
  }) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: offWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            HomeScreenAppBar(),
            const Spacer(),
            SvgPicture.asset(Res.applicationInProgress),
            const SizedBox(
              height: 10,
            ),
            Text(
              logic.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: darkBlueColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                logic.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: darkBlueColor,
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            SvgPicture.asset(
              Res.poweredByCSSmall,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
