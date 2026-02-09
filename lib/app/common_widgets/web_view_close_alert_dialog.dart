import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';

import '../theme/app_colors.dart';
import 'blue_border_button.dart';

class WebViewCloseAlertDialog extends StatelessWidget {
  const WebViewCloseAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Are you sure you want to cancel?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlueColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GradientButton(
                    onPressed: () => Get.back(result: false),
                    edgeInsets: const EdgeInsets.symmetric(vertical: 10),
                    title: "No",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlueBorderButton(
                    onPressed: () => Get.back(result: true),
                    buttonColor: darkBlueColor,
                    title: "Yes",
                    borderRadius: 54,
                    contentPaddingVertical: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
