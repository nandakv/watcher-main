import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key, this.enabled = true, required this.onTap})
      : super(key: key);

  final Function onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onTap() : null,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: appBackgroundColor,
          border: Border.all(color: const Color(0xFFF0EFEF), width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage(Res.google),
                height: 28,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Continue With Google",
                style: darkBlueButtonTextStyle(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
