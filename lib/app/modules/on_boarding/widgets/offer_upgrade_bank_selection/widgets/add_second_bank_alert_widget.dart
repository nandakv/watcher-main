import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/theme/app_colors.dart';

class AddSecondBankAlertWidget extends StatelessWidget {
  const AddSecondBankAlertWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Don't Miss Out on a Better Offer!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: darkBlueColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "You might miss a better deal by not adding your\nsecond bank account. Are you sure?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: secondaryDarkColor,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GradientButton(
          onPressed: () {
            Get.back(result: true);
          },
          edgeInsets: const EdgeInsets.symmetric(
            horizontal: 41,
            vertical: 14,
          ),
          title: "Add Second Bank",
          bottomPadding: 3,
        ),
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text(
            "Continue Without Adding",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: darkBlueColor,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
