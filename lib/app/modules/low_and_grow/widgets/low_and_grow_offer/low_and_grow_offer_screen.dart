import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_top_widget.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/low_and_grow_offer_logic.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/widgets/low_and_grow_offer_top_widget.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/consent_text_widget.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';
import 'widgets/low_and_grow_special_offer_coin_list.dart';

class LowAndGrowOfferScreen extends StatefulWidget {
  const LowAndGrowOfferScreen({Key? key}) : super(key: key);

  @override
  State<LowAndGrowOfferScreen> createState() => _LowAndGrowOfferScreenState();
}

class _LowAndGrowOfferScreenState extends State<LowAndGrowOfferScreen> {
  final logic = Get.find<LowAndGrowLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (logic.model.upgradedFeatures != null) ...[
                  HomeScreenTopWidget(
                    widget: LowAndGrowOfferTopWidget(
                      tenure: logic.model.upgradedFeatures!.tenure == 1
                          ? logic.computeTenureText()
                          : "",
                      enhancedTenure: logic.computeEnhancedTenureText(),
                      strikeThroughProcessingFee:
                          logic.model.upgradedFeatures!.processingFee == 1
                              ? logic.model.offerSection!.processingFee
                              : "",
                      model: logic.model,
                    ),
                    infoPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                    infoText:
                        "Rewarding your timely EMI payments claim your exclusive offer now!",
                    showHamburger: false,
                    background: Res.bg_confetti,
                    infoIcon: Res.starUpgrade,
                  ),
                  LowAndGrowSpecialOfferCoinList(
                    roi: logic.model.upgradedFeatures!.interest,
                    limit: logic.model.upgradedFeatures!.limitAmount,
                    tenure: logic.model.upgradedFeatures!.tenure,
                    processingFee: logic.model.upgradedFeatures!.processingFee,
                  ),
                ],
              ],
            ),
          ),
        ),
        _upgradeConsentWithButtonWidget(),
      ],
    );
  }

  Widget _upgradeConsentWithButtonWidget() {
    return Column(
      children: [
        GetBuilder<LowAndGrowOfferLogic>(
          id: 'SPECIAL_OFFER_CHECK_BOX_KEY',
          builder: (logic) {
            return _consentCheckBoxWithText(logic);
          },
        ),
        GetBuilder<LowAndGrowOfferLogic>(
          id: 'button',
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: GradientButton(
                title: "Upgrade now",
                onPressed: logic.onUpgradePressed,
                enabled: logic.isConsentChecked,
              ),
            );
          },
        ),
        InkWell(
          onTap: () {
            AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: WebEngageConstants.lgNotInterestedClicked);
            Get.back();
          },
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                "Not interested",
                style: _titleTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Padding _consentCheckBoxWithText(LowAndGrowOfferLogic logic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      child: ConsentTextWidget(
        value: logic.isConsentChecked,
        onChanged: (value) => logic.toggleIsChecked(value!),
        consentText:
            "I hereby authorise Credit Saison India to upgrade my credit line offer and agree to Terms and Conditions.",
        checkBoxState: CheckBoxState.postRegCheckBox,
        consentType: ConsentType.lowAndGrow,
        policyList: logic.termAndConditionPolicyList,
      ),
    );
  }

  TextStyle _titleTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xff1D478E),
    );
  }
}
