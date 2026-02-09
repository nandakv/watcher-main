import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/res.dart';

import '../../../models/home_card_rich_text_values.dart';
import 'home_screen_widget.dart';

class PartnerPreApprovedHomePageCard extends StatelessWidget {
  final String limitAmount;
  final LpcCard lpcCard;
  PartnerPreApprovedHomePageCard(
      {Key? key, required this.limitAmount, required this.lpcCard})
      : super(key: key);

  final HomeCardTexts homeCardTexts = HomeCardTexts();

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return HomeScreenWidget(
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        image: Res.coins,
        titleTextValues: homeCardTexts.fetchLPCTitle(lpcCard.loanProductName),
        bodyTextValues: homeCardTexts.partnerPreOfferBodyTextValues(
            limitAmount: limitAmount),
        onRightArrowClicked: () => logic.partnerFlowKnowMore(limitAmount),
      ),
      lpcCard: lpcCard,
    );
  }
}
