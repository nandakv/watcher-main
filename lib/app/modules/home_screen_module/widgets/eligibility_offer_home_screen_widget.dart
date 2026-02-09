import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';

import '../../../common_widgets/gradient_button.dart';
import '../../on_boarding/widgets/offer/widgets/eligibility_offer_widget.dart';
import '../home_screen_logic.dart';
import 'home_screen_browser_to_native_top_offer_widget.dart';

class EligibilityOfferHomeScreenWidget extends StatelessWidget {
  EligibilityOfferHomeScreenWidget({
    Key? key,
    required this.eligibilityOfferDetailsHomeScreenType,
    required this.lpcCard,
  }) : super(key: key);

  final LpcCard lpcCard;
  final logic = Get.find<HomeScreenLogic>();
  final EligibilityOfferDetailsHomeScreenType
      eligibilityOfferDetailsHomeScreenType;

  @override
  Widget build(BuildContext context) {
    return EligibilityOfferScreenWidget(
        scaffoldKey: logic.homePageScaffoldKey,
        bottomTitleText:
            "Complete your application to unlock your ultimate Credit Line offer",
        bottomSubtitleText: "",
        topWidget: HomeScreenBrowserToNativeTopOfferWidget(
          title: eligibilityOfferDetailsHomeScreenType.title,
          subtitle: eligibilityOfferDetailsHomeScreenType.subtitle,
          roi: eligibilityOfferDetailsHomeScreenType.roi,
          amount: "₹${eligibilityOfferDetailsHomeScreenType.limitAmount}",
          ctaButton: _eligibilityCTAButton(),
        ));
  }

  Widget _eligibilityCTAButton() {
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      tag: lpcCard.appFormId,
      builder: (logic) {
        return GradientButton(
          buttonTheme: AppButtonTheme.light,
          onPressed: logic.computeUserStateAndNavigate,
          title: eligibilityOfferDetailsHomeScreenType.buttonText,
        );
      },
    );
  }
}
