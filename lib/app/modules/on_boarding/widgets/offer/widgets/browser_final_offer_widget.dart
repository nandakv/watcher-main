import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';

import '../../../../../common_widgets/gradient_button.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../utils/app_functions.dart';
import '../../../../home_screen_module/widgets/browser_final_offer_screen_widget.dart';
import '../../../../home_screen_module/widgets/home_screen_browser_to_native_top_offer_widget.dart';

class BrowserFinalOfferScreen extends StatelessWidget {
  BrowserFinalOfferScreen({Key? key}) : super(key: key);

  final logic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    return BrowserFinalOfferScreenWidget(
      showHamburger: false,
      bottomWidget: _bottomWidget(),
      topWidget: Column(
        children: [
          _closeButton(),
          HomeScreenBrowserToNativeTopOfferWidget(
            title: logic.responseModel.title,
            subtitle: logic.responseModel.subtitle,
            roi: logic.responseModel.offerSection!.interest.toString(),
            amount:
                "₹${AppFunctions().parseIntoCommaFormat(logic.responseModel.offerSection!.limitAmount.toString())}",
            minTenure: "${logic.responseModel.offerSection!.minTenure.toInt()}",
            maxTenure: "${logic.responseModel.offerSection!.maxTenure.toInt()}",
            processingFee: logic.responseModel.offerSection!.processingFee,
          ),
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _verticalSpacer(10),
            _bottomText(),
            _verticalSpacer(32),
            _CTAButton(),
          ],
        ),
      ),
    );
  }

  SizedBox _verticalSpacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  Text _bottomText() {
    return Text(
      "Accept the agreement and access your dream Credit Line",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: navyBlueColor,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.7,
      ),
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

  Widget _CTAButton() {
    return GetBuilder<OfferLogic>(
      id: logic.BUTTON_ID,
      builder: (logic) {
        return GradientButton(
          isLoading: logic.isButtonLoading,
          onPressed: logic.onKycProceed,
          title: logic.responseModel.buttonText,
        );
      },
    );
  }
}
