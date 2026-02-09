import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/contact_us/contact_us_logic.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class ContactUsWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  ContactUsWidget({super.key, required this.title, required this.subTitle});

  final logic = Get.put(ContactUsLogic());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.9,
            ),
          ),
          const VerticalSpacer(2),
          InkWell(
            onTap: logic.onContactUs,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$subTitle",
                  style: const TextStyle(
                    color: skyBlueColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  width: 5,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: skyBlueColor.withOpacity(0.6),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: skyBlueColor,
                  size: 18,
                ),
              ],
            ),
          ),
          const VerticalSpacer(24),
        ],
      ),
    );
  }
}
