import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WithdrawalErrorPage extends StatelessWidget {
  WithdrawalErrorPage({
    Key? key,
    required this.title,
    required this.assetImage,
    this.isSVG = true,
  }) : super(key: key);

  final String title;
  final String assetImage;
  final bool? isSVG;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Uh-oh!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: redTextColor,
                fontSize: 24,
                letterSpacing: 0.18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: redTextColor, fontSize: 16, letterSpacing: 0.12),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (isSVG!)
            Expanded(
              child: SvgPicture.asset(
                assetImage,
              ),
            ),
          if (!isSVG!)
            Expanded(
              child: Image.asset(
                assetImage,
              ),
            ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Cheer up and try again",
            style: TextStyle(
                fontSize: 16, letterSpacing: 0.12, color: Color(0xff344157)),
          ),
          const SizedBox(
            height: 20,
          ),
          BlueButton(
              onPressed: () {
                Get.back();
              },
              buttonColor: activeButtonColor,
              title: "Try Again"),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
