import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../models/home_screen_card_model.dart';
import '../../../home_screen_logic.dart';

class CreditLineExpiryAlert extends StatelessWidget {
  const CreditLineExpiryAlert({
    Key? key,
    this.withdrawalDetailsHomeScreenType,
    required this.lpcCard,
  }) : super(key: key);

  final LpcCard lpcCard;

  get logic => Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);
  final WithdrawalDetailsHomeScreenType? withdrawalDetailsHomeScreenType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1D478E),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoTextWidget(),
                verticalSpacer(8),
                _ctaButton(),
              ],
            ),
          ),
          SvgPicture.asset(Res.creditLineExpiryAlert),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return InkWell(
        onTap: () => logic.onCreditLineExpiryAlert(
              withdrawalDetailsHomeScreenType,
              lpcCard,
            ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            logic.homeScreenModel.buttonText,
            style: const TextStyle(
              color: skyBlueColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  Widget _infoTextWidget() {
    return const Text(
      "Your credit limit is about to expire, take action now!",
      style: TextStyle(
        fontSize: 10,
        height: 1.4,
        color: offWhiteColor,
      ),
    );
  }
}
