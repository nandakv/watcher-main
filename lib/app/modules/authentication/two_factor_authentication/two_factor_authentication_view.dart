import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/app/modules/authentication/two_factor_authentication/two_factor_authentication_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../res.dart';
import '../../../common_widgets/gradient_button.dart';

class TwoFactorAuthenticationPage extends StatefulWidget {
  const TwoFactorAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<TwoFactorAuthenticationPage> createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage>
    with AfterLayoutMixin {
  final TwoFactorAuthenticationLogic logic =
  Get.find<TwoFactorAuthenticationLogic>();

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoFactorAuthenticationLogic>(builder: (logic) {
      return WillPopScope(
        onWillPop: logic.onBackPress,
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: BlueBackground(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 52,
                  bottom: 22,
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _titleWidget(),
                            const SizedBox(height: 20),
                            _secureWidget(),
                            const SizedBox(
                              height: 70,
                            ),
                            Center(
                              child: SvgPicture.asset(
                                Res.pan,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            _panSubTitleText(),
                            const SizedBox(
                              height: 60,
                            ),
                            _panHelpText(),
                            const SizedBox(
                              height: 20,
                            ),
                            _panWidget(),
                            const SizedBox(
                              height: 8,
                            ),
                            _errorWidget(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buttonAndHelpText()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _panHelpText() {
    return const Text(
      "Enter last 5 digits of your PAN card",
      style: TextStyle(
        fontSize: 10,
        fontFamily: 'Figtree',
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _panWidget() {
    return Row(
      children: [
        ..._preFilledPanWidget(),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: _panInputWidget(),
        ),
      ],
    );
  }

  List<Widget> _preFilledPanWidget() {
    return logic.maskedPanValue
        .split("")
        .map(
          (e) => _preFilledTextWidget(e),
    )
        .toList();
  }

  Widget _preFilledTextWidget(String letter) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        letter,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.14,
        ),
      ),
    );
  }

  Widget _secureWidget() {
    return Row(
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          child: Text(
            "Secure your loan details with PAN card verification",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _panInputWidget() {
    return SizedBox(
      width: Get.width,
      height: 40,
      child: Pinput(
        length: 5,
        onChanged: (value) {
          logic.onPanInput();
        },
        defaultPinTheme: _otpTextFieldTheme(),
        focusNode: logic.pinPutFocusNode,
        controller: logic.pinPutController,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.name,
        useNativeKeyboard: true,
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      "Verify that it's you",
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.14,
      ),
    );
  }

  Widget _panSubTitleText() {
    return const Center(
      child: Text(
        "To verify ownership of your account, please provide\nthe last 5 digits of your PAN Card.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontFamily: 'Figtree',
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return GetBuilder<TwoFactorAuthenticationLogic>(
      id: logic.ERROR_TEXT_KEY,
      builder: (logic) {
        if (logic.errorMessage.isNotEmpty) {
          return Text(
            logic.errorMessage,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Figtree',
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buttonAndHelpText() {
    return GetBuilder<TwoFactorAuthenticationLogic>(
      id: logic.VERIFY_BUTTON_KEY,
      builder: (logic) {
        return Column(
          children: [
            GradientButton(
              onPressed: logic.onVerifyPressed,
              isLoading: logic.isLoading,
              buttonTheme: AppButtonTheme.light,
              title: logic.buttonText,
              enabled: logic.isButtonEnabled,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white
              ),
            ),
            logic.isLoading ? _loadingHelpText() : const SizedBox(),
          ],
        );
      },
    );
  }

  Widget _loadingHelpText() {
    return const Text(
      "Verifying PAN card details...",
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Figtree',
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  PinTheme _otpTextFieldTheme() {
    return PinTheme(
      decoration: BoxDecoration(
          color: const Color(0xff385789).withOpacity(0.31),
          border: Border.all(color: skyBlueColor)),
      textStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
