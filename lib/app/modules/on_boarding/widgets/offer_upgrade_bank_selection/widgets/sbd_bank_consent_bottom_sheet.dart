import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';

import '../../../../../common_widgets/gradient_button.dart';
import '../../../../../common_widgets/spacer_widgets.dart';
import '../../../../../theme/app_colors.dart';

class SBDBankConsentBottomSheet extends StatelessWidget {
  SBDBankConsentBottomSheet({super.key});

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.back();
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Consent",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: primaryDarkColor,
            ),
          ),
          const VerticalSpacer(8),
          const Text(
            "I confirm that I own either my residence or business address. I understand I must provide proof of ownership when requested and I will be responsible for any losses incurred.",
            style: TextStyle(
              color: primaryDarkColor,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
          const VerticalSpacer(24),
          GetBuilder<OfferUpgradeBankSelectionLogic>(
            id: logic.CONSENT_CTA_ID,
            builder: (logic) {
              return GradientButton(
                isLoading: logic.consentCTALoading,
                onPressed: logic.submitConsent,
                title: "Agree and Confirm",
              );
            },
          ),
          const VerticalSpacer(32),
        ],
      ),
    );
  }
}
