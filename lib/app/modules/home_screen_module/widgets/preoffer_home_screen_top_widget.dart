import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/processing_fee.dart';

import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/text_row_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/ui_constant_text.dart';

import '../../../common_widgets/animated_text_widget.dart';

class PreOfferHomeScreenTopWidget extends StatelessWidget {
  PreOfferHomeScreenTopWidget({
    Key? key,
    required this.lpcCard,
  }) : super(key: key);

  final LpcCard lpcCard;
  get logic => Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        logic.homeScreenModel.offerText.isNotEmpty &&
                logic.homeScreenModel.processingFeeModel != null
            ? ProcessingFee(
                processingFeeModel: logic.homeScreenModel.processingFeeModel!,
              )
            : const SizedBox(),
        SizedBox(
          height: logic.homeScreenModel.offerText.isNotEmpty ? 15 : 0,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  applyForCreditLineHeader,
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                      letterSpacing: 0.58,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 20,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedTextWidget(
                      bodyTexts: [
                        applyForCreditLineSub,
                        "Repay easily and withdraw money over and over",
                        "Approval in seconds. Disbursal in minutes"
                      ],
                      alignment: Alignment.centerLeft,
                      textAlign: TextAlign.left,
                      textStyle: _subTitleTextStyle(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _buttonAndRowWidget(),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonAndRowWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GradientButton(
            onPressed: () {
              logic.computeUserStateAndNavigate();
            },
            title: logic.homeScreenModel.buttonText,
            buttonTheme: AppButtonTheme.light,
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: TextRowWidget(
              titles: applyForCreditLineRow,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _subTitleTextStyle() {
    return TextStyle(
        fontSize: 12,
        fontFamily: 'Figtree',
        shadows: [
          Shadow(
              color: infoTextColor.withOpacity(0.6),
              offset: const Offset(0, 1),
              blurRadius: 2)
        ],
        color: Colors.white,
        fontWeight: FontWeight.w500);
  }
}
