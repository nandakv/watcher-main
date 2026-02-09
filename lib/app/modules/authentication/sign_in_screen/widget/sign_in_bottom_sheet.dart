import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/otp_bottom_sheet.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/flavors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'rich_text_consent_checkbox.dart';

class SignInBottomSheet extends StatelessWidget with SignInFieldValidator {
  final logic = Get.find<SignInScreenLogic>();

  SignInBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInScreenLogic>(
        id: logic.BUTTON_KEY,
        builder: (logic) {
          return PopScope(
            canPop: !logic.isButtonLoading,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _crossButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _computeBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _computeBody() {
    return GetBuilder<SignInScreenLogic>(builder: (logic) {
      switch (logic.signInPageState) {
        case SignInPageState.phoneNumber:
          return _mobileNumberInput(logic);
        case SignInPageState.otp:
          return OtpBottomSheet();
      }
    });
  }

  Column _mobileNumberInput(SignInScreenLogic logic) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "Mobile Number",
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkBlueColor),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        const Flexible(
          child: Row(
            children: [
              Text(
                "Enter mobile number linked to your ",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "Aadhaar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        verticalSpacer(24),
        _mobileNoInputField(),
        verticalSpacer(32),
        _consentCheckBox(),
        verticalSpacer(24),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 102),
            child: GetBuilder<SignInScreenLogic>(
              id: logic.BUTTON_KEY,
              builder: (logic) {
                return GradientButton(
                  onPressed:
                      logic.signInPageState == SignInPageState.phoneNumber
                          ? logic.onContinueTapped
                          : logic.onConfirmPinSubmitted,
                  isLoading: logic.isButtonLoading,
                  buttonTheme: AppButtonTheme.dark,
                  enabled: logic.computeIsButtonEnabled(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  GetBuilder<SignInScreenLogic> _consentCheckBox() {
    return GetBuilder<SignInScreenLogic>(
        id: logic.PAN_CHECK_BOX_KEY,
        builder: (logic) {
          return RichTextConsentCheckBox(
            consentCheckBoxValue: logic.panConsentCheckBoxValue,
            onChanged: (value) => logic.panConsentCheckBoxValue = value!,
            consentTextList: [
              RichTextModel(
                text:
                    "I authorize Kisetsu Saison Finance (India) Private Limited (KSF) to perform my Credit check with credit bureaus, to search / download your KYC details through CKYCR, run a PAN validation through NSDL, and share necessary information with third-parties if required for any additional verification and processing of my loan application. I also agree to Experian's ",
                textStyle: _consentTextStyle(),
              ),
              RichTextModel(
                text: "T&C.",
                onTap: () {
                  launchUrlString(
                    F.envVariables.experianTnCUrl,
                    mode: LaunchMode.inAppWebView,
                  );
                },
                textStyle: _consentTextStyle(
                    color: darkBlueColor, decoration: TextDecoration.underline),
              )
            ],
          );
        });
  }

  TextStyle _consentTextStyle(
      {Color color = primaryDarkColor, TextDecoration? decoration}) {
    return TextStyle(
      fontSize: 10,
      letterSpacing: 0.112,
      color: color,
      decoration: decoration,
    );
  }

  Widget _mobileNoInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GetBuilder<SignInScreenLogic>(
        id: logic.TEXTFIELD_KEY,
        builder: (logic) {
          return PrivoTextFormField(
            id: 'SIGNIN',
            controller: logic.mobileNoController,
            validator: validatePhoneNumber,
            maxLength: 10,
            enabled: !logic.isButtonLoading,
            focusNode: logic.mobileNoFocusNode,
            onFieldSubmitted: (value) => logic.onContinueTapped(),
            onChanged: (value) => logic.setNumber = value,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: _textFieldTextStyle(),
            decoration: _mobileNumberTextFieldInputDecoration(),
          );
        },
      ),
    );
  }

  TextStyle _textFieldTextStyle() {
    return const TextStyle(
      fontSize: 16,
      color: primaryDarkColor,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _mobileNumberHintTextStyle() {
    return const TextStyle(
      color: Color(0xff93A5C7),
      fontSize: 14,
    );
  }

  InputDecoration _mobileNumberTextFieldInputDecoration() {
    return InputDecoration(
      hintStyle: _mobileNumberHintTextStyle(),
      counterText: '',
      prefixIcon: const Text(
        '+91  ',
        style: TextStyle(
          fontSize: 16,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w400,
          color: secondaryDarkColor,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      errorText: logic.errorText,
    );
  }

  Widget _crossButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Visibility(
        visible: !logic.isButtonLoading && !logic.showVerfied,
        child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: logic.onCloseTapped,
            child: SvgPicture.asset(Res.close_mark_svg),
          ),
        ),
      ),
    );
  }
}
