import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/home_screen_loading_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/eligibility_offer/eligibility_offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/eligibility_offer_widget.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_functions.dart';
import '../../../home_screen_module/widgets/home_screen_browser_to_native_top_offer_widget.dart';

class EligibilityOffer extends StatefulWidget {
  const EligibilityOffer({Key? key}) : super(key: key);

  @override
  State<EligibilityOffer> createState() => _EligibilityOfferState();
}

class _EligibilityOfferState extends State<EligibilityOffer>
    with AfterLayoutMixin {
  final logic = Get.find<EligibilityOfferLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EligibilityOfferLogic>(
      builder: (logic) {
        return logic.isPageLoading
            ? const HomeScreenLoadingWidget()
            : _finalOfferWidget();
      },
    );
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.clear_rounded,
          color: infoTextColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _eligibilityCTAButton() {
    return GetBuilder<EligibilityOfferLogic>(
      id: logic.BUTTON_ID,
      builder: (logic) {
        return GradientButton(
          isLoading: logic.isButtonLoading,
          onPressed: logic.onEligibilityOfferKycProceed,
          title: logic.eligibilityOfferModel.buttonText,
        );
      },
    );
  }

  Widget _finalOfferWidget() {
    return EligibilityOfferScreenWidget(
      showHamburger: false,
      ctaButtonWidget: _eligibilityCTAButton(),
      bottomTitleText: "Complete KYC to unlock your ultimate Credit Line offer",
      bottomSubtitleText: "Keep your Aadhaar details handy",
      topWidget: Column(
        children: [
          _closeButton(),
          HomeScreenBrowserToNativeTopOfferWidget(
            title: logic.eligibilityOfferModel.title,
            subtitle: logic.eligibilityOfferModel.subtitle,
            roi: logic.eligibilityOfferModel.roi,
            amount:
                "₹${AppFunctions().parseIntoCommaFormat(logic.eligibilityOfferModel.limitAmount)}",
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }
}
