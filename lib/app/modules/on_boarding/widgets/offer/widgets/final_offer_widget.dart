import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/offer_bottom_banner.dart';
import 'package:privo/app/common_widgets/offer_stepper_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_screen_offer_screen.dart';
import 'package:privo/res.dart';
import '../../../../../common_widgets/gradient_button.dart';
import '../../../../home_screen_module/widgets/home_page_top_widget.dart';
import '../../../../home_screen_module/widgets/info_message_widget.dart';
import '../../pdf_letter/pdf_letter_logic.dart';
import '../offer_logic.dart';

class FinalOfferWidget extends StatelessWidget {
  FinalOfferWidget({Key? key}) : super(key: key);

  final logic = Get.find<OfferLogic>();

  Widget _carousalInfoTextWidget() {
    return IgnorePointer(
      ignoring: true,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 50,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 6),
          autoPlayAnimationDuration: const Duration(
            seconds: 3,
          ),
          pauseAutoPlayOnManualNavigate: true,
          pauseAutoPlayOnTouch: false,
          autoPlay: true,
        ),
        items: getInfoTextWidgetList,
      ),
    );
  }

  List<Widget> get getInfoTextWidgetList {
    return logic.infoTexts.map((i) {
      return InfoMessageWidget(
        infoMessage: i.infoText,
        infoIcon: i.iconPath,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferLogic>(
      id: 'clp_offer_page',
      builder: (logic) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeScreenTopWidget(
                      showHamburger: false,
                      infoText: "",
                      infoTextWidget: _carousalInfoTextWidget(),
                      widget: HomeScreenOfferScreen(
                        isUpgradeEligible:
                        logic.responseModel.isUpgradeEligible,
                        minTenure: logic.responseModel.offerSection!.minTenure,
                        interest: logic.responseModel.offerSection!.interest,
                        limitAmount:
                        logic.responseModel.offerSection!.limitAmount,
                        maxTenure: logic.responseModel.offerSection!.maxTenure,
                        processingFee:
                        logic.responseModel.offerSection!.processingFee,
                        processingFeeModel:
                        logic.responseModel.processingFeeModel,
                        isOnboardingOfferScreen: true,
                        isPartnerFlow:
                        logic.onBoardingOfferNavigation?.isPartnerFlow() ??
                            false,
                        onPressOfferUpgrade: logic.onOfferUpgradePressed,
                      ),
                      background: Res.confetti,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const OfferStepper(),
                    const SizedBox(
                      height: 40,
                    ),
                    OfferBottomBanner(),
                  ],
                ),
              ),
            ),
            if (!logic.isPageLoading)
              GetBuilder<OfferLogic>(builder: (logic) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70, vertical: 20),
                  child: GradientButton(
                      title: "Continue",
                      enabled: true,
                      isLoading: logic.isButtonLoading,
                      onPressed: () {
                        logic.onContinuePressed();
                      },
                      buttonTheme: AppButtonTheme.dark),
                );
              }),
          ],
        );
      },
    );
  }

  TextStyle get consentTextStyle {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.08,
        color: Color(0xff727272));
  }

  TextStyle get bodyTextStyle {
    return const TextStyle(
      fontSize: 14,
      letterSpacing: 0.11,
      color: Color(0xff344157),
    );
  }

  TextStyle amountTextStyle({required double fontSize}) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      letterSpacing: 0.18,
      color: const Color(0xff344157),
    );
  }

  TextStyle get subtitleTextStyle {
    return const TextStyle(
      fontSize: 12,
      letterSpacing: 0.09,
      color: Color(0xff344157),
    );
  }

  TextStyle get titleTextStyle {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      color: Color(0xff0E9823),
    );
  }
}
