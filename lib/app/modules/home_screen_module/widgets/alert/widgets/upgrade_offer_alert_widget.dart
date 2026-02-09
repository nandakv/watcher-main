import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../home_screen_logic.dart';
import '../../home_page_right_arrow_widget.dart';

class UpgradeOfferAlertWidget extends StatelessWidget {
  UpgradeOfferAlertWidget({
    Key? key,
    required this.lpcCard,
  }) : super(key: key);

  final LpcCard lpcCard;
  get homeScreenCardLogic => Get.find<PrimaryHomeScreenCardLogic>(
    tag: lpcCard.appFormId,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5BC4F0).withOpacity(0.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Res.upgradeOfferAlert),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: _infoTextWidget(),
          ),
          const SizedBox(
            width: 10,
          ),
          HomePageRightArrowWidget(
            onTap: () => homeScreenCardLogic.onHomeScreenOfferUpgradeCTAPressed(
              actionType: "upgrade",
            ),
            color: darkBlueColor,
          )
        ],
      ),
    );
  }

  Widget _infoTextWidget() {
    return const Text(
      "Congratulations! You are eligible for offer upgrade",
      style: TextStyle(
        fontSize: 12,
        height: 1.6,
        color: darkBlueColor,
      ),
    );
  }
}
