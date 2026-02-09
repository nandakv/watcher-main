import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';

import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../theme/app_colors.dart';

class HomePageErrorBottomSheetWidget extends StatelessWidget {
  HomePageErrorBottomSheetWidget({Key? key}) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BottomSheetWidget(
        enableCloseIconButton: false,
        childPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: 24,
        ),
        child: Column(
          children: [
            const Text(
              "Encountering a glitch while loading details. Refresh to retry.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBlueColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Get.back();
                logic.fetchHomePageV2();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 10,
                  ),
                  child: Text(
                    "Refresh",
                    style: TextStyle(
                      color: offWhiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
