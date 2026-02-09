import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';

import '../../../../theme/app_colors.dart';

class OurLegacyWidget extends StatelessWidget {
  final logic = Get.find<SignInScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Our Legacy",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkBlueColor),
          ),
          verticalSpacer(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              logic.legacyData.length,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFeff9fe),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.5, vertical: 16),
                      child: Text(
                        logic.legacyData[index].title,
                        style: const TextStyle(
                            color: darkBlueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ),
                  verticalSpacer(4),
                  Text(
                    logic.legacyData[index].value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
