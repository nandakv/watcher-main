import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';
import '../../on_boarding/widgets/e_sign/e_sign_logic.dart';

class ESignAgreementScreen extends StatefulWidget {
  final String bottomText;
  final String buttonText;
  final bool isRejected;
  final String eSignRejectedText;
  final String title;

  const ESignAgreementScreen(
      {Key? key,
      this.bottomText = "",
      this.buttonText = "Review & Accept",
      this.isRejected = false,
      this.eSignRejectedText = "",
      this.title =
          "Please review and accept the loan agreement to process your disbursal"})
      : super(key: key);

  @override
  State<ESignAgreementScreen> createState() => _ESignAgreementScreenState();
}

class _ESignAgreementScreenState extends State<ESignAgreementScreen>
    with AfterLayoutMixin {
  final logic = Get.find<ESignLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ESignLogic>(
      id: 'page',
      builder: (logic) {
        return logic.isPageLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: OnboardingStepOfWidget(

                        title: "E-Sign",
                      ),
                    ),
                    Text(
                      widget.eSignRejectedText,
                      style: widget.isRejected
                          ? _rejectedTextStyle
                          : _titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.title,
                      style: widget.isRejected
                          ? _rejectTextStyle
                          : _titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: SvgPicture.asset(Res.eSignAgreement),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      widget.bottomText,
                      style: _bodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    GetBuilder<ESignLogic>(
                      id: 'button',
                      builder: (logic) {
                        return GradientButton(
                          onPressed: () => logic.onESignContinueTapped(),
                          title: widget.buttonText,
                          isLoading: logic.isButtonLoading,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
      },
    );
  }

  TextStyle get _bodyTextStyle => const TextStyle(
        fontSize: 12,
        color: Color(0xFF707070),
      );

  TextStyle get _titleTextStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
      );

  TextStyle get _rejectTextStyle =>
      const TextStyle(fontSize: 16, color: Color(0xFFEE3D4B));

  TextStyle get _rejectedTextStyle {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.58,
      color: const Color(0xFFEE3D4B),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
