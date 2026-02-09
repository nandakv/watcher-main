import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/app_stepper.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/gradient_button.dart';
import '../../../../home_screen_module/widgets/home_page_top_widget.dart';
import '../../offer/offer_logic.dart';
import '../offer_upgrade_bank_selection_logic.dart';

class UpgradeOfferInfoPage extends StatelessWidget {
  UpgradeOfferInfoPage({Key? key}) : super(key: key);

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeScreenTopWidget(
                  widget: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: logic.onUpgradeInfoPageCloseClicked,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Boost Your Credit Limit!",
                          style: GoogleFonts.poppins(
                            color: skyBlueColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "You are eligible for a Credit Line\nUpgrade",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: offWhiteColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SvgPicture.asset(
                          Res.lowGrowSuccessImg,
                          width: 175,
                          height: 175,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  infoText: "",
                  showHamburger: false,
                  background: Res.bg_confetti,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Added benefits",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          specialOfferCoin(
                            image: Res.intrest_down_arrow_svg,
                            title: _benefitsRichTextStyle(
                              texts: [
                                "Up to ",
                                "5% lower\ninterest",
                              ],
                            ),
                          ),
                          specialOfferCoin(
                            image: Res.lowGrowLimit,
                            title: _benefitsRichTextStyle(
                              texts: [
                                "Up to ",
                                "20% higher\ncredit limit",
                              ],
                            ),
                          ),
                          specialOfferCoin(
                            image: Res.lowGrowTenure,
                            title: _benefitsRichTextStyle(
                              texts: [
                                "Improved ",
                                "\nRepayment Tenure",
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "How it works",
                        style: TextStyle(
                          color: accountSummaryTitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppStepper(
                        horizantalPadding: 0,
                        currentStep: 0,
                        appSteps: [
                          AppStep(
                            child: Column(
                              children: [
                                Text(
                                  'Select your bank',
                                  style: _appStepperTextStyle(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          AppStep(
                            child: Column(
                              children: [
                                Text(
                                  'Verify with your bank statement',
                                  style: _appStepperTextStyle(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          AppStep(
                            child: Column(
                              children: [
                                Text(
                                  'Generate your offer',
                                  style: _appStepperTextStyle(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GradientButton(
            onPressed: logic.onClickUpgradeNow,
            title: "Upgrade now",
            bottomPadding: 10,
          ),
        ),
      ],
    );
  }

  RichText _benefitsRichTextStyle({required List<String> texts}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: texts.first,
        style: _titleTextStyle(fontSize: 9, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: texts.last,
            style: _titleTextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  TextStyle _appStepperTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      color: darkBlueColor,
      fontSize: 12,
    );
  }

  Widget specialOfferCoin(
      {String? image, bool rotateImage = false, required RichText title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: CircleAvatar(
              backgroundColor: const Color(0xff1161742).withOpacity(1),
              maxRadius: 40,
              child: SvgPicture.asset(image!),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          title
        ],
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
